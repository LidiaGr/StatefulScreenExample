//
//  MainScreenRouter.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 08.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RxSwift
import RxRelay
import RIBs

final class MainScreenRouter: ViewableRouter<MainScreenInteractable, MainScreenViewControllable>, MainScreenRouting {
    
    private let profileBuilder: ProfileBuildable
    private let editProfileBuilder: EditProfileBuildable
    private let authorizationBuilder: AuthorizationBuildable
    
    private let disposeBag = DisposeBag()
    
    init(interactor: MainScreenInteractable,
         viewController: MainScreenViewControllable,
         profileBuilder: ProfileBuildable,
         editProfileBuilder: EditProfileBuildable,
         authorizationBuilder: AuthorizationBuildable) {
        self.profileBuilder = profileBuilder
        self.editProfileBuilder = editProfileBuilder
        self.authorizationBuilder = authorizationBuilder
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToStackViewProfile(isUserAuthorized: Bool) {
        let router = profileBuilder.build(isUserAuthorized: isUserAuthorized)
        attachChild(router)
        viewController.uiviewController.navigationController?.pushViewController(router.viewControllable.uiviewController,
                                                                                 animated: true)
        detachWhenClosed(child: router, disposedBy: disposeBag)
    }
    
    func routeToTableViewProfile(isUserAuthorized: Bool) {
        let router = profileBuilder.buildScreenWithTableView(isUserAuthorized: isUserAuthorized)
        attachChild(router)
        viewController.uiviewController.navigationController?.pushViewController(router.viewControllable.uiviewController,
                                                                                 animated: true)
        detachWhenClosed(child: router, disposedBy: disposeBag)
    }
    
    func routeToEditProfile() {
        let router = editProfileBuilder.build()
        attachChild(router)
        viewController.uiviewController.navigationController?.pushViewController(router.viewControllable.uiviewController,
                                                                                 animated: true)
        detachWhenClosed(child: router, disposedBy: disposeBag)
    }
    
    func routeToAuthorization() {
        let router = authorizationBuilder.build(withListener: interactor)
        attachChild(router)
        
        viewController.uiviewController.present(router.viewControllable.uiviewController, animated: true, completion: nil)

        detachWhenClosed(child: router, disposedBy: disposeBag)
    }
}
