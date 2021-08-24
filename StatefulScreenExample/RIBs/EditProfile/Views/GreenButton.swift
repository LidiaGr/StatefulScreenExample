//
//  GreenButton.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import UIKit

final class GreenButton: UIButton {
    func design() {
        self.setTitle("Сохранить", for: .normal)
        self.backgroundColor = UIColor(hexString: "#34BC48")
        self.setTitleColor(UIColor.white, for: .normal)
        self.layer.cornerRadius = 12
        self.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
