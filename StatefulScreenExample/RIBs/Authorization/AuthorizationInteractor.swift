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
    
//    private let _screenDataModel: BehaviorRelay<EditProfileScreenDataModel>
    
    private let responses = Responses()
    
    private let disposeBag = DisposeBag()
    
    init(presenter: AuthorizationPresentable, authorizationService: AuthorizationService) {
        self.authorizationService = authorizationService
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
        
        return AuthorizationInteractorOutput(state: trait.readOnlyState)
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
