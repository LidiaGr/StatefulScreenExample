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
    private let editProfileService: EditProfileService
    
    // MARK: Internals
    
    private let _state = BehaviorRelay<EditProfileInteractorState>(value: .isEditing)
    
    private let responses = Responses()
    
    private let disposeBag = DisposeBag()
    
    
    init(presenter: EditProfilePresentable,
         editProfileService: EditProfileService) {
        self.editProfileService = editProfileService
        super.init(presenter: presenter)
        //        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.
        loadEditProfile()
    }
    
    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    private func loadEditProfile() {
        editProfileService.profile { [weak self] result in
            switch result {
            case .success(let profile): self?.responses.$didLoadProfile.accept(profile)
            case .failure(let error): self?.responses.$profileLoadingError.accept(error)
            }
        }
    }
}

// MARK: - IOTransformer

extension EditProfileInteractor: IOTransformer {
    
    private typealias State = EditProfileInteractorState
    
    func transform(input viewOutput: EditProfileViewOutput) -> Observable<EditProfileInteractorState> {
        let trait = StateTransformTrait(_state: _state, disposeBag: disposeBag)
        
        let requests = makeRequests()
        
        StateTransform.transform(trait: trait, viewOutput: viewOutput, responses: responses, requests: requests)
        return .never()
    }
    
}

extension EditProfileInteractor {
    /// StateTransform реализует переходы между всеми состояниями. Функции должны быть чистыми и детерминированными
    private enum StateTransform: StateTransformer {
        
        static func transform(trait: StateTransformTrait<State>,
                                      viewOutput: EditProfileViewOutput,
                                      responses: Responses,
                                      requests: Requests) {
        }
    }
}

// MARK: - Help Methods

extension EditProfileInteractor {
    private func makeRequests() -> Requests {
        Requests(loadProfile: { [weak self] in self?.loadEditProfile() })
    }
}

// MARK: - Nested Types

extension EditProfileInteractor {
    private struct Responses {
        @PublishObservable var didLoadProfile: Observable<ProfileData>
        @PublishObservable var profileLoadingError: Observable<Error>
    }
    
    private struct Requests {
        let loadProfile: VoidClosure
    }
}
