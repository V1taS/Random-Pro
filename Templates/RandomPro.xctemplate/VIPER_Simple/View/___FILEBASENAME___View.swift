//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol ___FILEBASENAMEASIDENTIFIER___Output: AnyObject {}

/// События которые отправляем от Presenter ко View
protocol ___FILEBASENAMEASIDENTIFIER___Input {}

/// Псевдоним протокола UIView & ___FILEBASENAMEASIDENTIFIER___Input
typealias ___FILEBASENAMEASIDENTIFIER___Protocol = UIView & ___FILEBASENAMEASIDENTIFIER___Input

/// View для экрана
final class ___FILEBASENAMEASIDENTIFIER___: ___FILEBASENAMEASIDENTIFIER___Protocol {
  
  // MARK: - Internal properties
  
  weak var output: ___FILEBASENAMEASIDENTIFIER___Output?
  
  // MARK: - Private properties
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    configureLayout()
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Internal func
}

// MARK: - Private

private extension ___FILEBASENAMEASIDENTIFIER___ {
  func configureLayout() {}
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.darkAndLightTheme.primaryWhite
  }
}

// MARK: - Appearance

private extension ___FILEBASENAMEASIDENTIFIER___ {
  struct Appearance {}
}
