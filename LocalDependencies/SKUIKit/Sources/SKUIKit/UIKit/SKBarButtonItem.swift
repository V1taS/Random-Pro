//
//  SKBarButtonItem.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 18.04.2024.
//

import UIKit
import SKStyle

final public class SKBarButtonItem: UIBarButtonItem {
  
  // MARK: - Private properties
  
  private var barButtonAction: (() -> Void)?
  private var buttonItem: ((SKBarButtonItem?) -> Void)?
  private let impactFeedback = UIImpactFeedbackGenerator(style: .soft)
  
  // MARK: - Init
  
  public init(_ buttonType: SKBarButtonItem.ButtonType,
              isEnabled: Bool = true) {
    super.init()
    self.image = buttonType.image
    self.style = .plain
    setTitleTextAttributes([.font: UIFont.fancy.text.regularMedium], for: .normal)
    self.title = buttonType.title
    self.target = self
    self.action = #selector(barButtonSelector)
    self.barButtonAction = buttonType.action
    self.buttonItem = buttonType.buttonItem
    self.tintColor = buttonType.tintColor
    self.isEnabled = isEnabled
    buttonItem?(self)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private

private extension SKBarButtonItem {
  @objc private func barButtonSelector() {
    barButtonAction?()
    impactFeedback.impactOccurred()
  }
}

// MARK: - ButtonType

extension SKBarButtonItem {
  public enum ButtonType {
    var tintColor: UIColor {
      switch self {
      case .edit:
        return SKStyleAsset.constantAzure.color
      case .close:
        return SKStyleAsset.constantAzure.color
      case .done:
        return SKStyleAsset.constantAzure.color
      case .refresh:
        return SKStyleAsset.constantAzure.color
      case .share:
        return SKStyleAsset.constantAzure.color
      case .delete:
        return SKStyleAsset.constantAzure.color
      case .write:
        return SKStyleAsset.constantAzure.color
      case .add:
        return SKStyleAsset.constantAzure.color
      case .lock:
        return SKStyleAsset.constantAzure.color
      case .text:
        return SKStyleAsset.constantAzure.color
      case .settings:
        return SKStyleAsset.constantAzure.color
      }
    }
    
    var buttonItem: ((SKBarButtonItem?) -> Void)? {
      switch self {
      case let .edit(_, button):
        return button
      case let .close(_, button):
        return button
      case let .done(_, button):
        return button
      case let .refresh(_, button):
        return button
      case let .share(_, button):
        return button
      case let .delete(_, button):
        return button
      case let .write(_, button):
        return button
      case let .add(_, button):
        return button
      case let .lock(_, button):
        return button
      case let .text(_, _, button):
        return button
      case let .settings(_, button):
        return button
      }
    }
    
    var action: (() -> Void)? {
      switch self {
      case let .edit(action, _):
        return action
      case let .close(action, _):
        return action
      case let .done(action, _):
        return action
      case let .refresh(action, _):
        return action
      case let .share(action, _):
        return action
      case let .delete(action, _):
        return action
      case let .write(action, _):
        return action
      case let .lock(action, _):
        return action
      case let .add(action, _):
        return action
      case let .text(_, action, _):
        return action
      case let .settings(action, _):
        return action
      }
    }
    
    var title: String? {
      switch self {
      case let .text(text, _, _):
        return text
      default:
        return nil
      }
    }
    
    var image: UIImage? {
      switch self {
      case .close:
        return UIImage(systemName: "xmark")
      case .edit:
        return UIImage(systemName: "arrow.up.arrow.down")
      case .done:
        return UIImage(systemName: "checkmark")
      case .refresh:
        return UIImage(systemName: "arrow.circlepath")
      case .share:
        return UIImage(systemName: "square.and.arrow.up")
      case .delete:
        return UIImage(systemName: "trash")
      case .write:
        return UIImage(systemName: "square.and.pencil")
      case .lock:
        return UIImage(systemName: "lock")
      case .add:
        return UIImage(systemName: "plus")
      case .settings:
        return UIImage(systemName: "gear")
      case .text:
        return nil
      }
    }
    
    case edit(action: (() -> Void)?, buttonItem: ((SKBarButtonItem?) -> Void)? = nil)
    case close(action: (() -> Void)?, buttonItem: ((SKBarButtonItem?) -> Void)? = nil)
    case add(action: (() -> Void)?, buttonItem: ((SKBarButtonItem?) -> Void)? = nil)
    case done(action: (() -> Void)?, buttonItem: ((SKBarButtonItem?) -> Void)? = nil)
    case refresh(action: (() -> Void)?, buttonItem: ((SKBarButtonItem?) -> Void)? = nil)
    case share(action: (() -> Void)?, buttonItem: ((SKBarButtonItem?) -> Void)? = nil)
    case delete(action: (() -> Void)?, buttonItem: ((SKBarButtonItem?) -> Void)? = nil)
    case write(action: (() -> Void)?, buttonItem: ((SKBarButtonItem?) -> Void)? = nil)
    case lock(action: (() -> Void)?, buttonItem: ((SKBarButtonItem?) -> Void)? = nil)
    case settings(action: (() -> Void)?, buttonItem: ((SKBarButtonItem?) -> Void)? = nil)
    case text(_ text: String, action: (() -> Void)?, buttonItem: ((SKBarButtonItem?) -> Void)? = nil)
  }
}
