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
    
    private let _screenDataModel: BehaviorRelay<EditProfileScreenDataModel>
    
    private let responses = Responses()
    
    private let disposeBag = DisposeBag()
    
    
    init(presenter: EditProfilePresentable,
         editProfileService: EditProfileService) {
        self.editProfileService = editProfileService
        _screenDataModel = BehaviorRelay<EditProfileScreenDataModel>(value: EditProfileScreenDataModel(with: editProfileService.profile))
        super.init(presenter: presenter)
        //        presenter.listener = self
    }
    
    private func updateProfile(profile: ProfileData) {
        editProfileService.updateProfile(profile) { [weak self] result in
            switch result {
            case .success: self?.responses.$updatingProfileSuccess.accept(Void())
            case .failure(let error): self?.responses.$updatingProfileError.accept(error)
            }
        }
    }
}

// MARK: - IOTransformer

extension EditProfileInteractor: IOTransformer {
    
    func transform(input viewOutput: EditProfileViewOutput) -> EditProfileInteractorOutput {
        let trait = StateTransformTrait(_state: _state, disposeBag: disposeBag)
        
        let requests = makeRequests()
        
        StateTransform.transform(trait: trait, viewOutput: viewOutput, screenDataModel: _screenDataModel.asObservable(), responses: responses, requests: requests)
        
        bindStatefulRouting(responses, trait: trait)
        
        return EditProfileInteractorOutput(state: trait.readOnlyState, screenDataModel: _screenDataModel.asObservable())
    }
    
    private func bindStatefulRouting(_ responses: Responses, trait: StateTransformTrait<State>) {
        
        responses.updatingProfileSuccess.filteredByState(trait.readOnlyState, filter: StateTransform.byIsUpdatingProfileState)
            //do after next замыкание к закрытию экрана
            .subscribe(onNext: { [weak self] in
                self?.router?.routeToPrev()
            })
            .disposed(by: trait.disposeBag)
    }
}

extension EditProfileInteractor {
    
    private typealias State = EditProfileInteractorState
    
    /// StateTransform реализует переходы между всеми состояниями. Функции должны быть чистыми и детерминированными
    
    private enum StateTransform: StateTransformer {
        /// case .isEditing
        static let byIsEditingState: (State) -> Bool = { state -> Bool in
          guard case .isEditing = state else { return false }; return true
        }
        
        /// case .isUpdatingProfile
        static let byIsUpdatingProfileState: (State) -> Bool = { state -> Bool in
            guard case .isUpdatingProfile = state else { return false }; return true
        }
        
        static func transform(trait: StateTransformTrait<State>,
                                      viewOutput: EditProfileViewOutput,
                                      screenDataModel: Observable<EditProfileScreenDataModel>,
                                      responses: Responses,
                                      requests: Requests) {
            StateTransform.transitions {
                /// isEditing => isUpdatingProfile
                viewOutput.saveButtonTap
                    .filteredByState(trait.readOnlyState, filter: byIsEditingState)
                    .withLatestFrom(screenDataModel)
                    .do(afterNext: { screenDataModel in
                        let profileData = ProfileData(firstName: screenDataModel.firstName , lastName: screenDataModel.lastName, email: screenDataModel.email, phone: screenDataModel.phone)
                        
                            requests.loadProfile(profileData)
                    } )
                    .map { _ in State.isUpdatingProfile }
                
                /// isUpdatingProfile  => updatingError
                responses.updatingProfileError.filteredByState(trait.readOnlyState, filter: byIsUpdatingProfileState)
                    .map { error in State.updatingError(error as! NetworkError) }
                
                /// updatingError => isUpdatingProfile
                viewOutput.retryButtonTap
                    .filteredByState(trait.readOnlyState, filter: { state -> Bool in
                        guard case .updatingError = state else { return false }; return true })
                    .withLatestFrom(screenDataModel)
                    .do(afterNext: { screenDataModel in
                        let profileData = ProfileData(firstName: screenDataModel.firstName , lastName: screenDataModel.lastName, email: screenDataModel.email, phone: screenDataModel.phone)
                        
                            requests.loadProfile(profileData)
                    })
                    .map  { _ in State.isUpdatingProfile }
            }.bindToAndDisposedBy(trait: trait)
        }
    }
}

// MARK: - Help Methods

extension EditProfileInteractor {
    private func makeRequests() -> Requests {
        Requests(loadProfile: { [weak self] profile in
            self?.updateProfile(profile: profile)})
    }
}

// MARK: - Nested Types

extension EditProfileInteractor {
    private struct Responses {
        @PublishObservable var updatingProfileSuccess: Observable<Void>
        @PublishObservable var updatingProfileError: Observable<Error>
    }
    
    private struct Requests {
        let loadProfile: (ProfileData) -> Void
    }
}
