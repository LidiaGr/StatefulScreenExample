//
//  AuthorizationBuilder.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs

protocol AuthorizationDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AuthorizationComponent: Component<AuthorizationDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AuthorizationBuildable: Buildable {
    func build() -> AuthorizationRouting
}

final class AuthorizationBuilder: Builder<RootDependency>, AuthorizationBuildable {


    func build() -> AuthorizationRouting {
//        let component = AuthorizationComponent(dependency: dependency)
        let viewController = AuthorizationViewController.instantiateFromStoryboard()
        
        let presenter = AuthorizationPresenter()
        let interactor = AuthorizationInteractor(presenter: presenter)
        
        return AuthorizationRouter(interactor: interactor, viewController: viewController)
    }
}
