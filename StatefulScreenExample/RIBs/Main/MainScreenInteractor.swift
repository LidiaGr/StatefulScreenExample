//
//  MainScreenInteractor.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 08.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift
import RxRelay

final class MainScreenInteractor: Interactor, MainScreenInteractable {
  weak var router: MainScreenRouting?

  var isUserAuthorized = BehaviorRelay<Bool>(value: false)
    
  private let disposeBag = DisposeBag()
}

// MARK: - IOTransformer

extension MainScreenInteractor: IOTransformer {
  func transform(input viewOutput: MainScreenViewOutput) -> Empty {
    viewOutput.stackViewButtonTap
        .withLatestFrom(isUserAuthorized)
        .subscribe(onNext: { [weak self] isAuthorized in
            self?.router?.routeToStackViewProfile(isUserAuthorized: isAuthorized)
    }).disposed(by: disposeBag)

    viewOutput.tableViewButtonTap
        .withLatestFrom(isUserAuthorized)
        .subscribe(onNext: { [weak self] isAuthorized in
        self?.router?.routeToTableViewProfile(isUserAuthorized: isAuthorized)
    }).disposed(by: disposeBag)
    
    viewOutput.editProfileButtonTap.subscribe(onNext: { [weak self] in
      self?.router?.routeToEditProfile()
    }).disposed(by: disposeBag)
    
    viewOutput.authorizationButtonTap.subscribe(onNext: { [weak self] in
      self?.router?.routeToAuthorization()
    }).disposed(by: disposeBag)
    
    viewOutput.editProfileButtonTap.subscribe(onNext: { [weak self] in
      self?.router?.routeToEditProfile()
    }).disposed(by: disposeBag)
    
    viewOutput.authorizationButtonTap.subscribe(onNext: { [weak self] in
      self?.router?.routeToAuthorization()
    }).disposed(by: disposeBag)

    return Empty()
  }
}

// MARK: - AuthorizationListener

extension MainScreenInteractor {
    func authorizationSuccessed() {
        isUserAuthorized.accept(true)
    }
}
