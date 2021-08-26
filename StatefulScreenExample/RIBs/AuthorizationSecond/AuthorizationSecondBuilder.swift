//
//  AuthorizationSecondBuilder.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 26.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs

protocol AuthorizationSecondDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class AuthorizationSecondComponent: Component<AuthorizationSecondDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol AuthorizationSecondBuildable: Buildable {
    func build(withListener listener: AuthorizationSecondListener) -> AuthorizationSecondRouting
}

final class AuthorizationSecondBuilder: Builder<AuthorizationSecondDependency>, AuthorizationSecondBuildable {

    override init(dependency: AuthorizationSecondDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: AuthorizationSecondListener) -> AuthorizationSecondRouting {
        let component = AuthorizationSecondComponent(dependency: dependency)
        let viewController = AuthorizationSecondViewController()
        let interactor = AuthorizationSecondInteractor(presenter: viewController)
        interactor.listener = listener
        return AuthorizationSecondRouter(interactor: interactor, viewController: viewController)
    }
}
