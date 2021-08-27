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

final class AuthorizationSecondViewController: UIViewController, AuthorizationSecondViewControllable {

//    weak var listener: AuthorizationSecondPresentableListener?
    
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var phoneNumberLabel: UILabel!
    @IBOutlet private weak var codeField: UITextField!
    
    // MARK: View Events
    
    private let viewOutput = ViewOutput()
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        initialSetup()
    }
}

extension AuthorizationSecondViewController {
    private func initialSetup() {
        codeField.tintColor = UIColor(hexString: "#34BC48")
        codeField.textAlignment = .center
    }
}

// MARK: - BindableView

extension AuthorizationSecondViewController: BindableView {
    func getOutput() -> AuthorizationSecondViewOutput { viewOutput }
    
    func bindWith(_ input: AuthorizationSecondPresenterOutput) {
    }
}

// MARK: - View Output

extension AuthorizationSecondViewController {
    private struct ViewOutput: AuthorizationSecondViewOutput {

    }
}

// MARK: - RibStoryboardInstantiatable

extension AuthorizationSecondViewController: RibStoryboardInstantiatable {}
