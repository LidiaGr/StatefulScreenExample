//
//  AuthorizationSecondViewController.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 26.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol AuthorizationSecondPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AuthorizationSecondViewController: UIViewController, AuthorizationSecondPresentable, AuthorizationSecondViewControllable {

    weak var listener: AuthorizationSecondPresentableListener?
}
