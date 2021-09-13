//
//  ErrorHandler.swift
//  Yumemi-ios-training
//
//  Created by 大塚 周 on 2021/09/12.
//

import UIKit

struct ErrorHandler {
    var handle: (_ viewController: WeatherViewController, _ error: WeatherAppError) -> Void
}

extension ErrorHandler {
    static let presentAlertViewController = Self(
        handle: { viewController, error in
            let message: String
            switch error {
            case .invalidParameterError:
                message = "不適切な値が設定されました"
            case .unknownError:
                message = "予期せぬエラーが発生しました"
            }
            let errorAlert = UIAlertController(title: "エラー", message: message, preferredStyle: .alert)
            let errorAction = UIAlertAction(title: "OK", style: .default)
            errorAlert.addAction(errorAction)
            viewController.present(errorAlert, animated: true, completion: nil)
        }
    )
}
