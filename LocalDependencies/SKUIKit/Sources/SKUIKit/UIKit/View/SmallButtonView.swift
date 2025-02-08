//
//  SmallButtonView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import UIKit
import SKStyle

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
    setTitleColor(SKStyleAsset.ghost.color, for: .normal)
    titleLabel?.font = .fancy.text.small
  }
}
