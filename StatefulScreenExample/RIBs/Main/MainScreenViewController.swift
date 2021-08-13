//
//  MainScreenViewController.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 08.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

final class MainScreenViewController: UIViewController, MainScreenViewControllable {
  @IBOutlet private weak var stackViewScreenButton: UIButton!
  @IBOutlet private weak var tableViewScreenButton: UIButton!
  @IBOutlet private weak var editProfileButton: UIButton!

  override func viewDidLoad() {
    super.viewDidLoad()
    initialSetup()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor(hexString: "#121214")
    }
}

extension MainScreenViewController {
  private func initialSetup() {}
}

// MARK: - BindableView

extension MainScreenViewController: BindableView {
  func getOutput() -> MainScreenViewOutput {
    return MainScreenViewOutput(stackViewButtonTap: stackViewScreenButton.rx.tap,
                                tableViewButtonTap: tableViewScreenButton.rx.tap,
                                editProfileButtonTap: editProfileButton.rx.tap)
  }

  func bindWith(_ input: Empty) {}
}

// MARK: - RibStoryboardInstantiatable

extension MainScreenViewController: RibStoryboardInstantiatable {}
