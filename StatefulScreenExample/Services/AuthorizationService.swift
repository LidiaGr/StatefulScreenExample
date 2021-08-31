//
//  AuthorizationService.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import Foundation

protocol AuthorizationService: AnyObject {
    
    func sendSMSCode(_ completion: @escaping (Result<Void, Error>) -> Void)
    func sendNotification()
    func checkCode(_ code: String, completion: @escaping (Result<Void, Error>) -> Void)
}
