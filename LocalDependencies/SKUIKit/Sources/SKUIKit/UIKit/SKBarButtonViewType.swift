//
//  SKBarButtonViewType.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 24.04.2024.
//

import UIKit

public enum SKBarButtonViewType {
  /// Виджет который поместим в центр навигейшен бара
  case widgetCryptoView(SKBarButtonView?)
  
  /// Любая вьюшка которую поместим в центр навигейшен бара
  case customView(view: UIView?)
}
