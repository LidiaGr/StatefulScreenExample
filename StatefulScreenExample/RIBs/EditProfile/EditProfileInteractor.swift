//
//  EditProfileInteractor.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift

final class EditProfileInteractor: PresentableInteractor<EditProfilePresentable>, EditProfileInteractable {

    weak var router: EditProfileRouting?
    weak var listener: EditProfileListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: EditProfilePresentable) {
        super.init(presenter: presenter)
//        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
}
