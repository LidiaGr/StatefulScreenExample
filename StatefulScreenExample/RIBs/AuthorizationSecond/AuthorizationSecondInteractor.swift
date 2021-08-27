//
//  AuthorizationSecondInteractor.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 26.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift

final class AuthorizationSecondInteractor: PresentableInteractor<AuthorizationSecondPresentable>, AuthorizationSecondInteractable {

    weak var router: AuthorizationSecondRouting?
//    weak var listener: AuthorizationSecondListener?
    
    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: AuthorizationSecondPresentable, phoneNumber: String) {
        super.init(presenter: presenter)
//        presenter.listener = self
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

// MARK: - IOTransformer

extension AuthorizationSecondInteractor: IOTransformer {
    
    func transform(input viewOutput:  AuthorizationSecondViewOutput) -> AuthorizationSecondInteractorOutput {
        return AuthorizationSecondInteractorOutput()
    }
}
