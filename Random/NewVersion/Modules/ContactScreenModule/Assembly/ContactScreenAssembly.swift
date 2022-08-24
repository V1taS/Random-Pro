//
//  ContactScreenAssembly.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

final class ContactScreenAssembly {
  func createModule() -> ContactScreenModule {
    let view = ContactScreenView()
    let interactor = ContactScreenInteractor()
    let factory = ContactScreenFactory()
    let presenter = ContactScreenViewController(moduleView: view,
                                              interactor: interactor,
                                              factory: factory)
    view.output = presenter
    interactor.output = presenter
    factory.output = presenter
    return presenter
  }
}
