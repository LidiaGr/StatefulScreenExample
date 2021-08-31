//
//  AuthorizationSecondRouter.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 26.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs

final class AuthorizationSecondRouter: ViewableRouter<AuthorizationSecondInteractable, AuthorizationSecondViewControllable>, AuthorizationSecondRouting {

    override init(interactor: AuthorizationSecondInteractable, viewController: AuthorizationSecondViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
