//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

import UIKit

/// События которые отправляем из Interactor в Presenter
protocol ___FILEBASENAMEASIDENTIFIER___Output: AnyObject {}

/// События которые отправляем от Presenter к Interactor
protocol ___FILEBASENAMEASIDENTIFIER___Input {}

/// Интерактор
final class ___FILEBASENAMEASIDENTIFIER___: ___FILEBASENAMEASIDENTIFIER___Input {
  
  // MARK: - Internal properties
  
  weak var output: ___FILEBASENAMEASIDENTIFIER___Output?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension ___FILEBASENAMEASIDENTIFIER___ {
  struct Appearance {}
}
