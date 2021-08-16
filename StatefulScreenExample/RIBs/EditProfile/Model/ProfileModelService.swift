//
//  ProfileModel.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

protocol ProfileModelService: AnyObject {
    func profile(_ completion: @escaping (Result<ProfileModel, Error>) -> Void)
    func updateProfile(_ profile: ProfileModel, completion: @escaping (Result<Void, Error>) -> Void)
}

struct ProfileModel {
    var firstName: String?
    var lastName: String?
    var email: String?
    let phone: String
}

extension ProfileModel: Decodable {}
