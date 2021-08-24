//
//  AuthorizationViewController.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

final class AuthorizationViewController: UIViewController, AuthorizationViewControllable {
    
    @IBOutlet private weak var phoneNumberField: UITextField!
    @IBOutlet private weak var sendCodeButton: UIButton!
    
    let plusLabel = UILabel()
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 46))
    
    // MARK: View Events
    
    private let viewOutput = ViewOutput()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        initialSetup()
    }
}

extension AuthorizationViewController {
    private func initialSetup() {
        plusLabel.text = "+7"
        plusLabel.font = UIFont.systemFont(ofSize: 17)
        plusLabel.textColor = UIColor(hexString: "#ACAAB2")
        plusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        paddingView.addSubview(plusLabel)
        plusLabel.leftAnchor.constraint(equalTo: paddingView.leftAnchor, constant: 16).isActive = true
        plusLabel.rightAnchor.constraint(equalTo: paddingView.rightAnchor, constant: -6).isActive = true
        plusLabel.centerYAnchor.constraint(equalTo: paddingView.centerYAnchor).isActive = true
        
        phoneNumberField.leftView = paddingView
        phoneNumberField.leftViewMode = .always
        
        phoneNumberField.tintColor = UIColor(hexString: "#34BC48")

        phoneNumberField.delegate = self.phoneNumberField
    }
}

// MARK: - BindableView

extension AuthorizationViewController: BindableView {
    
    func getOutput() -> AuthorizationViewOutput { viewOutput }
    
    func bindWith(_ input: AuthorizationPresenterOutput) {
        
    }
}

// MARK: - View Output

extension AuthorizationViewController {
    private struct ViewOutput: AuthorizationViewOutput {
        
        @PublishControlEvent var phoneNumberUpdateTap: ControlEvent<String>
        
        @PublishControlEvent var sendCodeButtonTap: ControlEvent<Void>
        
        @PublishControlEvent var retryButtonTap: ControlEvent<Void>
        
    }
}

// MARK: - RibStoryboardInstantiatable

extension AuthorizationViewController: RibStoryboardInstantiatable {}
