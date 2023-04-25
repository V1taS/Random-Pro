//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol ___FILEBASENAMEASIDENTIFIER___Output: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol ___FILEBASENAMEASIDENTIFIER___Input {}

/// Фабрика
final class ___FILEBASENAMEASIDENTIFIER___: ___FILEBASENAMEASIDENTIFIER___Input {
  
  // MARK: - Internal properties
  
  weak var output: ___FILEBASENAMEASIDENTIFIER___Output?
  
  // MARK: - Internal func
}

// MARK: - Appearance

private extension ___FILEBASENAMEASIDENTIFIER___ {
  struct Appearance {}
}
