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

protocol AuthorizationSecondDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AuthorizationSecondComponent: Component<AuthorizationSecondDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AuthorizationSecondBuildable: Buildable {
    func build(with phoneNumber: String) -> AuthorizationSecondRouting
}

// MARK: - Router

protocol AuthorizationSecondInteractable: Interactable {
    var router: AuthorizationSecondRouting? { get set }
//    var listener: AuthorizationSecondListener? { get set }
}

protocol AuthorizationSecondViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

// MARK: - Interactor

protocol AuthorizationSecondRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AuthorizationSecondPresentable: Presentable {
//    var listener: AuthorizationSecondPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AuthorizationSecondListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

// MARK: Outputs

struct AuthorizationSecondInteractorOutput {
    let state: Observable<AuthorizationSecondInteractorState>
    let screenDataModel: Observable<AuthorizationSecondScreenDataModel>
    
    let requestSuccess: Observable<Void>
    let requestFailure: Observable<Error>
}

struct AuthorizationSecondPresenterOutput {
    let phoneLabel: Driver<String>
    let codeField: Driver<String>
    let loadingIndicator: Signal<Bool>
    
    let success: Signal<Void>
    let failure: Signal<Void>
}

protocol AuthorizationSecondViewOutput {
    var codeUpdateTap: ControlEvent<String> { get }
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
}

// MARK: - AuthorizationSecondInteractorState

enum AuthorizationSecondInteractorState {
    case userInput
    case isCheckingCode(code: String?)
//    case receivingCodeError(error: NetworkError, code: String)
}
