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
    
    // MARK: Service Views
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

extension EditProfileViewController {
    private func initialSetup() {
        title = "Редактировать"
        
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
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -42).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
}

// MARK: - BindableView

extension EditProfileViewController: BindableView {
    
    func getOutput() -> EditProfileViewOutput { viewOutput }
    
    func bindWith(_ input: EditProfilePresenterOutput) {
        disposeBag.insert {
            
            input.isContentVisible.drive(stackView.rx.isVisible)
            input.isContentVisible.drive(saveButton.rx.isVisible)
            
            input.showFirstNameError.emit(onNext: { [weak self] in self?.firstNameField.showErrorField() })
            input.hideFirstNameError.emit(onNext: { [weak self] in self?.firstNameField.design() })
            
            input.showEmailError.emit(onNext: { [weak self] in self?.emailField.showErrorField() })
            input.hideEmailError.emit(onNext: { [weak self] in self?.emailField.design() })
            
            
            input.viewModel.drive(onNext: { [weak self] model in
                self?.firstNameField.setTitle(model.firstName.title, text: model.firstName.maybeText, editable: true)
                
                self?.lastNameField.setTitle(model.lastName.title, text: model.lastName.maybeText, editable: true)
                
                self?.emailField.setTitle(model.email.title, text: model.email.maybeText, editable: true)
                
                self?.phoneField.setTitle(model.phone.title, text: model.phone.text.formatPhoneNumber(with: "+X XXX XXX XX XX"), editable: false)
            })
            
            input.showError.emit(onNext: { [weak self] maybeViewModel in
                self?.errorMessageView.isVisible = (maybeViewModel != nil)
                
                if let viewModel = maybeViewModel {
                    self?.errorMessageView.resetToEmptyState()
                    
                    self?.errorMessageView.setTitle(viewModel.title, buttonTitle: viewModel.buttonTitle, action: {
                        self?.viewOutput.$retryButtonTap.accept(Void())
                    })
                }
            })
            
            input.showAlert.emit(onNext: { [weak self] _ in
                let alert = UIAlertController(title: "Профиль успешно обновлён", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in self?.navigationController?.popViewController(animated: false) }))
                
                self?.present(alert, animated: true, completion: nil)
            } )
            
            input.loadingIndicator.emit(onNext: { [weak self] indicator in
                switch indicator == true {
                case true: self?.spinner.startAnimating()
                case false: self?.spinner.stopAnimating()
                }
            })
            
            firstNameField.rx.text.orEmpty.bind(to: viewOutput.$firstNameChange)
            lastNameField.rx.text.orEmpty.bind(to: viewOutput.$lastNameChange)
            emailField.rx.text.orEmpty.bind(to: viewOutput.$emailChange)
            
            saveButton.rx.controlEvent(.touchUpInside).bind(to: viewOutput.$saveButtonTap)
        }
    }
}

// MARK: - View Output

extension EditProfileViewController {
    private struct ViewOutput: EditProfileViewOutput {
        
        @PublishControlEvent var firstNameChange: ControlEvent<String?>
        
        @PublishControlEvent var lastNameChange: ControlEvent<String?>
        
        @PublishControlEvent var emailChange: ControlEvent<String?>
        
        @PublishControlEvent var saveButtonTap: ControlEvent<Void>
        
        @PublishControlEvent var retryButtonTap: ControlEvent<Void>
    }
}
