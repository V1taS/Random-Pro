//
//  SmallButtonView.swift
//  
//
//  Created by Vitalii Sosin on 19.01.2023.
//

import UIKit
import FancyStyle

/// View для экрана
public final class SmallButtonView: UIButton {
  
  // MARK: - Public properties
  
  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    impactFeedback.impactOccurred()
    self.zoomInWithEasing()
  }
  
  // MARK: - Private properties
  
  private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    applyDefaultBehavior()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func applyDefaultBehavior() {
    setTitleColor(.fancy.darkAndLightTheme.primaryWhite, for: .normal)
    titleLabel?.font = fancyFont.primaryRegular18
  }
}
