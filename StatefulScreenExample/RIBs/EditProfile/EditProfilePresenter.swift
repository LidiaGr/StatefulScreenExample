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
        
        let viewModel = input.screenDataModel.map { model -> EditProfileViewModel in
            return EditProfileViewModel(
                firstName: TitledOptionalText(title: "Имя", maybeText: model.firstName),
                lastName: TitledOptionalText(title: "Фамилия", maybeText: model.lastName),
                email: TitledOptionalText(title: "E-mail", maybeText: model.email),
                phone: TitledText(title: "Телефон", text: model.phone),
                isFirstNameValid: model.isFirstNameValid,
                isEmailValid: model.isEmailValid)
        }.asDriverIgnoringError()
        
        let isContentVisible = input.state.map { state -> Bool in
            switch state {
            case .isEditing, .isUpdatingProfile: return true
            case .updatingError: return false
            }
        }.asDriverIgnoringError()
        
        let loadngIndicator = input.state.map { state -> Bool in
            switch state {
            case .isUpdatingProfile : return true
            case .updatingError, .isEditing : return false
            }
        }.asSignalIgnoringError()
        
        let showError = input.state.map { state -> ErrorMessageViewModel? in
            switch state {
            case .updatingError(let error):
                return ErrorMessageViewModel(title: error.localizedDescription, buttonTitle: "Повторить")
            case .isEditing, .isUpdatingProfile:
                return nil
            }
        }.asSignalIgnoringError()
        
        let showAlert = input.updatedSuccessfully.asSignalIgnoringError()
        
        let showFirstNameError = input.saveButtonTap.withLatestFrom(input.screenDataModel)
            .filter{ !$0.isFirstNameValid }
            .mapAsVoid()
            .asSignalIgnoringError()
        
        let hideFirstNameError = input.firstNameUpdateTap
            .mapAsVoid()
            .asSignalIgnoringError()
        
        let showEmailError = input.saveButtonTap.withLatestFrom(input.screenDataModel)
            .filter{ !$0.isEmailValid }
            .mapAsVoid()
            .asSignalIgnoringError()
        
        let hideEmailError = input.emailUpdateTap
            .mapAsVoid()
            .asSignalIgnoringError()
        
        
        return EditProfilePresenterOutput(viewModel: viewModel,
                                          isContentVisible: isContentVisible,
                                          loadingIndicator: loadngIndicator,
                                          showError: showError,
                                          showAlert: showAlert,
                                          showFirstNameError: showFirstNameError,
                                          hideFirstNameError: hideFirstNameError,
                                          showEmailError: showEmailError,
                                          hideEmailError: hideEmailError)
    }
}
