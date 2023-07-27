//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

import UIKit

/// Презентер
final class ___FILEBASENAMEASIDENTIFIER___: ___VARIABLE_productName___Module {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: ___VARIABLE_productName___ModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: ___VARIABLE_productName___InteractorInput
  private let moduleView: ___VARIABLE_productName___ViewProtocol
  private let factory: ___VARIABLE_productName___FactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: ___VARIABLE_productName___ViewProtocol,
       interactor: ___VARIABLE_productName___InteractorInput,
       factory: ___VARIABLE_productName___FactoryInput) {
    self.moduleView = moduleView
    self.interactor = interactor
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycle
  
  override func loadView() {
    view = moduleView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
}

// MARK: - ___VARIABLE_productName___ViewOutput

extension ___FILEBASENAMEASIDENTIFIER___: ___VARIABLE_productName___ViewOutput {}

// MARK: - ___VARIABLE_productName___InteractorOutput

extension ___FILEBASENAMEASIDENTIFIER___: ___VARIABLE_productName___InteractorOutput {}

// MARK: - ___VARIABLE_productName___FactoryOutput

extension ___FILEBASENAMEASIDENTIFIER___: ___VARIABLE_productName___FactoryOutput {}

// MARK: - Private

private extension ___FILEBASENAMEASIDENTIFIER___ {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title
    let settingButton = UIBarButtonItem(image: appearance.settingsButtonIcon,
                                        style: .plain,
                                        target: self,
                                        action: #selector(settingButtonAction))
    navigationItem.rightBarButtonItems = [settingButton]
  }
  
  @objc
  func settingButtonAction() {
    // TODO: Добавить экшен
    impactFeedback.impactOccurred()
  }
}

// MARK: - Appearance

private extension ___FILEBASENAMEASIDENTIFIER___ {
  struct Appearance {
    let title = RandomStrings.Localizable.randomPro
    let settingsButtonIcon = UIImage(systemName: "gear")
  }
}
