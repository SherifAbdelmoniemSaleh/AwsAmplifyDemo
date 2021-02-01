//
//  AccountTextField.swift
//  Saudi2Go
//
//  Created by Sherif Abd El-Moniem on 01/02/2021.
//  Copyright © 2021 GAMA Company. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

protocol  AccountTextFieldDelegate {
    func fieldShouldReturn (editableFieldView: AccountTextField)
    func textFieldEdit (editableFieldView: AccountTextField , text : String)

}
class AccountTextField : UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var edditErrorMessage: UILabel!
    
    @IBAction func showHideAction(_ sender: Any) {
    // shpw or hide password
        editButton.isSelected = !editButton.isSelected
        editTextField.isSecureTextEntry =  !editButton.isSelected
    }
   
    
    let nibName = "AccountTextField"
    var spaceAccepted: Bool = true
    var delegate: AccountTextFieldDelegate!
    
    @IBInspectable var placeholder: String{
        get{
            return self.editTextField.placeholder ?? ""
        } set{
            self.editTextField.placeholder = newValue
        }
    }
    
    @IBInspectable var keyboardType: UIKeyboardType {
        get{
            return self.editTextField.keyboardType
        } set{
            self.editTextField.keyboardType = newValue
        }
    }
    
    @IBInspectable var returnType: UIReturnKeyType {
        get{
            return self.editTextField.returnKeyType
        } set{
            editTextField.returnKeyType = newValue
        }
    }
    
    @IBInspectable var isSpaceAccepted: Bool {
        get{
            return spaceAccepted
        } set {
            spaceAccepted = newValue
        }
    }
    required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setupView()
    }
    
    override init(frame:CGRect) {
        super.init(frame:frame)
        
        setupView()
        
    }
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    
    func setupView(){
        contentView = loadViewFromNib()
        contentView.frame = bounds
        self.addSubview(contentView)
        editButton.isHidden = true
        edditErrorMessage.isHidden = true
        editTextField.delegate = self
    }
    
    func getText () -> String? {
        return editTextField.text
    }
    func setInErrorMode (error: String) {
        edditErrorMessage.isHidden = false
        edditErrorMessage.text = error
    }
    
}
extension AccountTextField : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let delegate = delegate {
            delegate.fieldShouldReturn(editableFieldView: self)
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
            if let delegate = delegate  {
                delegate.fieldShouldReturn(editableFieldView: self)
            }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newText = (textField.text! as NSString).replacingCharacters(in: range, with: string)

        if !spaceAccepted {
            if (newText == " ") {
                return false
            }
        }
        if let delegate = delegate  {
            delegate.textFieldEdit(editableFieldView: self, text: newText)
        }
//        textFieldEdit
        return true
    }

}
