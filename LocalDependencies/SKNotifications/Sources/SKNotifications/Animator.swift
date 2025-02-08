//
//  Animator.swift
//
//
//  Created by Vitalii Sosin on 08.07.2022.
//

import UIKit

final class Animator {
  
  // MARK: - Internal properties
  
  var isAnimatingPan = false
  
  // MARK: - Private properties
  
  private var layoutContainer: UIView? {
    UIApplication.shared.topMostViewController?.view
  }
  
  private var dismissInProgress = false
  private let panInProgressTransform = Appearance().panInProgressTransform
  private var isDismissPending = false
  private var safeAreaTopInset: CGFloat {
    UIApplication.currentWindow?.safeAreaInsets.top ?? .zero
  }
  
  // MARK: - Internal func
  
  func animateDismiss(_ viewToDismiss: UIView?) {
    guard let oldView = viewToDismiss else { return }
    
    dismissInProgress = true
    UIView.animate(
      withDuration: Appearance().timeoutDismissDuration,
      delay: .zero,
      options: [.curveEaseIn, .beginFromCurrentState],
      animations: {
        oldView.transform = self.transform(for: oldView)
      },
      completion: { _ in
        self.dismissInProgress = false
        oldView.removeFromSuperview()
      }
    )
  }
  
  func animateTap(_ tappedView: UIView?) {
    guard !dismissInProgress, let view = tappedView else { return }
    let appearance = Appearance()
    
    dismissInProgress = true
    UIView.animate(
      withDuration: appearance.tapDismissDuration,
      delay: .zero,
      options: [.curveEaseIn, .beginFromCurrentState],
      animations: {
        view.transform = appearance.animateTap
        view.alpha = .zero
      },
      completion: { _ in
        self.dismissInProgress = false
        view.removeFromSuperview()
      }
    )
  }
  
  func animatePan(with gesture: UIPanGestureRecognizer) {
    guard let view = gesture.view else { return }
    let appearance = Appearance()
    
    switch gesture.state {
    case .began:
      isAnimatingPan = true
      UIView.animate(withDuration: appearance.animatePan) {
        view.transform = self.panInProgressTransform
      }
    case .changed:
      let translation = gesture.translation(in: layoutContainer)
      let y: CGFloat = translation.y < .zero ? translation.y : sqrt(translation.y)
      view.transform = panInProgressTransform.translatedBy(x: .zero, y: y)
    case .ended, .cancelled, .failed:
      if gesture.velocity(in: layoutContainer).y < .zero {
        let velocity = min(appearance.animatePanMin,
                           abs(gesture.velocity(in: layoutContainer).y / self.translation(for: view)))
        animateSwipeAway(with: view, initialVelocity: velocity)
      } else {
        animateSnapToInitialPosition(view)
      }
    default: break
    }
  }
  
  func dismissWhenAvailable() {
    isDismissPending = true
  }
  
  func animateTransition(from oldView: UIView?, to newView: UIView) {
    guard let container = layoutContainer else { return }
    let appearance = Appearance()
    
    [newView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      layoutContainer?.addSubview($0)
    }
    
    if #available(iOS 11.0, *) {
      NSLayoutConstraint.activate([
        newView.leadingAnchor.constraint(equalTo: container.leadingAnchor,
                                         constant: appearance.horizontalMargin),
        newView.trailingAnchor.constraint(equalTo: container.trailingAnchor,
                                          constant: -appearance.horizontalMargin),
        newView.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor,
                                     constant: appearance.topMargin)
      ])
    } else {
      NSLayoutConstraint.activate([
        newView.leadingAnchor.constraint(equalTo: container.leadingAnchor,
                                         constant: appearance.horizontalMargin),
        newView.trailingAnchor.constraint(equalTo: container.trailingAnchor,
                                          constant: -appearance.horizontalMargin),
        newView.topAnchor.constraint(equalTo: container.topAnchor,
                                     constant: appearance.topMargin)
      ])
    }
    
    newView.transform = transform(for: newView)
    
    UIView.animate(
      withDuration: appearance.swapDuration,
      delay: .zero,
      usingSpringWithDamping: appearance.animateTransitionDamping,
      initialSpringVelocity: .zero,
      options: [.curveEaseInOut, .beginFromCurrentState, .allowUserInteraction],
      animations: {
        newView.transform = .identity
        if !self.dismissInProgress {
          oldView?.transform = appearance.animateTransitionTransform
          oldView?.alpha = .zero
        }
      },
      completion: { _ in
        oldView?.removeFromSuperview()
      }
    )
  }
}

// MARK: - Private

private extension Animator {
  private func animateSwipeAway(with view: UIView?, initialVelocity: CGFloat) {
    guard let view = view else { return }
    let appearance = Appearance()
    
    dismissInProgress = true
    UIView.animate(
      withDuration: appearance.animateSwipeAwayWithDuration,
      delay: .zero,
      usingSpringWithDamping: appearance.animateSwipeAwayDamping,
      initialSpringVelocity: initialVelocity,
      options: [.beginFromCurrentState, .curveEaseIn],
      animations: {
        self.dismissInProgress = false
        view.transform = self.transform(for: view)
      },
      completion: { _ in
        view.removeFromSuperview()
        self.isAnimatingPan = false
        self.checkForPendingDismiss(for: view)
      }
    )
  }
  
  private func animateSnapToInitialPosition(_ view: UIView?) {
    let appearance = Appearance()
    
    UIView.animate(
      withDuration: appearance.animateSnapToInitialPositionWithDuration,
      delay: .zero,
      usingSpringWithDamping: appearance.animateSnapToInitialPositionDamping,
      initialSpringVelocity: .zero,
      options: [.beginFromCurrentState, .curveEaseInOut, .allowUserInteraction],
      animations: {
        view?.transform = .identity
      },
      completion: { _ in
        self.isAnimatingPan = false
        self.checkForPendingDismiss(for: view)
      }
    )
  }
  
  private func checkForPendingDismiss(for view: UIView?) {
    if isDismissPending {
      isDismissPending = false
      animateDismiss(view)
    }
  }
  
  private func transform(for view: UIView) -> CGAffineTransform {
    CGAffineTransform(translationX: .zero, y: translation(for: view))
  }
  
  private func translation(for view: UIView) -> CGFloat {
    -(height(for: view) + Appearance().topMargin + safeAreaTopInset)
  }
  
  private func height(for view: UIView) -> CGFloat {
    view.layoutIfNeeded()
    let targetSize = Appearance().targetSize
    return view.systemLayoutSizeFitting(
      targetSize,
      withHorizontalFittingPriority: .required,
      verticalFittingPriority: .defaultLow
    ).height
  }
}

// MARK: - UIApplication

private extension UIApplication {
  var topMostViewController: UIViewController? {
    // Получаем активную сцену
    guard let activeScene = connectedScenes.first(where: {
      $0.activationState == .foregroundActive
    }) as? UIWindowScene else {
      return nil
    }
    
    // Получаем корневой контроллер у активного окна
    guard let rootViewController = activeScene.windows
      .first(where: { $0.isKeyWindow })?.rootViewController else {
      return nil
    }
    
    return rootViewController.topMostViewController
  }
}

// MARK: - UIViewController

private extension UIViewController {
  var topMostViewController : UIViewController {
    
    if let presented = self.presentedViewController {
      return presented.topMostViewController
    }
    
    if let navigation = self as? UINavigationController {
      return navigation.visibleViewController?.topMostViewController ?? navigation
    }
    
    if let tab = self as? UITabBarController {
      return tab.selectedViewController?.topMostViewController ?? tab
    }
    
    return self
  }
}

// MARK: - Appearance

private extension Animator {
  struct Appearance {
    let swapDuration: TimeInterval = 0.65
    let timeoutDismissDuration: TimeInterval = 0.3
    let tapDismissDuration: TimeInterval = 0.15
    let horizontalMargin: CGFloat = 16
    let topMargin: CGFloat = 12
    
    let panInProgressTransform = CGAffineTransform(scaleX: 0.98, y: 0.98)
    let animateTap = CGAffineTransform(scaleX: 0.65, y: 0.65)
    let animatePan = 0.25
    let animatePanMin: CGFloat = 1
    
    let animateSwipeAwayWithDuration = 0.45
    let animateSwipeAwayDamping = 0.75
    
    let animateSnapToInitialPositionWithDuration = 0.35
    let animateSnapToInitialPositionDamping = 0.75
    
    let animateTransitionTransform = CGAffineTransform(scaleX: 0.65, y: 0.65)
      .concatenating(.init(translationX: 0, y: -10))
    let animateTransitionDamping = 0.85
    
    let targetSize = CGSize(width: UIScreen.main.bounds.width - 16 * 2, height: .zero)
  }
}

private extension UIApplication {
  /// Возвращает текущее активное окно приложения.
  static var currentWindow: UIWindow? {
    return UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first(where: { $0.isKeyWindow })
  }
}
