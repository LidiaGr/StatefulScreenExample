//
//  EditProfileInteractor.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa

final class EditProfileInteractor: PresentableInteractor<EditProfilePresentable>, EditProfileInteractable {

    // MARK: Dependencies
    
    weak var router: EditProfileRouting?
//    weak var listener: EditProfileListener?
    private let profileModelservice: ProfileModelService

    // MARK: Internals
   
    private let _state = BehaviorRelay<ProfileInteractorStates>(value: .isEditing)
    
//    private let responses = Responses()
    
    private let disposeBag = DisposeBag()
    
    
    init(presenter: EditProfilePresentable,
                  profileModelservice: ProfileModelService) {
        self.profileModelservice = profileModelservice
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
