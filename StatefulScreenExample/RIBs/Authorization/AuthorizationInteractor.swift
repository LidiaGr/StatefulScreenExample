//
//  AuthorizationInteractor.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa

final class AuthorizationInteractor: PresentableInteractor<AuthorizationPresentable>, AuthorizationInteractable {

    // MARK: Dependencies
    
    weak var router: AuthorizationRouting?
    private let authorizationService: AuthorizationService
    
    // MARK: Internals
    
    private let _state = BehaviorRelay<AuthorizationInteractorState>(value: .userInput)

    private var _screenDataModel: BehaviorRelay<AuthorizationScreenDataModel>
    
    private let responses = Responses()
    
    private let disposeBag = DisposeBag()
    
    
    init(presenter: AuthorizationPresentable, authorizationService: AuthorizationService) {
        self.authorizationService = authorizationService
        _screenDataModel = BehaviorRelay<AuthorizationScreenDataModel>(value: AuthorizationScreenDataModel(phone: ""))
        super.init(presenter: presenter)
    }

    private func sendSMSCode() {
        authorizationService.sendSMSCode() { [weak self] result in
            switch result {
            case .success: self?.responses.$codeReceivedSuccessfully.accept(Void())
            case .failure(let error): self?.responses.$codeReceivingError.accept(error)
            }
        }
    }
}

// MARK: - IOTransformer

extension AuthorizationInteractor: IOTransformer {
    func transform(input viewOutput: AuthorizationViewOutput) -> AuthorizationInteractorOutput {
        let trait = StateTransformTrait(_state: _state, disposeBag: disposeBag)
        
        viewOutput.phoneNumberUpdateTap.asObservable()
            .map { phoneNumber in phoneNumber.removingCharacters(except: .arabicNumerals) }
            .subscribe(onNext: { number in
                print(number)
                let newNumber = AuthorizationScreenDataModel(phone: number)
                self._screenDataModel.accept(newNumber)
            }).disposed(by: disposeBag)
        
        let requests = makeRequests()
        
        StateTransform.transform(trait: trait, viewOutput: viewOutput, screenDataModel: _screenDataModel.asObservable(), responses: responses, requests: requests)
        
        return AuthorizationInteractorOutput(state: trait.readOnlyState, screenDataModel: _screenDataModel.asObservable(), phoneFieldTap: viewOutput.phoneNumberUpdateTap.asObservable() )
    }
}

extension AuthorizationInteractor {
    
    private typealias State = AuthorizationInteractorState
    
    /// StateTransform реализует переходы между всеми состояниями. Функции должны быть чистыми и детерминированными
    
    private enum StateTransform: StateTransformer {
        /// case .userInput
        static let byUserInputState: (State) -> Bool = { state -> Bool in
            guard case .userInput = state else { return false }; return true
        }
        
        /// case .isWaitingForCode
        static let byIsWaitingForCode: (State) -> String? = { state in
            guard case .isWaitingForCode(let phoneNumber) = state else { return nil }; return phoneNumber
        }
        
        /// case .receivingCodeError
        static let byReceivingCodeError: (State) -> Bool = { state -> Bool in
            guard case .receivingCodeError = state else { return false }; return true
        }
        
        
        static func transform(trait: StateTransformTrait<State>,
                              viewOutput: AuthorizationViewOutput,
                              screenDataModel: Observable<AuthorizationScreenDataModel>,
                              responses: Responses,
                              requests: Requests) {
            
//            let codeReceivedSuccessfully = responses.codeReceivedSuccessfully.filteredByState(trait.readOnlyState, filter: byIsWaitingForCode)
//                .map { print("route to next screen") }
            
            let codeReceivedSuccessfully = responses.codeReceivedSuccessfully.filteredByState(trait.readOnlyState, filterMap: byIsWaitingForCode)
                .map { _ in print("route to next screen") }
            
            StateTransform.transitions {
                /// userInput => isWaitingForCode
                viewOutput.sendCodeButtonTap
                    .filteredByState(trait.readOnlyState, filter: byUserInputState)
                    .withLatestFrom(screenDataModel)
                    .filter { model in model.isPhoneValid}
                    .do(afterNext: { _ in requests.sendSMSCode() } )
                    .map { model in State.isWaitingForCode(phoneNumber: model.phone) }
                
                /// isWaitingForCode => receivingCodeError
                responses.codeReceivingError
                    .filteredByState(trait.readOnlyState, filterMap: byIsWaitingForCode)
                    .map { error, phoneNumber in State.receivingCodeError(error: error as! NetworkError, phoneNumber: phoneNumber) }
                
                /// receivingCodeError => isWaitingForCode
                viewOutput.retryButtonTap
                    .filteredByState(trait.readOnlyState) { state -> String? in
                        guard case let .receivingCodeError(_, phoneNumber) = state else { return nil }; return phoneNumber
                    }
                    .do(afterNext: { _ in requests.sendSMSCode() })
                    .map { phoneNumber in State.isWaitingForCode(phoneNumber: phoneNumber) }
            }.bindToAndDisposedBy(trait: trait)
        }
    }
}

// MARK: - Help Methods

extension AuthorizationInteractor {
    private func makeRequests() -> Requests {
        Requests(sendSMSCode: { [weak self] in self?.sendSMSCode() })
    }
}

// MARK: - Nested Types

extension AuthorizationInteractor {
    private struct Responses {
        @PublishObservable var codeReceivedSuccessfully: Observable<Void>
        @PublishObservable var codeReceivingError: Observable<Error>
    }
    
    private struct Requests {
        let sendSMSCode: () -> Void
    }
}
