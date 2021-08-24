//
//  AuthorizationViewController.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift
import RxCocoa
import UIKit

final class AuthorizationViewController: UIViewController, AuthorizationViewControllable {
    
    @IBOutlet private weak var phoneNumberField: AuthorizationField!
    @IBOutlet private weak var sendCodeButton: UIButton!
    
    // MARK: View Events
    
    private let viewOutput = ViewOutput()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        initialSetup()
//        tapGesturesInitialSetup()
    }
}

extension AuthorizationViewController {
    private func initialSetup() {
        phoneNumberField.design()
    }
}

// MARK: - BindableView

extension AuthorizationViewController: BindableView {
    
    func getOutput() -> AuthorizationViewOutput { viewOutput }
    
    func bindWith(_ input: AuthorizationPresenterOutput) {
        
    }
}

// MARK: - View Output

extension AuthorizationViewController {
    private struct ViewOutput: AuthorizationViewOutput {
        
        @PublishControlEvent var phoneNumberUpdateTap: ControlEvent<String?>
        
        @PublishControlEvent var sendCodeButtonTap: ControlEvent<Void>
        
        @PublishControlEvent var retryButtonTap: ControlEvent<Void>
        
    }
}

// MARK: - RibStoryboardInstantiatable

extension AuthorizationViewController: RibStoryboardInstantiatable {}
