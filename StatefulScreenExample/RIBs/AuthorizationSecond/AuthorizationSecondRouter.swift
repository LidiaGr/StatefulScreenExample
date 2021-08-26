//
//  AuthorizationSecondRouter.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 26.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs

protocol AuthorizationSecondInteractable: Interactable {
    var router: AuthorizationSecondRouting? { get set }
    var listener: AuthorizationSecondListener? { get set }
}

protocol AuthorizationSecondViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AuthorizationSecondRouter: ViewableRouter<AuthorizationSecondInteractable, AuthorizationSecondViewControllable>, AuthorizationSecondRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AuthorizationSecondInteractable, viewController: AuthorizationSecondViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
