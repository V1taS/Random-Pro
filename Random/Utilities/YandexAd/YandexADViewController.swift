//
//  InterstitialViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 08.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit
import YandexMobileAds

final class YandexADViewController: UIViewController {
    
    //MARK: - Public variable
    public var willDisappearAction: (() -> Void)?
    public var closeButtonAction: (() -> Void)?
    
    //MARK: - Private variable
    private var interstitialAd = YMAInterstitialAd(blockID: "R-M-1454493-1")
    
    private var closeButton: UIImageView = {
        let button = UIImageView(image: UIImage(named: "ic_close"))
        button.setImageColor(color: .black)
        return button
    }()
    
    private var textLabel: UILabel = {
        let text = UILabel()
        text.text = NSLocalizedString("Минуточка рекламы", comment: "")
        text.font = UIFont.robotoMedium20()
        text.textAlignment = .center
        return text
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLayout()
        configure()
    }
    
    //MARK: - Private func
    private func configureLayout() {
        [closeButton, textLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            closeButton.heightAnchor.constraint(equalToConstant: 32),
            closeButton.widthAnchor.constraint(equalToConstant: 32),
            
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    private func configure() {
        interstitialAd.delegate = self
        interstitialAd.load()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        closeButton.addGestureRecognizer(tapGesture)
        closeButton.isUserInteractionEnabled = true
        
        closeButton.isHidden = true
        textLabel.isHidden = false
    }
    
    @objc
    private func closeButtonTapped() {
        closeButtonAction?()
    }
    
    private func hiddeTextAndButton() {
        closeButton.isHidden = true
        textLabel.isHidden = true
    }
    
    private func showTextAndButton() {
        closeButton.isHidden = false
        textLabel.isHidden = false
    }
}

extension YandexADViewController: YMAInterstitialAdDelegate {
    func interstitialAdDidLoad(_ interstitialAd: YMAInterstitialAd) {
        self.interstitialAd.present(from: self)
        print("Ad loaded")
    }
    
    func interstitialAdDidFail(toLoad interstitialAd: YMAInterstitialAd, error: Error) {
        showTextAndButton()
        print("Loading failed. Error: \(error)")
    }
    
    func interstitialAdWillLeaveApplication(_ interstitialAd: YMAInterstitialAd) {
        showTextAndButton()
        print("Will leave application")
    }
    
    func interstitialAdDidFail(toPresent interstitialAd: YMAInterstitialAd, error: Error) {
        showTextAndButton()
        print("Failed to present interstitial. Error: \(error)")
    }
    
    func interstitialAdWillAppear(_ interstitialAd: YMAInterstitialAd) {
        hiddeTextAndButton()
        print("Interstitial ad will appear")
    }
    
    func interstitialAdDidAppear(_ interstitialAd: YMAInterstitialAd) {
        hiddeTextAndButton()
        print("Interstitial ad did appear")
    }
    
    func interstitialAdWillDisappear(_ interstitialAd: YMAInterstitialAd) {
        hiddeTextAndButton()
        willDisappearAction?()
        print("Interstitial ad will disappear")
    }
    
    func interstitialAdDidDisappear(_ interstitialAd: YMAInterstitialAd) {
        hiddeTextAndButton()
        print("Interstitial ad did disappear")
    }
    
    func interstitialAd(_ interstitialAd: YMAInterstitialAd, willPresentScreen webBrowser: UIViewController?) {
        hiddeTextAndButton()
        print("Interstitial ad will present screen")
    }
}
