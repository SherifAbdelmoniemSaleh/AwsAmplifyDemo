//
//  ViewController.swift
//  AwsAmplifyDemo
//
//  Created by Sherif Abd El-Moniem on 20/01/2021.
//

import UIKit
import Amplify
import AWSMobileClient
import AWSPluginsCore
import MBProgressHUD

class ViewController: UIViewController , UITextFieldDelegate{

    @IBOutlet weak var codeTextField: UITextField!
    var pinCodeString = ""
    public var isUIAuth : Bool = false  // authUI should be appeared
    override func viewDidLoad() {
        super.viewDidLoad()
        codeTextField.delegate = self
        if isUIAuth {
            checkSignInUI()
        }else{
                        checkSignIn()
        }
//        confirmSignUp (for: "ssaleh", with: "251492")
//        resetPassword(username: "ssaleh")
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let value = textField.text ?? ""
        pinCodeString = value
        print("value changed: \(value)")
        return true
    }
    @IBAction func signoutAction(_ sender: Any) {
        
       signOutLocally()
        
    }
    @IBAction func signupAction(_ sender: Any) {
        self.signUp (username: "ssaleh", password: "ssaleh1234", email: "sherief33392@gmail.com")
    }
    @IBAction func loginAction(_ sender: Any) {
        self.signIn (username: "msaleh", password: "msaleh1234")
    }
    @IBAction func resetPasswordAction(_ sender: Any) {
        
        confirmResetPassword(username: "ssaleh", newPassword: "ssalehNew", confirmationCode: pinCodeString)
    }
    
    @IBAction func changePasswordAction(_ sender: Any) {
        
            Amplify.Auth.update(oldPassword: "ssalehNew", to: "ssaleh1234") { result in
                switch result {
                case .success:
                    print("Change password succeeded")
                case .failure(let error):
                    print("Change password failed with error \(error)")
                }
            }
    }
    
    @IBAction func nextAction(_ sender: Any) {
        
    }
    
    
    func checkSignInUI(){
        if AWSMobileClient.default().isSignedIn{
            // if have account just fetch data
            if #available(iOS 13, *) {}else{}
        }else{
            let signOptions = SignInUIOptions  (canCancel: false)
            if let navCont = self.navigationController {
                AWSMobileClient.default().showSignIn(navigationController: navCont , signInUIOptions : signOptions) { (user, error) in
                    guard let er = error else {return}
                    print(er)
                    guard let state = user else {return}
                    switch state{
                    case .signedIn:
                        print("sign in")
                        print("\(AWSMobileClient.default().username ?? "2222")")
                    case .signedOut:
                        print("sign out")
                    case .signedOutFederatedTokensInvalid:
                        print("signedOutFederatedTokensInvalid")
                    case .signedOutUserPoolsTokenInvalid:
                        print("signedOutUserPoolsTokenInvalid")
                    case .guest:
                        print("guest")
                    case .unknown:
                        print("unknown")
                    }
                }
            }
        }
    }
    func checkSignIn(){
        self.fetchCurrentAuthSession ()
    }
    
    func fetchCurrentAuthSession () {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("Is user signed in - \(session.isSignedIn)")
            case .failure(let error):
                print("Fetch session failed with error \(error)")
            }
        }
    }
    
    func signIn (username: String, password: String) {
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            case .success(let signUpResult):
                let confirm = signUpResult.nextStep
                switch confirm {
                case .confirmSignInWithSMSMFACode(_, _):
                    break
                case .confirmSignInWithCustomChallenge(_):
                    break
                case .confirmSignInWithNewPassword(_):
                    // new password confirmation
                    print("confirmSignInWithNewPassword")
                case .resetPassword(_):
                    // reset password confirmation
                    print("resetPassword")
                case .confirmSignUp(_):
                    // signup confirmation
                    self.resendCodeForSignUp()
                case .done:
                    print("Done")
                    // go to home screen
                    Amplify.Auth.fetchAuthSession { result in
                        do {
                            let session = try result.get()

                            // Get user sub or identity id
                            if let identityProvider = session as? AuthCognitoIdentityProvider {
                                let usersub = try identityProvider.getUserSub().get()
                                let identityId = try identityProvider.getIdentityId().get()
                                print("User sub - \(usersub) and identity id \(identityId)")
                            }

                            // Get aws credentials
                            if let awsCredentialsProvider = session as? AuthAWSCredentialsProvider {
                                let credentials = try awsCredentialsProvider.getAWSCredentials().get()
                                print("Access key - \(credentials.accessKey) ")
                            }

                            // Get cognito user pool token
                            if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                                let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                                print("Id token - \(tokens.idToken) ")
                            }

                        } catch {
                            print("Fetch auth session failed with error - \(error)")
                        }
                    }
                }
                
            case .failure(let error):
                print("Sign in failed \(error)")
            }
        }
    }
    // resend verification code for unconfirmed sign up users
    func resendCodeForSignUp() {
        Amplify.Auth.resendSignUpCode(for: "ssaleh"){ result in
            switch result{
            case .success(let next) :
                print(next.destination)
            case .failure(let error):
                print("error is \(error)")
            }
        }
    }
    
    func resendConfirmationCode(){
        Amplify.Auth.resendConfirmationCode(for: .email) { result in
            switch result {
            
            case .success(let success):
                print(success.destination)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func signUp (username: String, password: String, email: String) {
        let userAttributes = [AuthUserAttribute(.email, value: email) , AuthUserAttribute(.gender, value: "male") ,AuthUserAttribute(.address , value: "salem eaid st") , AuthUserAttribute(.custom("city") ,value : "Alexandria")]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        Amplify.Auth.signUp(username: username, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                    self.confirmSignUp (for: "ssalehh", with: "665612")
                } else {
                    print("SignUp Complete")
                }
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
                
            
        }
    }
    }
    func confirmSignUp (for username: String, with confirmationCode: String) {
        Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            switch result {
            case .success:
                print("Confirm signUp succeeded")
            case .failure(let error):
                print("An error occurred while confirming sign up \(error)")
            }
        }
    }
    
    
    func signOutLocally() {
        Amplify.Auth.signOut() { result in
            switch result {
            case .success:
                print("Successfully signed out")
            case .failure(let error):
                print("Sign out failed with error \(error)")
            }
        }
    }
    
    func resetPassword(username: String) {
        Amplify.Auth.resetPassword(for: username) { result in
            do {
                let resetResult = try result.get()
                switch resetResult.nextStep {
                case .confirmResetPasswordWithCode(let deliveryDetails, let info):
                    print("Confirm reset password with code send to - \(deliveryDetails) \(info)")
                case .done:
                    print("Reset completed")
                }
            } catch {
                print("Reset password failed with error \(error)")
            }
        }
    }
    
    func confirmResetPassword(
        username: String,
        newPassword: String,
        confirmationCode: String
    ) {
        Amplify.Auth.confirmResetPassword(
            for: username,
            with: newPassword,
            confirmationCode: confirmationCode
        ) { result in
            switch result {
            case .success:
                print("Password reset confirmed")
            case .failure(let error):
                print("Reset password failed with error \(error)")
            }
        }
    }
}

extension UIViewController {
    func showIndicator(withTitle title: String, and description: String) {
        let indicator = MBProgressHUD.showAdded(to: self.view, animated: true)
        indicator.label.text = title
        indicator.isUserInteractionEnabled = false
        indicator.detailsLabel.text = description
        indicator.show(animated: true)
        self.view.isUserInteractionEnabled = false
    }
    func hideIndicator() {
        MBProgressHUD.hide(for: self.view, animated: true)
        self.view.isUserInteractionEnabled = true
    }
}
