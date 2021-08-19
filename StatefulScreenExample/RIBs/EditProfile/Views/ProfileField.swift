//
//  ProfileField.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import UIKit

final class ProfileField: UITextField {
    
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
//        self.attributedPlaceholder = NSAttributedString(string: placeholder,
//                                                        attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.3)])
        self.textAlignment = .left
        self.backgroundColor = UIColor(hexString: "#F7F7F7")
        self.font = UIFont.systemFont(ofSize: 17)
        self.layer.cornerRadius = 12
        self.textColor = UIColor(hexString: "#4F4E57")
//        self.borderStyle = .roundedRect
        self.autocorrectionType = UITextAutocorrectionType.no
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.clearButtonMode = UITextField.ViewMode.whileEditing
        self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//        self.isUserInteractionEnabled = editable
        
        if let clearButton = self.value(forKeyPath: "_clearButton") as? UIButton {
            clearButton.setImage(UIImage(named: "close"), for: .normal)
        }
        
        self.heightAnchor.constraint(equalToConstant: 46).isActive = true
        //    self.delegate = self
        
        //    textField.addTarget(self, action: #selector(buttonPressed), for: .editingDidEndOnExit)
        
//        if !editable {
//            self.layer.borderWidth = 1
//            self.layer.borderColor = UIColor(hexString: "#CBC9D1").cgColor
//            self.textColor = UIColor(hexString: "#ACAAB2")
//        }
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
