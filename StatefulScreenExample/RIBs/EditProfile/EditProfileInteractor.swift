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
    
    // MARK: - Dependencies
    
    weak var router: EditProfileRouting?

    private let editProfileService: EditProfileService
    
    // MARK: - Internals
    
    private let _state = BehaviorRelay<EditProfileInteractorState>(value: .isEditing)
    
    private let _screenDataModel: BehaviorRelay<EditProfileScreenDataModel>
    
    private let responses = Responses()
    
    private let disposeBag = DisposeBag()
    
    init(presenter: EditProfilePresentable,
         editProfileService: EditProfileService) {
        self.editProfileService = editProfileService
        _screenDataModel = BehaviorRelay<EditProfileScreenDataModel>(value: EditProfileScreenDataModel(with: editProfileService.profile))
        super.init(presenter: presenter)
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
        
        removingInvalidSymbols(viewOutput: viewOutput)
        
        let requests = makeRequests()
        
        let output = StateTransform.transform(trait: trait, viewOutput: viewOutput, screenDataModel: _screenDataModel.asObservable(), responses: responses, requests: requests)
        
        return EditProfileInteractorOutput(state: trait.readOnlyState,
                                           screenDataModel: _screenDataModel.asObservable(),
                                           updatedSuccessfully: output.updatedSuccessfully,
                                           saveButtonTap: viewOutput.saveButtonTap.asObservable(),
                                           firstNameUpdateTap: viewOutput.firstNameChange.asObservable(),
                                           emailUpdateTap: viewOutput.emailChange.asObservable())
    }
    
    private func removingInvalidSymbols(viewOutput: EditProfileViewOutput) {
        
        viewOutput.firstNameChange.asObservable()
            .skip(1)
            .map { name in
                name?.removingCharacters(in: .whitespacesAndNewlines).removingCharacters(except: .letters)
            }
            .withLatestFrom(_screenDataModel, resultSelector: { ($0, $1) })
            .subscribe(onNext: { text, model in
                let newModel = model.copy(firstName: text)
                self._screenDataModel.accept(newModel)
            }).disposed(by: disposeBag)
        
        viewOutput.lastNameChange.asObservable()
            .skip(1)
            .map { name in
                name?.removingCharacters(in: .whitespacesAndNewlines).removingCharacters(except: .letters)
            }
            .withLatestFrom(_screenDataModel, resultSelector: { ($0, $1) })
            .subscribe(onNext: { text, model in
                let newModel = model.copy(lastName: text)
                self._screenDataModel.accept(newModel)
            }).disposed(by: disposeBag)
        
        viewOutput.emailChange.asObservable()
            .skip(1)
            .map { email in
                email?.removingCharacters(in: .whitespacesAndNewlines).removingCharacters(in: .russianLetters)
            }
            .withLatestFrom(_screenDataModel, resultSelector: { ($0, $1) })
            .subscribe(onNext: { text, model in
                let newModel = model.copy(email: text)
                self._screenDataModel.accept(newModel)
            }).disposed(by: disposeBag)
    }
}

extension EditProfileInteractor {
    
    private typealias State = EditProfileInteractorState
    
    private enum StateTransform: StateTransformer {
        /// case .isEditing
        static let byIsEditingState: (State) -> Bool = { state -> Bool in
            guard case .isEditing = state else { return false }; return true
        }
        
        /// case .isUpdatingProfile
        static let byIsUpdatingProfileState: (State) -> Bool = { state -> Bool in
            guard case .isUpdatingProfile = state else { return false }; return true
        }
        
        struct Output {
            let updatedSuccessfully: Observable<Void>
        }
        
        static func transform(trait: StateTransformTrait<State>,
                              viewOutput: EditProfileViewOutput,
                              screenDataModel: Observable<EditProfileScreenDataModel>,
                              responses: Responses,
                              requests: Requests) -> Output {
            
            let updatedSuccessfully = responses.updatingProfileSuccess.filteredByState(trait.readOnlyState, filter: byIsUpdatingProfileState)
            
            StateTransform.transitions {
                /// isEditing => isUpdatingProfile
                viewOutput.saveButtonTap
                    .filteredByState(trait.readOnlyState, filter: byIsEditingState)
                    .withLatestFrom(screenDataModel)
                    .filter { screenDataModel in screenDataModel.isModelValid}
                    .do(afterNext: { screenDataModel in
                        let profileData = ProfileData(firstName: screenDataModel.firstName , lastName: screenDataModel.lastName, email: screenDataModel.email, phone: screenDataModel.phone)
                        requests.updateProfile(profileData)
                    } )
                    .map { _ in State.isUpdatingProfile }
                
                /// isUpdatingProfile  => updatingError
                responses.updatingProfileError
                    .filteredByState(trait.readOnlyState, filter: byIsUpdatingProfileState)
                    .map { error in State.updatingError(error as! NetworkError) }
                
                /// updatingError => isUpdatingProfile
                viewOutput.retryButtonTap
                    .filteredByState(trait.readOnlyState, filter: { state -> Bool in
                                        guard case .updatingError = state else { return false }; return true })
                    .withLatestFrom(screenDataModel)
                    .do(afterNext: { screenDataModel in
                        let profileData = ProfileData(firstName: screenDataModel.firstName , lastName: screenDataModel.lastName, email: screenDataModel.email, phone: screenDataModel.phone)
                        
                        requests.updateProfile(profileData)
                    })
                    .map  { _ in State.isUpdatingProfile }
            }.bindToAndDisposedBy(trait: trait)
            return Output(updatedSuccessfully: updatedSuccessfully)
        }
    }
}

// MARK: - Help Methods

extension EditProfileInteractor {
    private func makeRequests() -> Requests {
        Requests(updateProfile: { [weak self] profile in
                    self?.updateProfile(profile: profile) })
    }
}

// MARK: - Nested Types

extension EditProfileInteractor {
    private struct Responses {
        @PublishObservable var updatingProfileSuccess: Observable<Void>
        @PublishObservable var updatingProfileError: Observable<Error>
    }
    
    private struct Requests {
        let updateProfile: (ProfileData) -> Void
    }
}

