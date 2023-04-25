//
//  ___FILENAME___
//  ___PROJECTNAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//

import UIKit

/// View для экрана
final class ___FILEBASENAMEASIDENTIFIER___: UIView {
  
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
    backgroundColor = .white
  }
}

// MARK: - Appearance

private extension ___FILEBASENAMEASIDENTIFIER___ {
  struct Appearance {}
}
