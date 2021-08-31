//
//  EditProfileRouter.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift

final class EditProfileRouter: ViewableRouter<EditProfileInteractable, EditProfileViewControllable>, EditProfileRouting {
    
    override init(interactor: EditProfileInteractable, viewController: EditProfileViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
