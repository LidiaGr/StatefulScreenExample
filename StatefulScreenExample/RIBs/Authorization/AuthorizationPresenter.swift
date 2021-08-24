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
        return AuthorizationPresenterOutput()
    }
}
