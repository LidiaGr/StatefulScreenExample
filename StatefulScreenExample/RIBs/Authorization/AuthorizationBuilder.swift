//
//  AuthorizationBuilder.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs

final class AuthorizationBuilder: Builder<RootDependency>, AuthorizationBuildable {


    func build() -> AuthorizationRouting {
//        let component = AuthorizationComponent(dependency: dependency)
        let viewController = AuthorizationViewController.instantiateFromStoryboard()
        
        let presenter = AuthorizationPresenter()
        let interactor = AuthorizationInteractor(presenter: presenter, authorizationService: dependency.authorizationService)
        
        VIPBinder.bind(view: viewController, interactor: interactor, presenter: presenter)
        
        return AuthorizationRouter(interactor: interactor,
                                   viewController: viewController,
                                   authorizationSecondBuilder: AuthorizationSecondBuilder(dependency: dependency))
    }
}
