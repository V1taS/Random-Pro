//
//  PurchasesCardsCellModel.swift
//  RandomUIKitExample
//
//  Created by Vitalii Sosin on 15.01.2023.
//

import Foundation

public struct PurchasesCardsCellModel {
  
  /// Тайтл в заголовке
  let header: String?
  
  /// Тайтл
  let title: String?
  
  /// Описание
  let description: String?
  
  /// Сумма
  let amount: String?
  
  /// Экшен
  let action: (() -> Void)?
  
  // MARK: - Initialization
  
  /// - Parameters:
  ///   - header: Тайтл в заголовке
  ///   - title: Тайтл
  ///   - description: Описание
  ///   - amount: Сумма
  ///   - action: Экшен
  public init(header: String?,
              title: String?,
              description: String?,
              amount: String?,
              action: (() -> Void)?) {
    self.header = header
    self.title = title
    self.description = description
    self.amount = amount
    self.action = action
  }
}
