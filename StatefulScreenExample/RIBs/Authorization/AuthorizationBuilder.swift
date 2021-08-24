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
    func build(withListener listener: AuthorizationListener) -> AuthorizationRouting
}

final class AuthorizationBuilder: Builder<AuthorizationDependency>, AuthorizationBuildable {

    override init(dependency: AuthorizationDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AuthorizationListener) -> AuthorizationRouting {
        let component = AuthorizationComponent(dependency: dependency)
        let viewController = AuthorizationViewController()
        let interactor = AuthorizationInteractor(presenter: viewController)
        interactor.listener = listener
        return AuthorizationRouter(interactor: interactor, viewController: viewController)
    }
}
