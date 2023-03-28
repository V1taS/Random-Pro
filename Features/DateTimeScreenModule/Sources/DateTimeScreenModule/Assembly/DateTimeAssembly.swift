//
//  DateTimeAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 13.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

public final class DateTimeAssembly {
  
  public init() {}
  
  /// Собирает модуль `DateTimeScreen`
  public func createModule(storageService: DateTimeScreenStorageServiceProtocol) -> DateTimeModule {
    let view = DateTimeView()
    let interactor = DateTimeInteractor(storageService: storageService)
    let factory = DateTimeFactory()
    let presenter = DateTimeViewController(moduleView: view,
                                           interactor: interactor,
                                           factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
