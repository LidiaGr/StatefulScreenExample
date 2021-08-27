//
//  AuthorizationSecondPresenter.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 27.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

final class AuthorizationSecondPresenter: AuthorizationSecondPresentable { }

extension AuthorizationSecondPresenter: IOTransformer {
    func transform(input: AuthorizationSecondInteractorOutput) -> AuthorizationSecondPresenterOutput {
        
        let phoneLabel = input.screenDataModel.map { model -> String in
            var phone = model.phone
            phone.insert(contentsOf: "7", at: phone.startIndex)
            return phone.formatPhoneNumber(with: "+X XXX XXX XX XX")
        }.asDriverIgnoringError()
        
        let codeField = input.screenDataModel.map { model -> String in
            return model.code
        }.asDriverIgnoringError()
        
        let loadngIndicator = input.state.map { state -> Bool in
            switch state {
            case .isCheckingCode: return true
//            case .userInput, .receivingCodeError : return false
            case .userInput : return false
            }
        }.asSignalIgnoringError()
        
        let success = input.requestSuccess
            .mapAsVoid()
            .asSignalIgnoringError()
        
        let failure = input.requestFailure
            .mapAsVoid()
            .asSignalIgnoringError()
        
        return AuthorizationSecondPresenterOutput(phoneLabel: phoneLabel,
                                                  codeField: codeField,
                                                  loadingIndicator: loadngIndicator,
                                                  success: success,
                                                  failure: failure)
    }
}
