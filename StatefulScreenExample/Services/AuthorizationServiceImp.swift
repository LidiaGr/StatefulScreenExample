//
//  AuthorizationServiceImp.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import Foundation
import UserNotifications

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
    
    func sendNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Код авторизации"
        content.body = "12345"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "code", content: content, trigger: trigger)
        center.add(request) { error in
            if error != nil {
                print("Error: \(error?.localizedDescription ?? "local notification failed")")
            }
        }
    }
    
    func checkCode(_ code: String, completion: @escaping (Result<Void, Error>) -> Void){
        
    }
}

