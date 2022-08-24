//
//  ContactScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol ContactScreenInteractorOutput: AnyObject {}

protocol ContactScreenInteractorInput {}

final class ContactScreenInteractor: ContactScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: ContactScreenInteractorOutput?
}
