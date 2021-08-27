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

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
        // Мб здесь как-то  можно сказать презентеру и вьюхе, что надо остановить лоудер?
    }
    
    private func sendSMSCode() {
        authorizationService.sendSMSCode() { [weak self] result in
            switch result {
            case .success:
                self?.authorizationService.sendNotification()
                self?.responses.$codeReceivedSuccessfully.accept(Void())
            case .failure(let error):
                self?.responses.$codeReceivingError.accept(error)
            }
        }
    }
}

// MARK: - IOTransformer

extension AuthorizationInteractor: IOTransformer {
    func transform(input viewOutput: AuthorizationViewOutput) -> AuthorizationInteractorOutput {
        let trait = StateTransformTrait(_state: _state, disposeBag: disposeBag)
        
        viewOutput.phoneNumberUpdateTap.asObservable()
            .map { phoneNumber in String(phoneNumber.removingCharacters(except: .arabicNumerals).prefix(10)) }
            .subscribe(onNext: { number in
                let newNumber = AuthorizationScreenDataModel(phone: number)
                self._screenDataModel.accept(newNumber)
            }).disposed(by: disposeBag)
        
        let requests = makeRequests()
        
        StateTransform.transform(trait: trait,
                                 viewOutput: viewOutput,
                                 screenDataModel: _screenDataModel.asObservable(),
                                 responses: responses,
                                 requests: requests)
        
        bindStatefulRouting(viewOutput, trait: trait)
        
        return AuthorizationInteractorOutput(state: trait.readOnlyState,
                                             screenDataModel: _screenDataModel.asObservable(),
                                             sendButtonTap: viewOutput.sendCodeButtonTap.asObservable(),
                                             requestSuccess: responses.$codeReceivedSuccessfully.asObservable())
    }
    
    private func bindStatefulRouting(_ viewoutput: AuthorizationViewOutput, trait: StateTransformTrait<State>) {
        responses.codeReceivedSuccessfully.observe(on: MainScheduler.instance)
            .filteredByState(trait.readOnlyState) { state -> String? in
                guard case let .isWaitingForCode(phoneNumber) = state else { return nil }; return phoneNumber
            }
            .subscribe(onNext: { [weak self] phone in
                self?.router?.routeToAuthorizationSecond(phoneNumber: phone)
            }).disposed(by: disposeBag)
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
            
            StateTransform.transitions {
                /// userInput => isWaitingForCode
                viewOutput.sendCodeButtonTap
                    .filteredByState(trait.readOnlyState, filter: byUserInputState)
                    .withLatestFrom(screenDataModel)
                    .filter { model in model.isPhoneValid }
                    .do(afterNext: { _ in requests.sendSMSCode() } )
                    .map { model in State.isWaitingForCode(phoneNumber: model.phone) }
                
                /// isWaitingForCode => receivingCodeError
                responses.codeReceivingError
                    .filteredByState(trait.readOnlyState, filterMap: byIsWaitingForCode)
                    .map { error, phoneNumber in State.receivingCodeError(error: error as! NetworkError, phoneNumber: phoneNumber) }
                
                /// receivingCodeError => isWaitingForCode
                viewOutput.retryAuthorizationButtonTap
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
