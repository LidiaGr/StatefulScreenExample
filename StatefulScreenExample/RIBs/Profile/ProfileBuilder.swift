//
//  ProfileBuilder.swift
//  StatefulScreenExample
//
//  Created by Dmitriy Ignatyev on 07.12.2019.
//  Copyright © 2019 IgnatyevProd. All rights reserved.
//

import RIBs

final class ProfileBuilder: Builder<RootDependency>, ProfileBuildable {
    
    func build(isUserAuthorized: Bool) -> ProfileRouting {
    let viewController = ProfileStackViewController.instantiateFromStoryboard()

    return buildWith(viewController: viewController, isUserAuthorized: isUserAuthorized)
  }
  
  func buildScreenWithTableView(isUserAuthorized: Bool) -> ProfileRouting {
    let viewController = ProfileTableViewController.instantiateFromStoryboard()
    
    return buildWith(viewController: viewController, isUserAuthorized: isUserAuthorized)
  }
  
    private func buildWith<V: UIViewController>(viewController: V, isUserAuthorized: Bool) -> ProfileRouting
    where V: ProfileViewControllable & BindableView, V.Input == ProfilePresenterOutput, V.Output == ProfileViewOutput {
    
      let presenter = ProfilePresenter()
      let interactor = ProfileInteractor(presenter: presenter, profileService: dependency.profileService, isUserAuthorized: isUserAuthorized)
      
      VIPBinder.bind(view: viewController, interactor: interactor, presenter: presenter)
      
      return ProfileRouter(interactor: interactor, viewController: viewController)
  }
}
