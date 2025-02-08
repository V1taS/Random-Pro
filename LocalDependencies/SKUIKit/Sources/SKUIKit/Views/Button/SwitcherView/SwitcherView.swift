//
//  SwitcherView.swift
//
//
//  Created by Vitalii Sosin on 04.02.2024.
//

import SwiftUI
import SKStyle

public struct SwitcherView: View {
  
  // MARK: - Private properties
  
  @State private var isOn: Bool = false
  @State private var isEnabled: Bool = true
  private let action: ((_ newValue: Bool) -> Void)?
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - isOn: Значение по умолчанию
  ///   - isEnabled: Свитчер включен
  ///   - action: Действие по нажатию
  public init(
    isOn: Bool = false,
    isEnabled: Bool = true,
    action: ((_ newValue: Bool) -> Void)?
  ) {
    self.isOn = isOn
    self.isEnabled = isEnabled
    self.action = action
  }
  
  // MARK: - Body
  
  public var body: some View {
    VStack {
      Toggle("", isOn: $isOn)
        .toggleStyle(SwitchToggleStyle(tint: SKStyleAsset.constantAzure.swiftUIColor))
        .disabled(!isEnabled)
    }
    .onChange(of: isOn) { newValue in
      Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
        action?(newValue)
      }
    }
  }
}

// MARK: - Constants

private enum Constants {}

// MARK: - Preview

struct SwitcherView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      HStack {
        SKStyleAsset.onyx.swiftUIColor
      }
      
      VStack {
        HStack {
          Spacer()
          SwitcherView(
            isOn: true,
            action: { _ in }
          )
          Spacer()
        }
      }
    }
    .background(SKStyleAsset.onyx.swiftUIColor)
    .ignoresSafeArea(.all)
  }
}
