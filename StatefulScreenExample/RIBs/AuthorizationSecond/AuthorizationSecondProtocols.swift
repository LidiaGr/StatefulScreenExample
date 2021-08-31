//
//  AuthorizationSecondProtocols.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 27.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

protocol AuthorizationSecondDependency: Dependency {}

final class AuthorizationSecondComponent: Component<AuthorizationSecondDependency> {}

// MARK: - Builder

protocol AuthorizationSecondBuildable: Buildable {
    func build(withListener listener: AuthorizationSecondListener, with phoneNumber: String) -> AuthorizationSecondRouting
}

// MARK: - Router

protocol AuthorizationSecondInteractable: Interactable {
    var router: AuthorizationSecondRouting? { get set }
    var listener: AuthorizationSecondListener? { get set }
}

protocol AuthorizationSecondViewControllable: ViewControllable {}

// MARK: - Interactor

protocol AuthorizationSecondRouting: ViewableRouting {}

protocol AuthorizationSecondPresentable: Presentable {}

protocol AuthorizationSecondListener: AnyObject {
    func authorizationSuccess()
}

// MARK: - Outputs

struct AuthorizationSecondInteractorOutput {
    let state: Observable<AuthorizationSecondInteractorState>
    let screenDataModel: Observable<AuthorizationSecondScreenDataModel>
    let inputStarted: Observable<String>
    
    let requestSuccess: Observable<Void>
    let requestFailure: Observable<Error>
}

struct AuthorizationSecondPresenterOutput {
    let phoneLabel: Driver<String>
    let codeField: Driver<String>
    let loadingIndicator: Signal<Bool>
    let inputStarted: Signal<Void>
    
    let success: Signal<Void>
    let failure: Signal<Void>
}

protocol AuthorizationSecondViewOutput {
    var codeChange: ControlEvent<String> { get }
}

struct AuthorizationSecondScreenDataModel {
    let phone: String
    let code: String
    
    var codeIsValid: Bool {
        switch code.count {
        case 5: return true
        default: return false
        }
    }
    
    func copy(code: String) -> Self {
        let copy = AuthorizationSecondScreenDataModel(phone: phone, code: code)
        return copy
    }
}

// MARK: - AuthorizationSecondInteractorState

enum AuthorizationSecondInteractorState {
    case userInput
    case isCheckingCode(code: String?)
}
