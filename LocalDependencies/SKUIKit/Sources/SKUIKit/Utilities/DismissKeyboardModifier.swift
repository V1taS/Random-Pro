//
//  DismissKeyboardModifier.swift
//
//
//  Created by Vitalii Sosin on 13.01.2024.
//

import SwiftUI

struct DismissKeyboardModifier: ViewModifier {
  @Environment(\.dismissKeyboard) var dismissKeyboard
  
  func body(content: Content) -> some View {
    content
      .onTapGesture {
        dismissKeyboard()
      }
  }
}

extension EnvironmentValues {
  var dismissKeyboard: () -> Void {
    return {
      UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
  }
}

public extension View {
  func dismissKeyboardOnTap() -> some View {
    self.modifier(DismissKeyboardModifier())
  }
}
