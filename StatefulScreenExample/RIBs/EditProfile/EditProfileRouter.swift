//
//  EditProfileRouter.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs

final class EditProfileRouter: ViewableRouter<EditProfileInteractable, EditProfileViewControllable>, EditProfileRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: EditProfileInteractable, viewController: EditProfileViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func routeToPrev() {
        print("routeToPrev")
        
//        showStubAlert(title: "Профиль успешно обновлён")
    }
    
    private func showStubAlert(title: String) {
      let message = "Вместо этого сообщения в боевом проекте производится роутинг на нужный экран"
      
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
      
      viewController.uiviewController.present(alert, animated: true, completion: nil)
    }
}
