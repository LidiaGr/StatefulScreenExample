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
//    func build(withListener listener: EditProfileListener) -> EditProfileRouting
    func build() -> EditProfileRouting
}

// MARK: - Router

protocol EditProfileInteractable: Interactable {
    var router: EditProfileRouting? { get set }
//    var listener: EditProfileListener? { get set }
}

protocol EditProfileViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

// MARK: - Interactor

protocol EditProfileRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
    func routeToPrev()
}

protocol EditProfilePresentable: Presentable {
//    var listener: EditProfilePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

// MARK: Outputs


struct EditProfileInteractorOutput {
    let state: Observable<EditProfileInteractorState>
    let screenDataModel: Observable<EditProfileScreenDataModel>
}

struct EditProfilePresenterOutput {
  let viewModel: Driver<EditProfileViewModel>
//  let isContentViewVisible: Driver<Bool>
//  
//  let initialLoadingIndicatorVisible: Driver<Bool>
//  let hideRefreshControl: Signal<Void>
//  
//  /// nil означает что нужно спрятать сообщение об ошибке
//  let showError: Signal<ErrorMessageViewModel?>
}

protocol EditProfileViewOutput {
  var firstNameUpdateTap: ControlEvent<String?> { get }
  
  var lastNameUpdateTap: ControlEvent<String?> { get }
    
  var emailUpdateTap: ControlEvent<String?> { get }
    
  var saveButtonTap: ControlEvent<Void> { get }
    
  var retryButtonTap: ControlEvent<Void> { get }
  
}

struct EditProfileViewModel: Equatable {
    let firstName: TitledOptionalText
    let lastName: TitledOptionalText
    
    let email: TitledOptionalText
    let phone: TitledText
}


//protocol FieldsValidation {
//    var isFirstNameValid: Bool { get set }
//    var isLastNameValid: Bool { get set }
//    var isEmailValid: Bool { get set }
//}

struct EditProfileScreenDataModel {
    var firstName: String?
    var lastName: String?
    
    var email: String?
    let phone: String
    
//    var isFirstNameValid: Bool
//    var isLastNameValid: Bool
//    var isEmailValid: Bool
    
    init(with profile: ProfileData) {
        firstName = profile.firstName
        lastName = profile.lastName
        email = profile.email
        phone = profile.phone
    }
    
//    init(flags isFirstNameValid: Bool, isLastNameValid: Bool, isEmailValid: Bool ) {
//        self.isFirstNameValid = isFirstNameValid
//        self.isLastNameValid = isLastNameValid
//        self.isEmailValid = isEmailValid
//    }
}

// MARK: - EditProfileInteractorState

/// L - Loading, D  - Data, E - Error
enum EditProfileInteractorState {
  case isEditing
  case isUpdatingProfile
  case updatingError(NetworkError)
  case terminating
}

struct NetworkError: LocalizedError {
    var errorDescription: String? { "Произошла сетевая ошибка" }
}
