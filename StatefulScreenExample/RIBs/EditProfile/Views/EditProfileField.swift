//
//  EditProfileField.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import UIKit

final class EditProfileField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 40)
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override public func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func design() {
        self.textAlignment = .left
        self.backgroundColor = UIColor(hexString: "#F7F7F7")
        self.font = UIFont.systemFont(ofSize: 17)
        self.layer.cornerRadius = 12
        self.textColor = UIColor(hexString: "#4F4E57")
        self.tintColor = UIColor(hexString: "#34BC48")
        self.autocorrectionType = UITextAutocorrectionType.no
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.clearButtonMode = UITextField.ViewMode.whileEditing
        self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        
        self.layer.borderWidth = 0
        self.layer.borderColor = .none
        
        if let clearButton = self.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(named: "close"), for: .normal)
        }
        
        self.heightAnchor.constraint(equalToConstant: 46).isActive = true
    }
    
    func setTitle(_ title: String, text: String?, editable: Bool) {
        self.attributedPlaceholder = NSAttributedString(string: title,
                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.3)])
        self.text = text
        self.isUserInteractionEnabled = editable
        
        if !editable {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor(hexString: "#CBC9D1").cgColor
            self.textColor = UIColor(hexString: "#ACAAB2")
        }
    }
    
    func showErrorField() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(hexString: "#FFE0E0").cgColor
        self.textColor = UIColor(hexString: "#FF6464")
    }
}
