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
        return AuthorizationSecondPresenterOutput()
    }
}
