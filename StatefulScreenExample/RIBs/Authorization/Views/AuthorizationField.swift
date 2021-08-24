//
//  AuthorizationField.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import UIKit

final class AuthorizationField: UITextField {
    
    func design () {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        self.leftView = paddingView
        self.leftViewMode = .always
        
        
        self.tintColor = UIColor(hexString: "#34BC48")
        self.attributedPlaceholder = NSAttributedString(string: "+7",
                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.3)])
    }
}
