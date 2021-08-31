//
//  EditProfileBuilder.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs

// MARK: - Builder

final class EditProfileBuilder: Builder<RootDependency>, EditProfileBuildable {
    
    func build() -> EditProfileRouting {
        let viewController = EditProfileViewController()
        
        let presenter = EditProfilePresenter()
        let interactor = EditProfileInteractor(presenter: presenter, editProfileService: dependency.editProfileService)
        
        VIPBinder.bind(view: viewController, interactor: interactor, presenter: presenter)
        
        return EditProfileRouter(interactor: interactor, viewController: viewController)
    }
}
