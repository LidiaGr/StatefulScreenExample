//
//  ProfileEditViewController.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 12.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

final class ProfileEditViewController: UIViewController, ProfileViewControllable {
//    @IBOutlet private weak var scrollView: UIScrollView!
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
//    private let refreshControl = UIRefreshControl().
    
    private let firstNameView = ContactField()
    private let lastNameView = ContactField()
    private let phoneView = ContactField()
    private let emailView = ContactField()
    
    private let saveButton = GreenButton()
    
    // Service Views
//    private let loadingIndicatorView = LoadingIndicatorView()
//    private let errorMessageView = ErrorMessageView()
    
    // MARK: View Events
    
    private let viewOutput = ViewOutput()
//
//    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.barTintColor = UIColor.orange
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
}

extension ProfileEditViewController {
    private func initialSetup() {
        title = "Редактировать"
        
//        scrollView.refreshControl = refreshControl
//
//        errorMessageView.isVisible = false
        
//        view.addStretchedToBounds(subview: loadingIndicatorView)
//        view.addStretchedToBounds(subview: errorMessageView)
        
        // StackView ContactFields
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        
        firstNameView.design(placeholder: "Имя", editable: true)
        lastNameView.design(placeholder: "Фамилия", editable: true)
        phoneView.design(placeholder: "Телефон", editable: false)
        emailView.design(placeholder: "E-mail", editable: true)
        
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
        
//        tapGesturesInitialSetup()
    }
    
//    private func tapGesturesInitialSetup() {
//        do {
//            let tapGesture = UITapGestureRecognizer()
//            emailView.addGestureRecognizer(tapGesture)
//            tapGesture.rx.event.mapAsVoid().bind(to: viewOutput.$emailUpdateTap).disposed(by: disposeBag)
//        }
//
//        do {
//            let tapGesture = UITapGestureRecognizer()
//            addEmailView.addGestureRecognizer(tapGesture)
//            tapGesture.rx.event.mapAsVoid().bind(to: viewOutput.$emailUpdateTap).disposed(by: disposeBag)
//        }
//
//        do {
//            let tapGesture = UITapGestureRecognizer()
//            myOrdersView.addGestureRecognizer(tapGesture)
//            tapGesture.rx.event.mapAsVoid().bind(to: viewOutput.$myOrdersTap).disposed(by: disposeBag)
//        }
//    }
}

// MARK: - BindableView

extension ProfileEditViewController: BindableView {
    func bindWith(_ input: ProfilePresenterOutput) {
        
    }
    
    typealias Input = ProfilePresenterOutput
    
    typealias Output = ProfileViewOutput
    
    
    func getOutput() -> ProfileViewOutput {
        viewOutput
    }

//    func bindWith(_ input: ProfilePresenterOutput) {
//        bindViewModel(input.viewModel)
//
//        input.isContentViewVisible.drive(scrollView.rx.isVisible).disposed(by: disposeBag)
//
//        input.initialLoadingIndicatorVisible.drive(loadingIndicatorView.rx.isVisible).disposed(by: disposeBag)
//        input.initialLoadingIndicatorVisible.drive(loadingIndicatorView.indicatorView.rx.isAnimating).disposed(by: disposeBag)
//
//        input.showError.emit(onNext: { [unowned self] maybeViewModel in
//            self.errorMessageView.isVisible = (maybeViewModel != nil)
//
//            if let viewModel = maybeViewModel {
//                self.errorMessageView.resetToEmptyState()
//
//                self.errorMessageView.setTitle(viewModel.title, buttonTitle: viewModel.buttonTitle, action: {
//                    self.viewOutput.$retryButtonTap.accept(Void())
//                })
//            }
//        }).disposed(by: disposeBag)
//
//        input.hideRefreshControl.emit(to: refreshControl.rx.endRefreshing).disposed(by: disposeBag)
//
//        refreshControl.rx.controlEvent(.valueChanged).bind(to: viewOutput.$pullToRefresh).disposed(by: disposeBag)
//    }

//    private func bindViewModel(_ profileViewModel: Driver<ProfileViewModel>) {
//        profileViewModel.map { $0.firstName }.drive(onNext: { [unowned self] viewModel in
//            self.firstNameView.setTitle(viewModel.title, text: viewModel.text)
//        }).disposed(by: disposeBag)
//
//        profileViewModel.map { $0.lastName }.drive(onNext: { [unowned self] viewModel in
//            self.lastNameView.setTitle(viewModel.title, text: viewModel.text)
//        }).disposed(by: disposeBag)
//
//        profileViewModel.map { $0.middleName }.drive(onNext: { [unowned self] viewModel in
//            self.middleNameView.setTitle(viewModel.title, text: viewModel.maybeText)
//        }).disposed(by: disposeBag)
//
//        profileViewModel.map { $0.login }.drive(onNext: { [unowned self] viewModel in
//            self.loginView.setTitle(viewModel.title, text: viewModel.text)
//        }).disposed(by: disposeBag)
//
//        profileViewModel.map { $0.phone }.drive(onNext: { [unowned self] viewModel in
//            self.phoneView.setTitle(viewModel.title, text: viewModel.maybeText)
//        }).disposed(by: disposeBag)
//
//        profileViewModel.map { $0.email }.drive(onNext: { [unowned self] viewModel in
//            if let email = viewModel.maybeText {
//                self.emailView.setTitle(viewModel.title, text: email)
//                self.emailView.isVisible = true
//                self.addEmailView.isVisible = false
//            } else {
//                self.addEmailView.setText(viewModel.title)
//                self.addEmailView.isVisible = true
//                self.emailView.isVisible = false
//            }
//        }).disposed(by: disposeBag)
//
//        profileViewModel.map { $0.myOrders }.drive(onNext: { [unowned self] title in
//            self.myOrdersView.setText(title)
//        }).disposed(by: disposeBag)
//    }
}

// MARK: - RibStoryboardInstantiatable

//extension ProfileEditViewController: RibStoryboardInstantiatable {}

// MARK: - View Output

extension ProfileEditViewController {
    private struct ViewOutput: ProfileViewOutput {
        @PublishControlEvent var emailUpdateTap: ControlEvent<Void>

        @PublishControlEvent var myOrdersTap: ControlEvent<Void>

        @PublishControlEvent var retryButtonTap: ControlEvent<Void>

        @PublishControlEvent  var pullToRefresh: ControlEvent<Void>
    }
}

