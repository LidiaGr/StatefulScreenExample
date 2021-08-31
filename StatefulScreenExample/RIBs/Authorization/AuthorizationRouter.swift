//
//  AuthorizationRouter.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 24.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxSwift

final class AuthorizationRouter: ViewableRouter<AuthorizationInteractable, AuthorizationViewControllable>, AuthorizationRouting {
    
    private let authorizationSecondBuilder: AuthorizationSecondBuildable
    
    private let disposeBag = DisposeBag()
    
    init(interactor: AuthorizationInteractable,
         viewController: AuthorizationViewControllable,
         authorizationSecondBuilder: AuthorizationSecondBuildable) {
        self.authorizationSecondBuilder = authorizationSecondBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToAuthorizationSecond(phoneNumber: String) {
        let router = authorizationSecondBuilder.build(withListener: interactor, with: phoneNumber)
        attachChild(router)
        
        viewController.uiviewController.present(router.viewControllable.uiviewController,
                                                animated: true,
                                                completion: nil)
        
        detachWhenClosed(child: router, disposedBy: disposeBag)
    }
}
