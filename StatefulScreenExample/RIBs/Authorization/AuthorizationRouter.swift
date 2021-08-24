//
//  AuthorizationRouter.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs

protocol AuthorizationInteractable: Interactable {
    var router: AuthorizationRouting? { get set }
    var listener: AuthorizationListener? { get set }
}

protocol AuthorizationViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class AuthorizationRouter: ViewableRouter<AuthorizationInteractable, AuthorizationViewControllable>, AuthorizationRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: AuthorizationInteractable, viewController: AuthorizationViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
