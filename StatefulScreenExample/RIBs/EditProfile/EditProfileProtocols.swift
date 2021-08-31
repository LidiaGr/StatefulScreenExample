//
//  EditProfileProtocols.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

// MARK: - Builder

protocol EditProfileBuildable: Buildable {
    func build() -> EditProfileRouting
}

// MARK: - Router

protocol EditProfileInteractable: Interactable {
    var router: EditProfileRouting? { get set }
}

protocol EditProfileViewControllable: ViewControllable {}

// MARK: - Interactor

protocol EditProfileRouting: ViewableRouting {}

protocol EditProfilePresentable: Presentable {}

// MARK: - Outputs

struct EditProfileInteractorOutput {
    let state: Observable<EditProfileInteractorState>
    let screenDataModel: Observable<EditProfileScreenDataModel>
    let updatedSuccessfully: Observable<Void>
    var saveButtonTap: Observable<Void>
    var firstNameUpdateTap: Observable<String?>
    var emailUpdateTap: Observable<String?>
}

struct EditProfilePresenterOutput {
    let viewModel: Driver<EditProfileViewModel>
    
    let isContentVisible: Driver<Bool>
    
    let loadingIndicator: Signal<Bool>
    
    /// nil означает что нужно спрятать сообщение об ошибке
    let showError: Signal<ErrorMessageViewModel?>
    
    let showAlert: Signal<Void>
    
    let showFirstNameError: Signal<Void>
    
    let hideFirstNameError: Signal<Void>
    
    let showEmailError: Signal<Void>
    
    let hideEmailError: Signal<Void>
}

protocol EditProfileViewOutput {
    var firstNameChange: ControlEvent<String?> { get }
    
    var lastNameChange: ControlEvent<String?> { get }
    
    var emailChange: ControlEvent<String?> { get }
    
    var saveButtonTap: ControlEvent<Void> { get }
    
    var retryButtonTap: ControlEvent<Void> { get }
    
}

struct EditProfileViewModel: Equatable {
    let firstName: TitledOptionalText
    let lastName: TitledOptionalText
    
    let email: TitledOptionalText
    let phone: TitledText
    
    var isFirstNameValid: Bool
    var isEmailValid: Bool
}

struct EditProfileScreenDataModel {
    let firstName: String?
    let lastName: String?
    
    let email: String?
    let phone: String
    
    var isFirstNameValid: Bool {
        switch firstName {
        case "", nil: return false
        default: return true
        }
    }
    
    var isEmailValid: Bool {
        switch email {
        case "", nil: return true
        default: return email?.contains("@") == true
        }
    }
    
    var isModelValid: Bool {
        isFirstNameValid && isEmailValid
    }
    
    init(with profile: ProfileData) {
        firstName = profile.firstName
        lastName = profile.lastName
        email = profile.email
        phone = profile.phone
    }
}

extension EditProfileScreenDataModel {
    func copy(firstName: String?) -> Self {
        let copy = EditProfileScreenDataModel(with: ProfileData(firstName: firstName, lastName: lastName, email: email, phone: phone))
        return copy
    }
    
    func copy(lastName: String?) -> Self {
        let copy = EditProfileScreenDataModel(with: ProfileData(firstName: firstName, lastName: lastName, email: email, phone: phone))
        return copy
    }
    
    func copy(email: String?) -> Self {
        let copy = EditProfileScreenDataModel(with: ProfileData(firstName: firstName, lastName: lastName, email: email, phone: phone))
        return copy
    }
}

// MARK: - EditProfileInteractorState

enum EditProfileInteractorState {
    case isEditing
    case isUpdatingProfile
    case updatingError(NetworkError)
}

struct NetworkError: LocalizedError {
    var errorDescription: String? { "Произошла сетевая ошибка" }
}
