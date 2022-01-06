//
//  UIViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(
        with title: String,
        and message: String,
        style: UIAlertController.Style,
        completion: @escaping () -> Void = { }
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            completion()
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlert(
        with title: String,
        and message: String,
        titleOk: String,
        titleCancel: String,
        completionOk: @escaping () -> Void = {},
        completionCancel: @escaping () -> Void = {}
    ) {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: titleOk, style: .default) { (_) in
            completionOk()
        }
        let cancelAction = UIAlertAction(title: titleCancel, style: .cancel) { (_) in
            completionCancel()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
