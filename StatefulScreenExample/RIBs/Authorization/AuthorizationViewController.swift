//
//  AuthorizationViewController.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol AuthorizationPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
}

final class AuthorizationViewController: UIViewController, AuthorizationViewControllable {

    weak var listener: AuthorizationPresentableListener?
    
    @IBOutlet private weak var phoneNumberField: AuthorizationField!
    @IBOutlet private weak var sendCodeButton: UIButton!
    
    override func viewDidLoad() {
      super.viewDidLoad()
      initialSetup()
    }
}

extension AuthorizationViewController {
    private func initialSetup() {
        phoneNumberField.design()
    }
}

// MARK: - RibStoryboardInstantiatable

extension AuthorizationViewController: RibStoryboardInstantiatable {}
