//
//  TestRegisterViewController.swift
//  AwsAmplifyDemo
//
//  Created by Sherif Abd El-Moniem on 31/01/2021.
//

// apply mvp to be isolated
import UIKit
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var buttonAction: UIButton!
    
    @IBOutlet weak var passwordTF: UITextField!
    let loginViewModel = LoginViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup(){
        bindTextFieldsToViewModel()
        subscribeToLoading()
        subscribeToResponse()
        subscribeToLoginButton()
    }
    
    
    
    func bindTextFieldsToViewModel() {
        userNameTF.rx.text.orEmpty.bind(to: loginViewModel.userNameeBehavior).disposed(by: disposeBag)
        passwordTF.rx.text.orEmpty.bind(to: loginViewModel.passwordBehavior).disposed(by: disposeBag)
    }
    func subscribeToLoading() {
        loginViewModel.loadingIndicatorBehavior.subscribe(onNext: { (isLoading) in
            if isLoading {
                self.showIndicator(withTitle: "", and: "")
            } else {
                self.hideIndicator()
            }
        }).disposed(by: disposeBag)
    }
    func subscribeToResponse() {
        loginViewModel.loginModelObservable.subscribe(onNext: {_ in
            DispatchQueue.main.async {
                if let countriesVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CountriesViewController") as? CountriesViewController {
                   self.present(countriesVC, animated: true)
                }
            }
            
        }).disposed(by: disposeBag)
    }
 
    func subscribeToLoginButton() {
        buttonAction.rx.tap
            .throttle(RxTimeInterval.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self](_) in
                guard let self = self else { return }
                self.loginViewModel.signIn()
        }).disposed(by: disposeBag)
    }

}
