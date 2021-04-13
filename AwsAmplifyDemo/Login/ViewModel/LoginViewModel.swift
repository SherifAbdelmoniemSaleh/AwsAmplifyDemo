//
//  LoginViewModel.swift
//  AwsAmplifyDemo
//
//  Created by Sherif Abd El-Moniem on 07/04/2021.
//

import Foundation
import RxSwift
import RxCocoa
import Amplify
import AWSMobileClient
import AWSPluginsCore
class LoginViewModel {
    
    var userNameeBehavior = BehaviorRelay<String>(value: "")
    var passwordBehavior = BehaviorRelay<String>(value: "")
    var loadingIndicatorBehavior = BehaviorRelay<Bool>(value: false)
    private var loginModelSubject = PublishSubject<Any>()  // can read , subscribe
    var loginModelObservable: Observable<Any> { // just observer to use in controller
        return loginModelSubject
    }
    
    func signIn () {
        Amplify.Auth.signIn(username: userNameeBehavior.value, password: passwordBehavior.value) { result in
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
                    self.loginModelSubject.onNext((Any).self)
                    print("Done")
                }
            case .failure(let error):
                print("Sign in failed \(error)")
            }
        }
    }
    
    // resend verification code for unconfirmed sign up users
    func resendCodeForSignUp() {
        Amplify.Auth.resendSignUpCode(for: userNameeBehavior.value){ result in
            switch result{
            case .success(let next) :
                print(next.destination)
            case .failure(let error):
                print("error is \(error)")
            }
        }
    }
}
