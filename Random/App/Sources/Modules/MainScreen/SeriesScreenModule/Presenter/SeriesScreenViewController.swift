//
//  SeriesScreenViewController.swift
//  Random
//
//  Created by Artem Pavlov on 13.11.2023.
//

import UIKit
import FancyUIKit
import FancyStyle

/// Презентер
final class SeriesScreenViewController: SeriesScreenModule {
  
  // MARK: - Internal properties
  
  weak var moduleOutput: SeriesScreenModuleOutput?
  
  // MARK: - Private properties
  
  private let interactor: SeriesScreenInteractorInput
  private let moduleView: SeriesScreenViewProtocol
  private let factory: SeriesScreenFactoryInput
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - moduleView: вью
  ///   - interactor: интерактор
  ///   - factory: фабрика
  init(moduleView: SeriesScreenViewProtocol,
       interactor: SeriesScreenInteractorInput,
       factory: SeriesScreenFactoryInput) {
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

    interactor.loadSeries()
    setNavigationBar(isPlayTrailerEnabled: false)
  }
  
  override func finishFlow() {
    moduleOutput?.moduleClosed()
  }
}

// MARK: - SeriesScreenViewOutput

extension SeriesScreenViewController: SeriesScreenViewOutput {

  func generateSeriesAction() {
    interactor.generateSeries()
  }
}

// MARK: - SeriesScreenInteractorOutput

extension SeriesScreenViewController: SeriesScreenInteractorOutput {
  func startLoader() {
    moduleView.startLoader()
  }

  func didReceiveSeries(model: SeriesScreenModel) {
    moduleView.updateContentWith(model: model)

    if moduleView.getSeriesName() == nil {
      setNavigationBar(isPlayTrailerEnabled: false)
    } else {
      setNavigationBar(isPlayTrailerEnabled: true)
    }
  }

  func somethingWentWrong() {
    moduleOutput?.somethingWentWrong()
  }

  func stopLoader() {
    moduleView.stopLoader()
  }
}

// MARK: - SeriesScreenFactoryOutput

extension SeriesScreenViewController: SeriesScreenFactoryOutput {}

// MARK: - Private

private extension SeriesScreenViewController {
  func setNavigationBar(isPlayTrailerEnabled: Bool) {
    let appearance = Appearance()
    
    navigationItem.largeTitleDisplayMode = .never

    let playTrailerImageName = isPlayTrailerEnabled ? appearance.playTrailerImageEnabledName : appearance.playTrailerImageDisabledName

    let playTrailerButton = UIBarButtonItem.menuButton(self,
                                                       action: #selector(playTrailerAction),
                                                       imageName: playTrailerImageName,
                                                       size: CGSize(width: 33,
                                                                    height: 28))
    playTrailerButton.isEnabled = isPlayTrailerEnabled
    navigationItem.rightBarButtonItems = [playTrailerButton]
  }
  
  @objc
  func playTrailerAction() {
    guard let seriesName = moduleView.getSeriesName() else {
      moduleOutput?.somethingWentWrong()
      return
    }

    if interactor.isRuslocale() {
      let url = factory.createYandexLinkWith(text: seriesName)
      moduleOutput?.playTrailerActionWith(url: url)
    } else {
      guard let previewEngtUrl = moduleView.gerPreviewEngtUrl() else {
        moduleOutput?.somethingWentWrong()
        return
      }
      moduleOutput?.playTrailerActionWith(url: previewEngtUrl)
    }
    impactFeedback.impactOccurred()
  }
}

// MARK: - UIBarButtonItem

//в фмльмах такое же расширение, дублировать?
private extension UIBarButtonItem {
  static func menuButton(_ target: Any?,
                         action: Selector,
                         imageName: String,
                         size: CGSize) -> UIBarButtonItem {
    let button = UIButton(type: .system)
    button.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal), for: .normal)
    button.addTarget(target, action: action, for: .touchUpInside)

    let menuBarItem = UIBarButtonItem(customView: button)
    menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
    menuBarItem.customView?.heightAnchor.constraint(equalToConstant: size.height).isActive = true
    menuBarItem.customView?.widthAnchor.constraint(equalToConstant: size.width).isActive = true
    return menuBarItem
  }
}

// MARK: - Appearance

private extension SeriesScreenViewController {
  struct Appearance {
    let playTrailerImageEnabledName = RandomAsset.playTrailerEnabled.name
    let playTrailerImageDisabledName = RandomAsset.playTrailerDisabled.name
  }
}
