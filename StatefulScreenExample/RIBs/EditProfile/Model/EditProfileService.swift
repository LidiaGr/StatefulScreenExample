//
//  ProfileModel.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

protocol EditProfileService: AnyObject {
    func profile(_ completion: @escaping (Result<ProfileData, Error>) -> Void)
    func updateProfile(_ profile: ProfileData, completion: @escaping (Result<Void, Error>) -> Void)
}

struct ProfileData {
    var firstName: String?
    var lastName: String?
    var email: String?
    let phone: String
}

extension ProfileData: Decodable {}
