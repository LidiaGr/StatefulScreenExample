//
//  AuthorizationSecondInteractor.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 26.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift

protocol AuthorizationSecondRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AuthorizationSecondPresentable: Presentable {
    var listener: AuthorizationSecondPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol AuthorizationSecondListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class AuthorizationSecondInteractor: PresentableInteractor<AuthorizationSecondPresentable>, AuthorizationSecondInteractable, AuthorizationSecondPresentableListener {

    weak var router: AuthorizationSecondRouting?
    weak var listener: AuthorizationSecondListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: AuthorizationSecondPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
