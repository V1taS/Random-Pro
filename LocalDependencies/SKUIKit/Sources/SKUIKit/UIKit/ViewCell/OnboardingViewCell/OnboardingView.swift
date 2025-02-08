//
//  OnboardingView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 08.09.2024.
//

import UIKit
import SKStyle

/// OnboardingView
public final class OnboardingView: UIView {
  
  // MARK: - Private properties
  
  private let pageIndicator = UIPageControl()
  private let scrollView = UIScrollView()
  private let stackView = UIStackView()
  private var didChangePageAction: ((_ currentPage: Int) -> Void)?
  
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
  
  func setPage(_ page: Int) {
    pageIndicator.currentPage = page
    pageIndicatorAction()
  }
  
  func setOnboardingWith(_ model: OnboardingViewModel) {
    let screensView: [OnboardingContainerView] = model.pageModels.map { model in
      let screen = OnboardingContainerView()
      screen.configureWith(lottieAnimationJSONName: model.lottieAnimationJSONName,
                           title: model.title,
                           description: model.description)
      return screen
    }
    
    pageIndicator.numberOfPages = screensView.count
    stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    screensView.forEach { screen in
      screen.translatesAutoresizingMaskIntoConstraints = false
      stackView.addArrangedSubview(screen)
      NSLayoutConstraint.activate([
        screen.widthAnchor.constraint(equalTo: widthAnchor),
        scrollView.heightAnchor.constraint(equalTo: screen.heightAnchor)
      ])
    }
    didChangePageAction = model.didChangePageAction
  }
}

// MARK: - UIScrollViewDelegate

extension OnboardingView: UIScrollViewDelegate {
  public func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                        withVelocity velocity: CGPoint,
                                        targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    pageIndicator.currentPage = Int(targetContentOffset.pointee.x) / Int(frame.size.width)
    didChangePageAction?(pageIndicator.currentPage)
  }
}

// MARK: - Private

private extension OnboardingView {
  func configureLayout() {
    [stackView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      scrollView.addSubview($0)
    }
    
    [scrollView, pageIndicator].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollView.widthAnchor.constraint(equalTo: widthAnchor),
      
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      
      pageIndicator.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
      pageIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      pageIndicator.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = SKStyleAsset.onyx.color
    
    pageIndicator.hidesForSinglePage = true
    pageIndicator.currentPageIndicatorTintColor = SKStyleAsset.ghost.color
    pageIndicator.pageIndicatorTintColor = SKStyleAsset.constantSlate.color
    pageIndicator.addTarget(self,
                            action: #selector(pageIndicatorAction),
                            for: .valueChanged)
    
    scrollView.isPagingEnabled = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.delegate = self
    
    stackView.axis = .horizontal
    stackView.alignment = .top
  }
  
  @objc
  func pageIndicatorAction() {
    scrollView.setContentOffset(CGPoint(x: CGFloat(pageIndicator.currentPage) * scrollView.bounds.width,
                                        y: .zero),
                                animated: true)
    didChangePageAction?(pageIndicator.currentPage)
  }
}

// MARK: - Appearance

private extension OnboardingView {
  struct Appearance {
    let defaultInset: CGFloat = 16
  }
}

