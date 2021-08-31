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

extension String {
    /// mask example: `+X (XXX) XXX-XXXX`
    func formatPhoneNumber(with mask: String) -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator
        
        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])
                
                // move numbers iterator to the next index
                index = numbers.index(after: index)
                
            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
}

// MARK: - CharacterSet

extension CharacterSet {
    /// "0123456789"
    public static let arabicNumerals = CharacterSet(charactersIn: "0123456789")
    
    public static let russianLetters = CharacterSet(charactersIn: "абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ")
}

extension String {
    /// Удалятся все символы (Unicode Scalar'ы) кроме символов из указанного CharacterSet. Например все кроме цифр
    public func removingCharacters(except characterSet: CharacterSet) -> String {
        let scalars = unicodeScalars.filter(characterSet.contains(_:))
        return String(scalars)
    }
    
    /// Удалятся все символы (Unicode Scalar'ы), которые соответствуют указанному CharacterSet.
    /// Например все точки и запятые
    public func removingCharacters(in characterSet: CharacterSet) -> String {
        let scalars = unicodeScalars.filter { !characterSet.contains($0) }
        return String(scalars)
    }
}
