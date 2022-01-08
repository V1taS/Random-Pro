//
//  ReviewTrackingManager.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 07.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport

final class ReviewTrackingManager {
    
    func requestIDFA() {
        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                    DispatchQueue.main.async {
                        switch status {
                        case .notDetermined, .restricted, .denied:
                            self.alertIDFA()
                        case .authorized: break
                        @unknown default: break
                        }
                    }
                })
            } else if ATTrackingManager.trackingAuthorizationStatus == .denied || ATTrackingManager.trackingAuthorizationStatus == .restricted {
                if !UserDefaults.standard.bool(forKey: "reviewTrackingManager") {
                    alertIDFA()
                    UserDefaults.standard.set(true, forKey: "reviewTrackingManager")
                }
            }
        }
    }
    
    private func gotoAppPrivacySettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
                  assertionFailure("Not able to open App privacy settings")
                  return
              }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func alertIDFA() {
        UIApplication.shared.windows.first?.rootViewController?
            .showAlert(
                with: NSLocalizedString("Можно использовать данные о вашей активности?", comment: ""),
                and: NSLocalizedString("Мы никому их не передадим. Просто не будем показывать рекламу установки Random Pro в других приложениях и на сайтах.", comment: ""),
                titleOk: NSLocalizedString("Включить отслеживание", comment: ""),
                titleCancel: NSLocalizedString("Отмена", comment: ""),
                completionOk: { [weak self] in
                    self?.gotoAppPrivacySettings()
                }
            )
    }
}
