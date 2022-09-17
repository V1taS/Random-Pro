//
//  OnboardingScreenView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.09.2022.
//

import UIKit
import RandomUIKit

/// События которые отправляем из View в Presenter
protocol OnboardingScreenViewOutput: AnyObject {
  
  /// Страница изменена
  /// - Parameter page: Номер страницы
  func didChangePage(to page: Int)
  
  /// Была нажата кнопка
  /// - Parameter page: Номер страницы
  func didPressButton(to page: Int)
  
  /// Закрыть экран
  func didPressCloseButton()
}

/// События которые отправляем от Presenter ко View
protocol OnboardingScreenViewInput: AnyObject {
  
  /// Установить онбоардинг
  /// - Parameter models: Моделька данных
  func setOnboardingWith(_ models: [OnboardingScreenModel])
  
  /// Установить название у кнопки
  /// - Parameter title: Название кнопки
  func setButtonTitle(_ title: String)
  
  /// Установить страницу
  /// - Parameter page: Номер страницы
  func setPage(_ page: Int)
}

/// Псевдоним протокола UIView & OnboardingScreenViewInput
typealias OnboardingScreenViewProtocol = UIView & OnboardingScreenViewInput

/// View для экрана
final class OnboardingScreenView: OnboardingScreenViewProtocol {
  
  // MARK: - Internal properties
  
  weak var output: OnboardingScreenViewOutput?
  
  // MARK: - Private properties
  
  private let button = ButtonView()
  private let pageIndicator = UIPageControl()
  private let scrollView = UIScrollView()
  private let stackView = UIStackView()
  private let closeButton = UIButton()
  
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
  
  func setButtonTitle(_ title: String) {
    button.setTitle(title, for: .normal)
  }
  
  func setPage(_ page: Int) {
    pageIndicator.currentPage = page
    pageIndicatorAction()
  }
  
  func setOnboardingWith(_ models: [OnboardingScreenModel]) {
    let screensView: [OnboardingScreenContainerView] = models.map { model in
      let screen = OnboardingScreenContainerView()
      screen.configureWith(image: model.image ?? Data(),
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
        screen.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        screen.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
      ])
    }
  }
}

// MARK: - UIScrollViewDelegate

extension OnboardingScreenView: UIScrollViewDelegate {
  func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                 withVelocity velocity: CGPoint,
                                 targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    pageIndicator.currentPage = Int(targetContentOffset.pointee.x) / Int(frame.size.width)
    output?.didChangePage(to: pageIndicator.currentPage)
  }
}

// MARK: - Private

private extension OnboardingScreenView {
  func configureLayout() {
    let appearance = Appearance()
    
    [stackView].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      scrollView.addSubview($0)
    }
    
    [pageIndicator, scrollView, button, closeButton].forEach {
      $0.translatesAutoresizingMaskIntoConstraints = false
      addSubview($0)
    }
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                      constant: appearance.insetLarge * 2),
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.7),
      
      closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,
                                       constant: appearance.insetMiddle),
      closeButton.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -appearance.insetMiddle),
      
      pageIndicator.bottomAnchor.constraint(equalTo: button.topAnchor,
                                            constant: -appearance.insetLarge),
      pageIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
      
      button.leadingAnchor.constraint(equalTo: leadingAnchor,
                                      constant: appearance.insetMiddle),
      button.trailingAnchor.constraint(equalTo: trailingAnchor,
                                       constant: -appearance.insetMiddle),
      button.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor,
                                     constant: -appearance.insetMiddle),
      
      stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
    ])
  }
  
  func applyDefaultBehavior() {
    backgroundColor = RandomColor.primaryWhite
    
    pageIndicator.hidesForSinglePage = true
    pageIndicator.currentPageIndicatorTintColor = RandomColor.primaryGray
    pageIndicator.pageIndicatorTintColor = RandomColor.tertiaryGray
    pageIndicator.addTarget(self,
                            action: #selector(pageIndicatorAction),
                            for: .valueChanged)
    
    scrollView.isPagingEnabled = true
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.delegate = self
    
    stackView.axis = .horizontal
    stackView.alignment = .top
    
    button.addTarget(self,
                     action: #selector(buttonAction),
                     for: .touchUpInside)
    
    closeButton.setImage(Appearance().closeButtonIcon, for: .normal)
    closeButton.addTarget(self,
                          action: #selector(closeButtonction),
                          for: .touchUpInside)
  }
  
  @objc
  func closeButtonction() {
    output?.didPressCloseButton()
  }
  
  @objc
  func buttonAction() {
    output?.didPressButton(to: pageIndicator.currentPage)
  }
  
  @objc
  func pageIndicatorAction() {
    scrollView.setContentOffset(CGPoint(x: CGFloat(pageIndicator.currentPage) * scrollView.bounds.width,
                                        y: .zero),
                                animated: true)
    output?.didChangePage(to: pageIndicator.currentPage)
  }
}

// MARK: - Appearance

private extension OnboardingScreenView {
  struct Appearance {
    let insetMiddle: CGFloat = 16
    let insetLarge: CGFloat = 24
    let closeButtonIcon = UIImage(systemName: "xmark")
  }
}
