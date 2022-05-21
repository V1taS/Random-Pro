//
//  NumberScreenModule.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol NumberScreenModuleOutput: AnyObject {
    
    /// Была нажата кнопка (настройки)
    func settingButtonAction()
}

protocol NumberScreenModuleInput: AnyObject {
    
    /// События которые отправляем из `текущего модуля` в  `другой модуль`
    var moduleOutput: NumberScreenModuleOutput? { get set }
}

typealias NumberScreenModule = UIViewController & NumberScreenModuleInput

final class NumberScreenViewController: NumberScreenModule {
    
    // MARK: - Internal property
    
    weak var moduleOutput: NumberScreenModuleOutput?
    
    // MARK: - Private property
    
    private let moduleView: UIView & NumberScreenViewInput
    private let interactor: NumberScreenInteractorInput
    private let factory: NumberScreenFactoryInput
    
    // MARK: - Initialization
    /// - Parameters:
    ///   - interactor: интерактор
    ///   - moduleView: вью
    ///   - factory: фабрика
    init(moduleView: UIView & NumberScreenViewInput,
         interactor: NumberScreenInteractorInput,
         factory: NumberScreenFactoryInput) {
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
        setupNavBar()
        interactor.getContent()
    }
    
    // MARK: - Private func
    
    private func setupNavBar() {
        let appearance = Appearance()
        
        navigationController?.navigationBar.prefersLargeTitles = false
        title = appearance.title
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(settingButtonAction))
    }
    
    @objc private func settingButtonAction() {
        moduleOutput?.settingButtonAction()
    }
}

// MARK: - NumberScreenViewOutput

extension NumberScreenViewController: NumberScreenViewOutput {
    func rangeStartDidChange(_ text: String?) {
        interactor.rangeStartDidChange(text)
    }
    
    func rangeEndDidChange(_ text: String?) {
        interactor.rangeEndDidChange(text)
    }
    
    func generateButtonAction(rangeStartValue: String?, rangeEndValue: String?) {
        interactor.generateContent(firstTextFieldValue: rangeStartValue,
                                   secondTextFieldValue: rangeEndValue)
    }
}

// MARK: - NumberScreenFactoryOutput

extension NumberScreenViewController: NumberScreenFactoryOutput {
    func didReverse(listResult: [String]) {
        moduleView.set(listResult: listResult)
    }
}

// MARK: - NumberScreenInteractorOutput

extension NumberScreenViewController: NumberScreenInteractorOutput {
    func didReciveRangeStart(text: String?) {
        moduleView.setRangeStart(text)
    }
    
    func didReciveRangeEnd(text: String?) {
        moduleView.setRangeEnd(text)
    }
    
    func didRecive(listResult: [String]) {
        factory.reverse(listResult: listResult)
    }
    
    func didRecive(result: String?) {
        moduleView.set(result: result)
    }
    
    func didRecive(rangeStartValue: String?, rangeEndValue: String?) {
        moduleView.set(rangeStartValue: rangeStartValue,
                       rangeEndValue: rangeEndValue)
    }
}

// MARK: - Appearance

private extension NumberScreenViewController {
    struct Appearance {
        let title = NSLocalizedString("Число", comment: "")
        let settingsButtonIcon = UIImage(systemName: "gear")
    }
}
