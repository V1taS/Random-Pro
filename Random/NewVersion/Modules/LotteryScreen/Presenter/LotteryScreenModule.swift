//
//  LotteryScreenModule.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 18.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol LotteryScreenModuleOutput: AnyObject {
    
}

protocol LotteryScreenModuleInput: AnyObject {
    
    /// События которые отправляем из `текущего модуля` в  `другой модуль`
    var moduleOutput: LotteryScreenModuleOutput? { get set }
}

typealias LotteryScreenModule = UIViewController & LotteryScreenModuleInput

final class LotteryScreenViewController: LotteryScreenModule {
    
    // MARK: - Internal property
    
    weak var moduleOutput: LotteryScreenModuleOutput?
    
    // MARK: - Private property
    
    private let moduleView: LotteryScreenViewProtocol
    private let interactor: LotteryScreenInteractorInput
    private let factory: LotteryScreenFactoryInput
    
    // MARK: - Initialization
    /// - Parameters:
    ///   - interactor: интерактор
    ///   - moduleView: вью
    ///   - factory: фабрика
    init(moduleView: LotteryScreenViewProtocol, interactor: LotteryScreenInteractorInput,
         factory: LotteryScreenFactoryInput) {
        self.moduleView = moduleView
        self.interactor = interactor
        self.factory = factory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Internal func
    
    override func loadView() {
        super.loadView()
        view = moduleView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar()
        interactor.getContent()
    }
    
    // MARK: - Private func
    
    private func navigationBar() {
        let appearance = Appearance()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        title = appearance.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(settingButtonAction))
    }
    
    @objc private func settingButtonAction() {

    }
}

// MARK: - LotteryScreenViewOutput

extension LotteryScreenViewController: LotteryScreenViewOutput {
    func generateButtonAction(rangeStartValue: String?, rangeEndValue: String?, amountNumberValue: String?) {
        interactor.generateContent(rangeStartValue: rangeStartValue,
                                   rangeEndValue: rangeEndValue, amountNumberValue: amountNumberValue)
    }
}

// MARK: - LotteryScreenInteractorOutput

extension LotteryScreenViewController: LotteryScreenInteractorOutput {
    func didRecive(rangeStartValue: String?, rangeEndValue: String?, amountNumberValue: String?) {
        moduleView.set(rangeStartValue: rangeStartValue,
                       rangeEndValue: rangeEndValue, amountNumberValue: amountNumberValue)
    }
    
    func didRecive(result: String?) {
        moduleView.set(result: result)
    }
}

// MARK: - LotteryScreenFactoryOutput

extension LotteryScreenViewController: LotteryScreenFactoryOutput {
    
}

// MARK: - Appearance

private extension LotteryScreenViewController {
    struct Appearance {
        let settingsButtonIcon = UIImage(systemName: "gear")
        let title = NSLocalizedString("Лотерея", comment: "")
    }
}
