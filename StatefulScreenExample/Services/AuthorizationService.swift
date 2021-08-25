//
//  AuthorizationService.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

protocol AuthorizationService: AnyObject {
//    var phone: String { get }
    func sendSMSCode(_ completion: @escaping (Result<Void, Error>) -> Void)
}

