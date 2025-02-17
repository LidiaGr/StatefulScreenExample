//
//  AuthorizationPresenter.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

final class AuthorizationPresenter: AuthorizationPresentable { }

extension AuthorizationPresenter: IOTransformer {
    func transform(input: AuthorizationInteractorOutput) -> AuthorizationPresenterOutput {
        
        let phoneField = input.screenDataModel.map { model -> String in
            model.phone.formatPhoneNumber(with: "XXX XXX XX XX")
        }.asDriverIgnoringError()
        
        let isPhoneFieldEditing = input.screenDataModel.map { model -> Bool in
            switch model.isEditing {
            case true: return true
            case false: return false
            }
        }.asSignalIgnoringError()
        
        let isButtonActive = input.screenDataModel
            .map { model -> Bool in
                switch model.isPhoneValid {
                case true: return true
                case false: return false
                }
            }.asSignalIgnoringError()
        
        let showError = input.state.map { state -> ErrorMessageViewModel? in
            switch state {
            case .receivingCodeError(let error, _):
                return ErrorMessageViewModel(title: error.localizedDescription, buttonTitle: "Повторить")
            case .isWaitingForCode, .userInput:
                return nil
            }
        }.asSignalIgnoringError()
        
        let isContentVisible = input.state.map { state -> Bool in
            switch state {
            case .userInput, .isWaitingForCode: return true
            case .receivingCodeError: return false
            }
        }.asDriverIgnoringError()
        
        let loadngIndicator = input.state.map { state -> Bool in
            switch state {
            case .isWaitingForCode : return true
            case .userInput, .receivingCodeError : return false
            }
        }.asSignalIgnoringError()
        
        let buttonTapped = input.sendButtonTap
            .mapAsVoid()
            .asSignalIgnoringError()
        
        let success = input.requestSuccess
            .mapAsVoid()
            .asSignalIgnoringError()
        
        return AuthorizationPresenterOutput(phoneField: phoneField,
                                            isButtonActive: isButtonActive,
                                            isPhoneFieldEditing: isPhoneFieldEditing,
                                            loadingIndicator: loadngIndicator,
                                            isContentVisible: isContentVisible,
                                            successfulRequest: success,
                                            sendButtonTapped: buttonTapped,
                                            showError: showError)
    }
}
