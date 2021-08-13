//
//  EditProfileBuilder.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs

// MARK: - Builder

final class EditProfileBuilder: Builder<EditProfileDependency>, EditProfileBuildable {

    override init(dependency: EditProfileDependency) {
        super.init(dependency: dependency)
    }

    func build() -> EditProfileRouting {
        let component = EditProfileComponent(dependency: dependency)
        let viewController = EditProfileViewController()
        let presenter = EditProfilePresenter()
        let interactor = EditProfileInteractor(presenter: presenter)
        return EditProfileRouter(interactor: interactor, viewController: viewController)
    }
}
