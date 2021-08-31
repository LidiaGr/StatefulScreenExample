//
//  AuthorizationSecondBuilder.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 26.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs

final class AuthorizationSecondBuilder: Builder<RootDependency>, AuthorizationSecondBuildable {
    
    override init(dependency: RootDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: AuthorizationSecondListener, with phoneNumber: String) -> AuthorizationSecondRouting {
        
        let viewController = AuthorizationSecondViewController.instantiateFromStoryboard()
        
        let presenter = AuthorizationSecondPresenter()
        let interactor = AuthorizationSecondInteractor(presenter: presenter, phoneNumber: phoneNumber, authorizationService: dependency.authorizationService)
        interactor.listener = listener
        
        VIPBinder.bind(view: viewController, interactor: interactor, presenter: presenter)
        
        return AuthorizationSecondRouter(interactor: interactor, viewController: viewController)
    }
}
