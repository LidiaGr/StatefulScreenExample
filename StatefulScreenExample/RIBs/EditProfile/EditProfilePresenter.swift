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

extension EditProfilePresenter: IOTransformer {
    /// Метод отвечает за преобразование состояния во ViewModel'и и сигналы (команды)
    func transform(input: EditProfileInteractorOutput) -> EditProfilePresenterOutput {

//        let viewModel = Helper.viewModel(input)
        
        let viewModel = input.screenDataModel.map { model -> EditProfileViewModel in
            return EditProfileViewModel(
                firstName: TitledOptionalText(title: "Имя", maybeText: model.firstName),
                lastName: TitledOptionalText(title: "Фамилия", maybeText: model.lastName),
                email: TitledOptionalText(title: "E-mail", maybeText: model.email),
                phone: TitledText(title: "Телефон", text: model.phone),
                isFirstNameValid: model.isFirstNameValid,
                isEmailValid: model.isEmailValid)
        }.asDriverIgnoringError()
        
        let isContentViewVisible = input.state.compactMap { state -> Void? in
          // После загрузки 1-й порции данных контент всегда виден
          switch state {
          case .isEditing : return Void()
          case .isUpdatingProfile, .updatingError: return nil
          }
        }
        .map { true }
        .startWith(false)
        .asDriverIgnoringError()
        
        let isButtomActive = input.state.compactMap { state -> Bool? in
            switch state {
            case .isEditing: return true
            case .isUpdatingProfile, .updatingError: return nil
            }
        }.asDriverIgnoringError()
        
        let showError = input.state.map { state -> ErrorMessageViewModel? in
          switch state {
          case .updatingError(let error):
            return ErrorMessageViewModel(title: error.localizedDescription, buttonTitle: "Повторить")
          case .isEditing, .isUpdatingProfile:
            return nil
          }
        }.asSignal(onErrorJustReturn: nil)
        
        return EditProfilePresenterOutput(viewModel: viewModel,
                                          isContentViewVisible: isContentViewVisible,
                                          isButtonActive: isButtomActive,
                                          showError: showError)
    }
}

//extension EditProfilePresenter {
//    private enum Helper: Namespace {
//        static func viewModel(_ input: EditProfileInteractorOutput) -> Driver<EditProfileViewModel> {
//            return input.state.compactMap { state -> EditProfileViewModel? in
//                switch state {
//                case .isEditing:
//                    let viewModel = input.screenDataModel.map { model -> EditProfileViewModel in
//                        return EditProfileViewModel(
//                            firstName: TitledOptionalText(title: "Имя", maybeText: model.firstName),
//                            lastName: TitledOptionalText(title: "Фамилия", maybeText: model.lastName),
//                            email: TitledOptionalText(title: "E-mail", maybeText: model.email),
//                            phone: TitledText(title: "Телефон", text: model.phone),
//                            isFirstNameValid: model.isFirstNameValid,
//                            isEmailValid: model.isEmailValid)
//                    }
//                    return viewModel
//                case .isUpdatingProfile, .updatingError:
//                    return nil
//                }
//            }
//            .distinctUntilChanged()
//            .asDriverIgnoringError()
//        }
//    }
//}
