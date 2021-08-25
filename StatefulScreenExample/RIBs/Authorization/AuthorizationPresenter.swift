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
            var phone = model.phone
//            phone.insert(" ", at: phone.index(phone.startIndex, offsetBy: 3))
//            phone.insert(" ", at: phone.index(phone.startIndex, offsetBy: 6))
//            phone.insert(" ", at: phone.index(phone.startIndex, offsetBy: 8))
            return phone
        }.asDriverIgnoringError()
            
        
       let isButtonActive = input.screenDataModel
            .map { model -> Bool in
                switch model.isPhoneValid {
                case true: return true
                case false: return false
                }
            }.asSignalIgnoringError()
        
//        let phoneField = input.state
//            .withLatestFrom(input.screenDataModel, resultSelector: { ($0, $1) })
//            .map { state, model -> Bool in
//                switch state {
//                case .userInput:
//                    switch model.isPhoneValid {
//                    case true: print("phone is valid"); return true
//                    case false: return false
//                    }
//                case .isWaitingForCode, .receivingCodeError:
//                    return false
//                }
//            }.asSignalIgnoringError()
        
        let showError = input.state.map { state -> ErrorMessageViewModel? in
          switch state {
          case .receivingCodeError(let error, _):
            return ErrorMessageViewModel(title: error.localizedDescription, buttonTitle: "Повторить")
          case .isWaitingForCode, .userInput:
            return nil
          }
        }.asSignal(onErrorJustReturn: nil)
        
        let isPhoneFieldActive = input.phoneFieldTap
            .skip(1)
            .mapAsVoid()
            .asSignalIgnoringError()
        
//        let loadngIndicator = input.state.map { state -> Bool in
//            switch state {
//            case .isWaitingForCode : return true
//            case .userInput, .receivingCodeError : return false
//            }
//        }.asSignalIgnoringError()
        
        return AuthorizationPresenterOutput(phoneField: phoneField, isButtonActive: isButtonActive, isPhoneFieldActive: isPhoneFieldActive, showError: showError)
    }
}
