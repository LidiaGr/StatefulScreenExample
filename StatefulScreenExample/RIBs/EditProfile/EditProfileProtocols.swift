//
//  EditProfileProtocols.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

// MARK: - Builder

protocol EditProfileDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
}

final class EditProfileComponent: Component<EditProfileDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

protocol EditProfileBuildable: Buildable {
//    func build(withListener listener: EditProfileListener) -> EditProfileRouting
    func build() -> EditProfileRouting
}

// MARK: - Router

protocol EditProfileInteractable: Interactable {
    var router: EditProfileRouting? { get set }
//    var listener: EditProfileListener? { get set }
}

protocol EditProfileViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

// MARK: - Interactor

protocol EditProfileRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol EditProfilePresentable: Presentable {
//    var listener: EditProfilePresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol EditProfileListener: AnyObject {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

// MARK: Outputs

typealias ProfileInteractorStates = interactorLoadingState<ProfileModel, Error>


