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
    private let firstNameView = ProfileField()
    private let lastNameView = ProfileField()
    private let phoneView = ProfileField()
    private let emailView = ProfileField()
    
    private let saveButton = GreenButton()
    
    // MARK: View Events
    
    private let viewOutput = ViewOutput()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        initialSetup()
        tapGesturesInitialSetup()
    }
}

extension EditProfileViewController {
    private func initialSetup() {
        title = "Редактировать"
        
        
        // StackView ContactFields
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        firstNameView.design()
        lastNameView.design()
        phoneView.design()
        emailView.design()
        
        stackView.addArrangedSubviews([
            firstNameView,
            lastNameView,
            phoneView,
            emailView
        ])
        
        //Button
        saveButton.design()
        view.addSubview(saveButton)
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    private func tapGesturesInitialSetup() {
        do {
            let tapGesture = UITapGestureRecognizer()
            firstNameView.addGestureRecognizer(tapGesture)
            tapGesture.rx.event.mapAsVoid().bind(to: viewOutput.$nameUpdateTap).disposed(by: disposeBag)
        }

        do {
            let tapGesture = UITapGestureRecognizer()
            lastNameView.addGestureRecognizer(tapGesture)
            tapGesture.rx.event.mapAsVoid().bind(to: viewOutput.$lastNameUpdateTap).disposed(by: disposeBag)
        }

        do {
            let tapGesture = UITapGestureRecognizer()
            emailView.addGestureRecognizer(tapGesture)
            tapGesture.rx.event.mapAsVoid().bind(to: viewOutput.$emailUpdateTap).disposed(by: disposeBag)
        }
    }
}

// MARK: - BindableView

extension EditProfileViewController: BindableView {

    func getOutput() -> EditProfileViewOutput {
      viewOutput
    }
    
    func bindWith(_ input: EditProfilePresenterOutput) {
        bindViewModel(input.viewModel)
    }
    
    private func bindViewModel(_ profileViewModel: Driver<EditProfileViewModel>) {
        profileViewModel.map { $0.firstName }.drive(onNext: { [unowned self] viewModel in
            firstNameView.setTitle(viewModel.title, text: viewModel.maybeText, editable: true)
        }).disposed(by: disposeBag)
        
        profileViewModel.map { $0.lastName }.drive(onNext: { [unowned self] viewModel in
            lastNameView.setTitle(viewModel.title, text: viewModel.maybeText, editable: true)
        }).disposed(by: disposeBag)
        
        profileViewModel.map { $0.email }.drive(onNext: { [unowned self] viewModel in
            emailView.setTitle(viewModel.title, text: viewModel.maybeText, editable: true)
        }).disposed(by: disposeBag)
        
        profileViewModel.map { $0.phone }.drive(onNext: { [unowned self] viewModel in
            phoneView.setTitle(viewModel.title, text: viewModel.text, editable: false)
        }).disposed(by: disposeBag)
    }
}

// MARK: - View Output

extension EditProfileViewController {
    private struct ViewOutput: EditProfileViewOutput {
        
        @PublishControlEvent var nameUpdateTap: ControlEvent<Void>
        
        @PublishControlEvent var lastNameUpdateTap: ControlEvent<Void>
        
        @PublishControlEvent var emailUpdateTap: ControlEvent<Void>
        
        @PublishControlEvent var saveButtonTap: ControlEvent<Void>
        
        @PublishControlEvent var retryButtonTap: ControlEvent<Void>
    }
}
