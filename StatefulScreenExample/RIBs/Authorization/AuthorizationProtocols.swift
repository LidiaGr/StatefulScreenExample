//
//  AuthorizationProtocols.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

// MARK: - Builder

protocol AuthorizationDependency: Dependency {}

final class AuthorizationComponent: Component<AuthorizationDependency> {}

protocol AuthorizationBuildable: Buildable {
    func build(withListener listener: AuthorizationListener) -> AuthorizationRouting
}

// MARK: - Router

protocol AuthorizationInteractable: Interactable, AuthorizationSecondListener {
    var router: AuthorizationRouting? { get set }
    var listener: AuthorizationListener? { get set }
}

protocol AuthorizationViewControllable: ViewControllable {}

// MARK: - Interactor

protocol AuthorizationRouting: ViewableRouting {
    func routeToAuthorizationSecond(phoneNumber: String)
}

protocol AuthorizationPresentable: Presentable {}

protocol AuthorizationListener: AnyObject {
    func authorizationSuccessed()
}

// MARK: - Outputs

struct AuthorizationInteractorOutput {
    let state: Observable<AuthorizationInteractorState>
    let screenDataModel: Observable<AuthorizationScreenDataModel>
    let sendButtonTap: Observable<Void>
    let requestSuccess: Observable<Void>
}

struct AuthorizationPresenterOutput {
    let phoneField: Driver<String>
    
    let isButtonActive: Signal<Bool>
    
    let isPhoneFieldEditing: Signal<Bool>
    
    let loadingIndicator: Signal<Bool>
    
    let isContentVisible: Driver<Bool>
    
    let successfulRequest: Signal<Void>
    
    let sendButtonTapped: Signal<Void>
    
    /// nil означает что нужно спрятать сообщение об ошибке
    let showError: Signal<ErrorMessageViewModel?>
}

protocol AuthorizationViewOutput {
    var phoneNumberChange: ControlEvent<String> { get }
    
    var sendCodeButtonTap: ControlEvent<Void> { get }
    
    var retryAuthorizationButtonTap: ControlEvent<Void> { get }
}

struct AuthorizationScreenDataModel {
    let phone: String
    
    var isPhoneValid: Bool {
        switch phone.count {
        case 10: return true
        default: return false
        }
    }
    
    var isEditing: Bool {
        switch phone.count {
        case 0: return false
        default: return true
        }
    }
    
    func copy(phone: String) -> Self {
        let copy = AuthorizationScreenDataModel(phone: phone)
        return copy
    }
}

// MARK: - AuthorizationInteractorState

enum AuthorizationInteractorState {
    case userInput
    case isWaitingForCode(phoneNumber: String?)
    case receivingCodeError(error: NetworkError, phoneNumber: String)
}
