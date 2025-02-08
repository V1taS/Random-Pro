//
//  View+If.swift
//
//
//  Created by Vitalii Sosin on 14.12.2023.
//

import SwiftUI

extension View {
  // Функция для условного применения модификатора
  @ViewBuilder
  public func `if`<TrueContent: View, FalseContent: View>(
    _ condition: Bool,
    transform: (Self) -> TrueContent,
    else falseTransform: (Self) -> FalseContent
  ) -> some View {
    if condition {
      transform(self)
    } else {
      falseTransform(self)
    }
  }
  
  // Определение, когда нет 'else' части
  @ViewBuilder
  public func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
    if condition {
      transform(self)
    } else {
      self
    }
  }
}
