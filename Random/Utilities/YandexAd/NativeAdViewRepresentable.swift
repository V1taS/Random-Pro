//
//  NativeAdViewRepresentable.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 08.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI
import UIKit
import YandexMobileAds

final class NativeAdViewRepresentable: UIViewControllerRepresentable {
    
    var willDisappearAction: (() -> Void)?
    var closeButtonAction: (() -> Void)?
    
    init(willDisappearAction: (() -> Void)?, closeButtonAction: (() -> Void)?) {
        self.willDisappearAction = willDisappearAction
        self.closeButtonAction = closeButtonAction
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let interstitialVC = YandexADViewController()
        interstitialVC.willDisappearAction = willDisappearAction
        interstitialVC.closeButtonAction = closeButtonAction
        return interstitialVC
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

