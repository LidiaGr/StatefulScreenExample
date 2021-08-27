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
    @IBOutlet private weak var textLabel1: UILabel!
    @IBOutlet private weak var textLabel2: UILabel!
    
    @IBAction func backToATapped(_ sender: Any) {
        performSegue(withIdentifier: "toMain", sender: self)
    }
    
    let plusLabel = UILabel()
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 38, height: 46))
    
    var spinner: UIActivityIndicatorView! = {
        let loginSpinner = UIActivityIndicatorView(style: .large)
        loginSpinner.color = UIColor(hexString: "#34BC48")
        loginSpinner.translatesAutoresizingMaskIntoConstraints = false
        loginSpinner.hidesWhenStopped = true
        return loginSpinner
    }()
    
    // Service Views
    private let errorMessageView = ErrorMessageView()
    
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

        
        sendCodeButton.isEnabled = true
        sendCodeButton.alpha = 0.5
        
        view.addStretchedToBounds(subview: errorMessageView)
        view.addStretchedToBounds(subview: spinner)
    }
}

// MARK: - BindableView

extension AuthorizationViewController: BindableView {
    
    func getOutput() -> AuthorizationViewOutput { viewOutput }
    
    func bindWith(_ input: AuthorizationPresenterOutput) {
        disposeBag.insert {
            
            input.phoneField.drive(onNext: { [weak self] number in
                self?.phoneNumberField.text = number
            })
            
            input.isButtonActive.emit(onNext: { value in
                if value == true {
                    self.sendCodeButton.alpha = 1
                    self.sendCodeButton.isEnabled = true
                } else {
                    self.sendCodeButton.alpha = 0.5
                    self.sendCodeButton.isEnabled = false
                }
            })
            
            input.showError.emit(onNext: { [unowned self] maybeViewModel in
                self.errorMessageView.isVisible = (maybeViewModel != nil)
                
                if let viewModel = maybeViewModel {
                    self.errorMessageView.resetToEmptyState()
                    
                    self.errorMessageView.setTitle(viewModel.title, buttonTitle: viewModel.buttonTitle, action: {
                        self.viewOutput.$retryAuthorizationButtonTap.accept(Void())
                    })
                }
            })
            
            input.isPhoneFieldEditing.emit(onNext: { value in
                if value == true {
                    self.plusLabel.textColor = UIColor(hexString: "#4F4E57")
                } else {
                    self.plusLabel.textColor = UIColor(hexString: "#ACAAB2")
                }
            })
            
            input.loadingIndicator.emit(onNext: { [unowned self] indicator in
                switch indicator == true {
                case true: spinner.startAnimating()
                case false: spinner.stopAnimating()
                }
            })
            
            input.isContentVisible.drive(phoneNumberField.rx.isVisible)
            input.isContentVisible.drive(sendCodeButton.rx.isVisible)
            input.isContentVisible.drive(textLabel1.rx.isVisible)
            input.isContentVisible.drive(textLabel2.rx.isVisible)
            
            input.sendButtonTapped.emit(onNext: { _ in
                let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if granted {
                      print("User gave permission for local notifications")
                    }
                }
                notificationCenter.delegate = self
            })
            
            phoneNumberField.rx.text.orEmpty.bind(to: viewOutput.$phoneNumberUpdateTap)
            sendCodeButton.rx.controlEvent(.touchUpInside).bind(to: viewOutput.$sendCodeButtonTap)
        }
    }
}

// MARK: - View Output

extension AuthorizationViewController {
    private struct ViewOutput: AuthorizationViewOutput {
        
        @PublishControlEvent var phoneNumberUpdateTap: ControlEvent<String>
        
        @PublishControlEvent var sendCodeButtonTap: ControlEvent<Void>
        
        @PublishControlEvent var retryAuthorizationButtonTap: ControlEvent<Void>
        
    }
}

// MARK: - RibStoryboardInstantiatable

extension AuthorizationViewController: RibStoryboardInstantiatable {}


// MARK: - Notification Center

extension AuthorizationViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // обработка после перехода в приложение по нажатию на уведомление
    }
}
