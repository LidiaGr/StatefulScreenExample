//
//  EditProfileServiceImp.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import UIKit

struct NetworkError: LocalizedError {
    var errorDescription: String? { "Произошла сетевая ошибка" }
}

final class EditProfileServiceImp: EditProfileService {
    
    private var profileRequestsCount: Int = 0
    private var mockedProfile = EditProfile(firstName: "Иван", lastName: nil, email: nil, phone: "79991235467")
    
    func profile(_ completion: @escaping (Result<EditProfile, Error>) -> Void) {
        let result: Result<EditProfile, Error>
        if profileRequestsCount == 1 {
          // При втором запросе на загрузку профиля имитируем ошибку в целях демонстрации
          result = .failure(ApiError.badNetwork)
        } else {
          result = .success(mockedProfile)
        }
        
        profileRequestsCount += 1
        
        let delay = Double.random(in: 0.25...3)
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + delay) {
          completion(result)
        }
    }
    
    func updateProfile(_ profile: EditProfile, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .random(in: 0.5...2)) { [weak self] in
            let isSuccess = Bool.random()
            let result: Result<Void, Error>
            switch isSuccess {
            case false:
                result = .failure(NetworkError())
            case true:
                result = .success(Void())
                self?.mockedProfile = profile
            }
            
            completion(result)
        }
    }
}



