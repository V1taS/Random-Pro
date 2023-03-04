//
//  LetterScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 16.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

public final class LetterScreenAssembly {
  
  public init() {}
  
  /// Собирает модуль `LetterScreen`
  public func createModule(storageService: StorageServiceProtocol) -> LetterScreenModule {
    let view = LetterScreenView()
    let interactor = LetterScreenInteractor(storageService: storageService)
    let factory = LetterScreenFactory()
    let presenter = LetterScreenViewController(moduleView: view,
                                               interactor: interactor,
                                               factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
