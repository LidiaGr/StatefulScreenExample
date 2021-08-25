//
//  AuthorizationServiceImp.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import UIKit

final class AuthorizationServiceImp: AuthorizationService {
//    private(set) var phone = ""
    
    func sendSMSCode(_ completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .random(in: 0.5...2)) {
            let isSuccess = Bool.random()
            let result: Result<Void, Error>
            switch isSuccess {
            case false:
                result = .failure(NetworkError())
            case true:
                result = .success(Void())
            }
            completion(result)
        }
    }
}
