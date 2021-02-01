//
//  TestRegisterViewController.swift
//  AwsAmplifyDemo
//
//  Created by Sherif Abd El-Moniem on 31/01/2021.
//

import UIKit

class TestRegisterViewController: UIViewController, AccountTextFieldDelegate {
    func fieldShouldReturn(editableFieldView: AccountTextField) {
        print(editableFieldView.getText())
    }
    
    func textFieldBeginEditing(editableFieldView: AccountTextField) {
        print(editableFieldView.getText())
        editableFieldView.edditErrorMessage.isHidden = true
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
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        if let checkCompleteDate = checkEnteredData () {
            checkCompleteDate.field.setInErrorMode(error: checkCompleteDate.message)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    func checkEnteredData () -> (field: AccountTextField, message: String)? {
       
            guard let name  = nameView.getText() ,!name.isEmpty else {
                return (nameView, "missing data")
            }
        if name.count < 2 {
            return (nameView, "name is too short")
        }
        guard let email  = emailView.getText() ,!email.isEmpty else {
            return (emailView, "missing data")
        }
        if email.count < 2 {
            return (emailView, "email is too short")
        }
        guard let password  = passwordView.getText() ,!password.isEmpty else {
            return (passwordView, "missing data")
        }
            if password.count < 8 {
                return (passwordView, "password should be at least 8 digits")
            }
        return nil
        }
}
