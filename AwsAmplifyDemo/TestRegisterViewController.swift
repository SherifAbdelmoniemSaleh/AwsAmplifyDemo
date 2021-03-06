//
//  TestRegisterViewController.swift
//  AwsAmplifyDemo
//
//  Created by Sherif Abd El-Moniem on 31/01/2021.
//

import UIKit

class TestRegisterViewController: UIViewController, AccountTextFieldDelegate {
    func fieldShouldReturn(editableFieldView: AccountTextField) {
        switch editableFieldView {
        case self.emailView:
            nameView.editTextField.becomeFirstResponder()
        case self.nameView:
            passwordView.editTextField.becomeFirstResponder()
        case self.passwordView:
            editableFieldView.endEditing(true)
            self.buttonAction(UIButton())
        default:
            break
        }
    }
    
    func textFieldEdit(editableFieldView: AccountTextField , text : String) {
        if let checkCompleteDate = checkEnteredData (field: editableFieldView ,text : text) {
            editableFieldView.setInErrorMode(error: checkCompleteDate)
        }else{
            editableFieldView.edditErrorMessage.isHidden = true
        }
        print(text)
    }
    
    let viewModel = TestRegisterViewModel()
    @IBOutlet weak var emailView: AccountTextField!
    @IBOutlet weak var nameView: AccountTextField!
    @IBOutlet weak var passwordView: AccountTextField!
    
    @IBOutlet weak var buttonAction: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
    func setup(){
        emailView.delegate = self
        emailView.setupView()
        nameView.delegate = self
        nameView.setupView()
        passwordView.delegate = self
        passwordView.setupView()
        passwordView.editButton.isHidden = false
        passwordView.editTextField.returnKeyType = .go
        passwordView.editTextField.isSecureTextEntry = true
        passwordView.editTextField.placeholder = "password"
        nameView.editTextField.placeholder = "name"
        emailView.editTextField.placeholder = "email"
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        if emailView.edditErrorMessage.isHidden && passwordView.edditErrorMessage.isHidden && nameView.edditErrorMessage.isHidden  && !emailView.getText()!.isEmpty &&  !nameView.getText()!.isEmpty &&  !passwordView.getText()!.isEmpty{
            print("all fields is validated")
        }else {
            print("please verify all fields")
        }
    }
    
    
    func isValidEmail(_ param: String) -> Bool {
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let paramPred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return paramPred.evaluate(with: param)
    }
    
    func checkEnteredData (field: AccountTextField , text : String ) -> (String)? {
        
        if field == nameView {
            if text.isEmpty {
                return ("missing data")
            }
            if text.count < 2 {
                return ("name is too short")
            }
        }
        
        if field == emailView {
            if text.isEmpty  {
                return ( "missing data")
            }
            if !isValidEmail( text){
                return ("email is wrong")
            }
        }
        
        if  field == passwordView {
            if text.isEmpty {
                return ("missing data")
            }
            if text.count < 8 {
                return ("password should be at least 8 digits")
            }
        }
        return nil
    }
}
