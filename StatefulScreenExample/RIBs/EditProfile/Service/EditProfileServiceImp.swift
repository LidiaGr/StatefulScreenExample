//
//  EditProfileServiceImp.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import UIKit

final class EditProfileServiceImp: EditProfileService {
    
    private(set) var profile = ProfileData(firstName: "Иван", lastName: nil, email: nil, phone: "79991235467")
    
    func updateProfile(_ profile: ProfileData, completion: @escaping (Result<Void, Error>) -> Void) {
        DispatchQueue.global(qos: .default).asyncAfter(deadline: .now() + .random(in: 0.5...2)) { [weak self] in
            let isSuccess = Bool.random()
            let result: Result<Void, Error>
            switch isSuccess {
            case false:
                result = .failure(NetworkError())
            case true:
                result = .success(Void())
                self?.profile = profile
            }
            completion(result)
        }
    }
}
