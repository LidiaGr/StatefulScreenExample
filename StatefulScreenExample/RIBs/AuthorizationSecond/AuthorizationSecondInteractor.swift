//
//  AuthorizationSecondInteractor.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 26.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa

final class AuthorizationSecondInteractor: PresentableInteractor<AuthorizationSecondPresentable>, AuthorizationSecondInteractable {
    
// MARK: - Dependencies
    
    weak var router: AuthorizationSecondRouting?
    private let authorizationService: AuthorizationService
    weak var listener: AuthorizationSecondListener?
    
// MARK: - Internals
    
    private let _state = BehaviorRelay<AuthorizationSecondInteractorState>(value: .userInput)
    
    private var _screenDataModel: BehaviorRelay<AuthorizationSecondScreenDataModel>
    
    init(presenter: AuthorizationSecondPresentable, phoneNumber: String, authorizationService: AuthorizationService) {
        self.authorizationService = authorizationService
        _screenDataModel = BehaviorRelay<AuthorizationSecondScreenDataModel>(value: AuthorizationSecondScreenDataModel(phone: phoneNumber, code: ""))
        super.init(presenter: presenter)
    }
    
    private let responses = Responses()
    
    private let disposeBag = DisposeBag()
    
    private func checkCode(code: String) {
        authorizationService.checkCode(code) { [weak self] result in
            switch result {
            case .success:
                self?.responses.$authorizedSuccessfully.accept(Void())
                self?.listener?.authorizationSuccess()
            case .failure(let error): self?.responses.$authorizingError.accept(error)
            }
        }
    }
}

// MARK: - IOTransformer

extension AuthorizationSecondInteractor: IOTransformer {
    
    func transform(input viewOutput:  AuthorizationSecondViewOutput) -> AuthorizationSecondInteractorOutput {
        
        let trait = StateTransformTrait(_state: _state, disposeBag: disposeBag)
        
        viewOutput.codeChange.asObservable()
            .map { code in String(code.removingCharacters(except: .arabicNumerals).prefix(5)) }
            .withLatestFrom(_screenDataModel, resultSelector: { ($0, $1) })
            .subscribe(onNext: { code, model in
                let newModel = model.copy(code: code)
                self._screenDataModel.accept(newModel)
            }).disposed(by: disposeBag)
        
        let requests = makeRequests()
        
        StateTransform.transform(trait: trait,
                                 viewOutput: viewOutput,
                                 screenDataModel: _screenDataModel.asObservable(),
                                 responses: responses,
                                 requests: requests)
        
        return AuthorizationSecondInteractorOutput(state: trait.readOnlyState,
                                                   screenDataModel: _screenDataModel.asObservable(),
                                                   inputStarted: viewOutput.codeChange.asObservable(),
                                                   requestSuccess: responses.$authorizedSuccessfully.asObservable(),
                                                   requestFailure: responses.$authorizingError.asObservable())
    }
}

extension AuthorizationSecondInteractor {
    private typealias State = AuthorizationSecondInteractorState
    
    private enum StateTransform: StateTransformer {
        /// case .userInput
        static let byUserInputState: (State) -> Bool = { state -> Bool in
            guard case .userInput = state else { return false }; return true
        }
        
        /// case .isCheckingForCode
        static let byIsCheckingCode: (State) -> String? = { state in
            guard case .isCheckingCode(let code) = state else { return nil }; return code
        }
        
        static func transform(trait: StateTransformTrait<State>,
                              viewOutput: AuthorizationSecondViewOutput,
                              screenDataModel: Observable<AuthorizationSecondScreenDataModel>,
                              responses: Responses,
                              requests: Requests) {
            
            StateTransform.transitions {
                
                /// userInput => isCheckingCode
                viewOutput.codeChange
                    .filteredByState(trait.readOnlyState, filter: byUserInputState)
                    .withLatestFrom(screenDataModel)
                    .filter{ model in model.codeIsValid}
                    .do(afterNext: { model in requests.authorizationRequest(model.code) })
                    .map{ model in State.isCheckingCode(code: model.code) }
                
                ///  isCheckingCode (error) => userInput
                responses.authorizingError
                    .filteredByState(trait.readOnlyState, filterMap: byIsCheckingCode)
                    .map { _ in State.userInput }
                
            }.bindToAndDisposedBy(trait: trait)
        }
    }
}

// MARK: - Help Methods

extension AuthorizationSecondInteractor {
    private func makeRequests() -> Requests {
        Requests(authorizationRequest: { [weak self] code in
                    self?.checkCode(code: code) })
    }
}


// MARK: - Nested Types

extension AuthorizationSecondInteractor {
    private struct Responses {
        @PublishObservable var authorizedSuccessfully: Observable<Void>
        @PublishObservable var authorizingError: Observable<Error>
    }
    
    private struct Requests {
        let authorizationRequest: (String) -> Void
    }
}
