//
//  EditProfileViewController.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

final class EditProfileViewController: UIViewController, EditProfileViewControllable {
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    var spinner: UIActivityIndicatorView! = {
        let loginSpinner = UIActivityIndicatorView(style: .large)
        loginSpinner.color = UIColor(hexString: "#34BC48")
        loginSpinner.translatesAutoresizingMaskIntoConstraints = false
        loginSpinner.hidesWhenStopped = true
        return loginSpinner
    }()
    
    private let firstNameField = EditProfileField()
    private let lastNameField = EditProfileField()
    private let phoneField = EditProfileField()
    private let emailField = EditProfileField()
    
    private let saveButton = GreenButton()
    
    // Service Views
    private let errorMessageView = ErrorMessageView()
    
    // MARK: View Events
    
    private let viewOutput = ViewOutput()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        initialSetup()
//        tapGesturesInitialSetup()
    }
}

extension EditProfileViewController {
    private func initialSetup() {
        title = "Редактировать"
        
//        errorMessageView.isVisible = true
        view.addStretchedToBounds(subview: errorMessageView)
        view.addStretchedToBounds(subview: spinner)
        
        /// StackView ContactFields
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        firstNameField.design()
        lastNameField.design()
        phoneField.design()
        emailField.design()
        
        stackView.addArrangedSubviews([
            firstNameField,
            lastNameField,
            phoneField,
            emailField
        ])
        
        ///Button
        saveButton.design()
        view.addSubview(saveButton)
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
//    private func tapGesturesInitialSetup() {
//        do {
//            let tapGesture = UITapGestureRecognizer()
//            firstNameField.addGestureRecognizer(tapGesture)
//            tapGesture.rx.event.mapAsVoid().bind(to: viewOutput.$nameUpdateTap).disposed(by: disposeBag)
//        }
//
//        do {
//            let tapGesture = UITapGestureRecognizer()
//            lastNameField.addGestureRecognizer(tapGesture)
//            tapGesture.rx.event.mapAsVoid().bind(to: viewOutput.$lastNameUpdateTap).disposed(by: disposeBag)
//        }
//
//        do {
//            let tapGesture = UITapGestureRecognizer()
//            emailField.addGestureRecognizer(tapGesture)
//            tapGesture.rx.event.mapAsVoid().bind(to: viewOutput.$emailUpdateTap).disposed(by: disposeBag)
//        }
//
//        do {
//            let tapGesture = UITapGestureRecognizer()
//            saveButton.addGestureRecognizer(tapGesture)
//            tapGesture.rx.event.mapAsVoid().bind(to: viewOutput.$saveButtonTap).disposed(by: disposeBag)
//        }
//    }
}

// MARK: - BindableView

extension EditProfileViewController: BindableView {

    func getOutput() -> EditProfileViewOutput { viewOutput }
    
    func bindWith(_ input: EditProfilePresenterOutput) {
//        bindViewModel(input.viewModel)
        
        
        disposeBag.insert {
            
//            input.isContentViewVisible.drive(stackView.rx.isVisible)
            
//            input.isButtonActive.drive(saveButton.rx.isVisible)
            
            input.viewModel.drive(onNext: { [weak self] model in
//                print("IsEmailValid \(model.isEmailValid)")
                self?.firstNameField.setTitle(model.firstName.title, text: model.firstName.maybeText, editable: true, valid: model.isFirstNameValid)
        
                self?.lastNameField.setTitle(model.lastName.title, text: model.lastName.maybeText, editable: true, valid: nil)
                
                self?.emailField.setTitle(model.email.title, text: model.email.maybeText, editable: true, valid: model.isEmailValid)
                
                self?.phoneField.setTitle(model.phone.title, text: model.phone.text.formatPhoneNumber(with: "+X XXX XXX XX XX"), editable: false, valid: nil)
            })
            
            input.showError.emit(onNext: { [unowned self] maybeViewModel in
                self.errorMessageView.isVisible = (maybeViewModel != nil)
                
                if let viewModel = maybeViewModel {
                    self.saveButton.isHidden = true
                    self.stackView.isHidden = true
                    
                    self.errorMessageView.resetToEmptyState()
                    
                    self.errorMessageView.setTitle(viewModel.title, buttonTitle: viewModel.buttonTitle, action: {
                        self.viewOutput.$retryButtonTap.accept(Void())
                    })
                } else {
                    self.saveButton.isVisible = true
                    self.stackView.isVisible = true
                }
            })
            
            input.showAlert.emit(onNext: { [unowned self] alert in
                if alert == true {
                  let alert = UIAlertController(title: "Профиль успешно обновлён", message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in navigationController?.popViewController(animated: false) }))
                  
                  self.present(alert, animated: true, completion: nil)
                }
            } )
            
            input.loadingIndicator.emit(onNext: { [unowned self] indicator in
                switch indicator == true {
                case true: spinner.startAnimating()
                case false: spinner.stopAnimating()
                }
            })
            
            firstNameField.rx.text.orEmpty.bind(to: viewOutput.$firstNameUpdateTap)
            lastNameField.rx.text.orEmpty.bind(to: viewOutput.$lastNameUpdateTap)
            emailField.rx.text.orEmpty.bind(to: viewOutput.$emailUpdateTap)
            
            saveButton.rx.controlEvent(.touchUpInside).bind(to: viewOutput.$saveButtonTap)
        }
    }

}

// MARK: - View Output

extension EditProfileViewController {
    private struct ViewOutput: EditProfileViewOutput {
        
        @PublishControlEvent var firstNameUpdateTap: ControlEvent<String?>
        
        @PublishControlEvent var lastNameUpdateTap: ControlEvent<String?>
        
        @PublishControlEvent var emailUpdateTap: ControlEvent<String?>
        
        @PublishControlEvent var saveButtonTap: ControlEvent<Void>
        
        @PublishControlEvent var retryButtonTap: ControlEvent<Void>
    }
}
