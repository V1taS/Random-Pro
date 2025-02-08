//
//  OnboardingViewModel.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import Foundation

public struct OnboardingViewModel {
  
  /// Список экранов
  let pageModels: [PageModel]
  
  /// Событие при изменение экрана
  var didChangePageAction: ((_ currentPage: Int) -> Void)?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - pageModels: Список экранов
  ///   - didChangePageAction: Событие при изменение экрана
  public init(pageModels: [OnboardingViewModel.PageModel],
              didChangePageAction: ((Int) -> Void)?) {
    self.pageModels = pageModels
    self.didChangePageAction = didChangePageAction
  }
  
  public struct PageModel {
    
    /// Заголовок
    let title: String?
    
    /// Описание
    let description: String?
    
    /// Имя JSON анимированного файла
    let lottieAnimationJSONName: String
    
    // MARK: - Initialization
    
    /// - Parameters:
    ///   - title: Заголовок
    ///   - description: Описание
    ///   - lottieAnimationJSONName: Имя JSON анимированного файла
    public init(title: String?,
                description: String?,
                lottieAnimationJSONName: String) {
      self.title = title
      self.description = description
      self.lottieAnimationJSONName = lottieAnimationJSONName
    }
  }
}
