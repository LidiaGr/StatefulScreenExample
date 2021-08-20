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
    
    private func validateData() -> Bool {
        print("validatingData")
        
        var data = _screenDataModel.value
        
        let validateEmail: (String) -> Void = { email in
            switch email.contains("@") {
            case true: data.isEmailValid = true
            case false: data.isEmailValid = false
            }
        }
        
        switch data.firstName {
        case "", nil: data.isFirstNameValid = false
        default: data.isFirstNameValid = true
        }
        
        switch data.lastName {
//        case "": data.isLastNameValid = false
        default: data.isLastNameValid = true
        }
        
        switch data.email {
        case "", nil: data.isEmailValid = true
        default: validateEmail(data.email!)
        }
        
        switch data.isFirstNameValid && data.isLastNameValid && data.isEmailValid {
        case true: return true
        case false:
//            print("FirstName valid: \(data.isFirstNameValid)")
//            print("Email valid: \(data.isEmailValid)")
            print("InvalidData")
            _screenDataModel.accept(data)
            return false
        }
    }
}

// MARK: - IOTransformer

extension EditProfileInteractor: IOTransformer {
    
    func transform(input viewOutput: EditProfileViewOutput) -> EditProfileInteractorOutput {
        let trait = StateTransformTrait(_state: _state, disposeBag: disposeBag)
        
        removingInvalidSymbols(viewOutput: viewOutput)
        
        let requests = makeRequests()
//        let close : VoidClosure = { [weak self] in
//            self?.router?.routeToPrev()
//        }
        
        StateTransform.transform(trait: trait, viewOutput: viewOutput, screenDataModel: _screenDataModel.asObservable(), responses: responses, requests: requests, validation: validateData)
        
        bindStatefulRouting(responses, trait: trait)
        
        return EditProfileInteractorOutput(state: trait.readOnlyState, screenDataModel: _screenDataModel.asObservable())
    }
    
    private func removingInvalidSymbols(viewOutput: EditProfileViewOutput) {
        viewOutput.firstNameUpdateTap.asObservable()
            .skip(1)
            .map { name in
                name?.removingCharacters(in: .whitespacesAndNewlines).removingCharacters(except: .letters)
            }
//            .distinctUntilChanged()
            .subscribe(onNext: { text in
                let profileData = ProfileData(firstName: text, lastName: self._screenDataModel.value.lastName, email: self._screenDataModel.value.email, phone: self._screenDataModel.value.phone)
                let newModel = EditProfileScreenDataModel(with: profileData)
                self._screenDataModel.accept(newModel)
//                print(text)
            }).disposed(by: disposeBag)
        
        viewOutput.lastNameUpdateTap.asObservable()
            .skip(1)
            .map { name in
                name?.removingCharacters(in: .whitespacesAndNewlines).removingCharacters(except: .letters)
            }
//            .distinctUntilChanged()
            .subscribe(onNext: { text in
                let profileData = ProfileData(firstName: self._screenDataModel.value.firstName, lastName: text, email: self._screenDataModel.value.email, phone: self._screenDataModel.value.phone)
                let newModel = EditProfileScreenDataModel(with: profileData)
                self._screenDataModel.accept(newModel)
//                print(text)
            }).disposed(by: disposeBag)
        
        viewOutput.emailUpdateTap.asObservable()
            .skip(1)
            .map { email in
                email?.removingCharacters(in: .whitespacesAndNewlines).removingCharacters(in: .russianLetters)
            }
//            .distinctUntilChanged()
            .subscribe(onNext: { text in
                let profileData = ProfileData(firstName: self._screenDataModel.value.firstName, lastName: self._screenDataModel.value.lastName, email: text, phone: self._screenDataModel.value.phone)
                let newModel = EditProfileScreenDataModel(with: profileData)
                self._screenDataModel.accept(newModel)
            }).disposed(by: disposeBag)
    }
    
    private func bindStatefulRouting(_ responses: Responses, trait: StateTransformTrait<State>) {

        //do after next замыкание к закрытию экрана
        responses.updatingProfileSuccess.filteredByState(trait.readOnlyState, filter: StateTransform.byIsUpdatingProfileState)
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
                                      requests: Requests,
                                      validation: @escaping () -> Bool) {
                                      //close: @escaping VoidClosure) {
            StateTransform.transitions {
                /// isEditing => isUpdatingProfile
                viewOutput.saveButtonTap
                    .filteredByState(trait.readOnlyState, filter: byIsEditingState)
                    .withLatestFrom(screenDataModel)
                    .filter { _ in validation() }
                    .do(afterNext: { screenDataModel in
                        let profileData = ProfileData(firstName: screenDataModel.firstName , lastName: screenDataModel.lastName, email: screenDataModel.email, phone: screenDataModel.phone)
                            print("SaveButtonTapped")
                            requests.updateProfile(profileData)
                    } )
                    .map { _ in State.isUpdatingProfile }
                
                /// isUpdatingProfile  => terminate
//                responses.updatingProfileSuccess.filteredByState(trait.readOnlyState, filter: byIsUpdatingProfileState)
//                    .do (afterNext: { _ in
//                        print("close")
//                        close()
//                    })
//                    .map { _ in State.terminating }
                
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
                        
                            requests.updateProfile(profileData)
                    })
                    .map  { _ in State.isUpdatingProfile }
            }.bindToAndDisposedBy(trait: trait)
        }
    }
}

// MARK: - Help Methods

extension EditProfileInteractor {
    private func makeRequests() -> Requests {
        Requests(updateProfile: { [weak self] profile in self?.updateProfile(profile: profile) })
                // closeEditProfile: { [weak self] in self?.router?.routeToPrev() })
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
//        let closeEditProfile: VoidClosure
    }
}

