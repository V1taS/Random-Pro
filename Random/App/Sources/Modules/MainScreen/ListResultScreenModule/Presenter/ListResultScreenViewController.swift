//
//  ListResultScreenViewController.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.06.2022.
//

import UIKit
import FancyUIKit
import FancyStyle

/// События которые отправляем из `текущего модуля` в `другой модуль`
protocol ListResultScreenModuleOutput: AnyObject {
  
  /// Результат скопирован
  ///  - Parameter text: Результат генерации
  func resultCopied(text: String)
  
  /// Кнопка поделиться была нажата
  ///  - Parameter imageData: Изображение контента
  func shareButtonAction(imageData: Data?)
  
  /// Модуль был закрыт
  func moduleClosed()
}

/// События которые отправляем из `другого модуля` в `текущий модуль`
protocol ListResultScreenModuleInput {
  
  /// Установить список результатов
  ///  - Parameter list: Список результатов
  func setContentsFrom(list: [String])
  
  /// События которые отправляем из `текущего модуля` в `другой модуль`
  var moduleOutput: ListResultScreenModuleOutput? { get set }
}

/// Готовый модуль `ListResultScreenModule`
typealias ListResultScreenModule = ViewController & ListResultScreenModuleInput

/// Презентер
final class ListResultScreenViewController: ListResultScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: ListResultScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: ListResultScreenInteractorInput
  private let moduleView: ListResultScreenViewProtocol
  private let factory: ListResultScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  private var listCache: [String] = []
  private lazy var shareButton = UIBarButtonItem(image: Appearance().shareButtonIcon,
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(shareButtonAction))
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(interactor: ListResultScreenInteractorInput,
       moduleView: ListResultScreenViewProtocol,
       factory: ListResultScreenFactoryInput) {
    self.interactor = interactor
    self.moduleView = moduleView
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
    
    setNavigationBar()
    shareButton.isEnabled = !listCache.isEmpty

    Metrics.shared.track(event: .listResultScreenOpen)
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
    Metrics.shared.track(event: .listResultScreenClose)
  }
  
  // MARK: - Internal func
  
  func setContentsFrom(list: [String]) {
    listCache = list
    moduleView.updateContentWith(list: list)
    shareButton.isEnabled = !listCache.isEmpty
  }
}

// MARK: - ListResultScreenViewOutput

extension ListResultScreenViewController: ListResultScreenViewOutput {
  func resultCopied(text: String) {
    moduleOutput?.resultCopied(text: text)
    Metrics.shared.track(event: .listResultScreenResultCopied)
  }
}

// MARK: - ListResultScreenInteractorOutput

extension ListResultScreenViewController: ListResultScreenInteractorOutput {}

// MARK: - ListResultScreenFactoryOutput

extension ListResultScreenViewController: ListResultScreenFactoryOutput {}

// MARK: - Private

private extension ListResultScreenViewController {
  func setNavigationBar() {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never
    title = appearance.title

    navigationItem.rightBarButtonItem = shareButton
  }
  
  @objc
  func shareButtonAction() {
    moduleView.returnCurrentContentImage { [weak self] dataImage in
      self?.moduleOutput?.shareButtonAction(imageData: dataImage)
      self?.impactFeedback.impactOccurred()
      Metrics.shared.track(event: .listResultScreenButtonShareImage)
    }
  }
}

// MARK: - Appearance

private extension ListResultScreenViewController {
  struct Appearance {
    let title = RandomStrings.Localizable.listOfResults
    let shareButtonIcon = UIImage(systemName: "square.and.arrow.up")
  }
}
