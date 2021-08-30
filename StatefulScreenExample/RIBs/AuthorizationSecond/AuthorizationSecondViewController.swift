//
//  AuthorizationSecondViewController.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 26.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

final class AuthorizationSecondViewController: UIViewController, AuthorizationSecondViewControllable {
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var codeInputField: UITextField!
    
    @IBAction func backToAuthorizationTapped(_ sender: Any) {
        performSegue(withIdentifier: "toAuthorization", sender: self)
    }
    
    var spinner: UIActivityIndicatorView! = {
        let loginSpinner = UIActivityIndicatorView(style: .large)
        loginSpinner.color = UIColor(hexString: "#34BC48")
        loginSpinner.translatesAutoresizingMaskIntoConstraints = false
        loginSpinner.hidesWhenStopped = true
        return loginSpinner
    }()
    
    // MARK: View Events
    
    private let viewOutput = ViewOutput()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        initialSetup()
    }
}

extension AuthorizationSecondViewController {
    private func initialSetup() {
        codeInputField.tintColor = UIColor(hexString: "#34BC48")
        codeInputField.textAlignment = .center
        
        view.addStretchedToBounds(subview: spinner)
    }
}

// MARK: - BindableView

extension AuthorizationSecondViewController: BindableView {
    func getOutput() -> AuthorizationSecondViewOutput { viewOutput }
    
    func bindWith(_ input: AuthorizationSecondPresenterOutput) {
        disposeBag.insert {
            
            input.phoneLabel.drive(onNext: { [weak self] number in
                self?.phoneNumberLabel.text = number
            })
            
            input.codeField.drive(onNext: { [weak self] code in
                self?.codeInputField.text = code
            })
            
            input.loadingIndicator.emit(onNext: { [unowned self] indicator in
                switch indicator == true {
                case true: spinner.startAnimating()
                case false: spinner.stopAnimating()
                }
            })
            
            input.failure.emit(onNext: { _ in
                self.textLabel.text = "Ошибка"
                self.textLabel.textColor = UIColor(hexString: "#FF6464")
                self.codeInputField.text = ""
                self.spinner.stopAnimating()
            })
            
            input.success.emit(onNext: { [weak self] in
                self?.spinner.stopAnimating()
                self?.performSegue(withIdentifier: "toMain", sender: self)
            })
            
            input.inputStarted.emit(onNext: { _ in
                self.textLabel.text = "Введите код из смс, отправленного на номер"
                self.textLabel.textColor = UIColor(hexString: "#ACAAB2")
            })
            
            codeInputField.rx.text.orEmpty.bind(to: viewOutput.$codeUpdateTap)
        }
    }
}

// MARK: - View Output

extension AuthorizationSecondViewController {
    private struct ViewOutput: AuthorizationSecondViewOutput {
        @PublishControlEvent var codeUpdateTap: ControlEvent<String>
    }
}

// MARK: - RibStoryboardInstantiatable

extension AuthorizationSecondViewController: RibStoryboardInstantiatable {}
