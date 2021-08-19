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
                phone: TitledText(title: "Телефон", text: model.phone))
        }.asDriverIgnoringError()
        
        return EditProfilePresenterOutput(viewModel: viewModel)
    }
}

