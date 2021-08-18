//
//  EditProfilePresenter.swift
//  StatefulScreenExample
//
//  Created by L.Grigoreva on 13.08.2021.
//  Copyright © 2021 IgnatyevProd. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift

final class EditProfilePresenter: EditProfilePresentable {}

// MARK: - IOTransformer

//extension EditProfilePresenter: IOTransformer {
//    /// Метод отвечает за преобразование состояния во ViewModel'и и сигналы (команды)
//    func transform(input state: Observable<EditProfileInteractorState>) -> EditProfilePresenterOutput {
//        let viewModel = Helper.viewModel(state)
//    }
//    return EditProfilePresenterOutput(viewModel: viewModel,
//                                  isContentViewVisible: isContentViewVisible,
//                                  initialLoadingIndicatorVisible: initialLoadingIndicatorVisible,
//                                  hideRefreshControl: hideRefreshControl,
//                                  showError: showError)
//}
//
//extension EditProfilePresenter {
//    private enum Helper: Namespace {
//        static func viewModel(_ state: Observable<EditProfileInteractorState>) -> Driver<EditProfileViewModel> {
//            return state.compactMap { state -> EditProfileViewModel? in
//                switch state {
//                case .isEditing:
//                    return EditProfileViewModel(firstName: TitledText(title: "Имя", text: "Иван"),
//                     lastName: TitledText(title: "Фамилия", text: "Иванов"),
//                     email: TitledOptionalText(title: "E-mail", maybeText: nil),
//                     phone: TitledOptionalText(title: "Телефон", maybeText: "79377777777"))
//                case .isUpdatingProfile, .dataLoaded(_), .updatingError(_):
//                    return nil
//                }
//            }
//            .distinctUntilChanged()
//            .asDriverIgnoringError()
//        }
//    }
//}
