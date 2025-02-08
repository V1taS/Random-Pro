//
//  CheckmarkView.swift
//
//
//  Created by Vitalii Sosin on 15.01.2024.
//

import SwiftUI
import SKStyle

public struct CheckmarkView: View {
  
  // MARK: - Private properties
  
  @State private var toggleValue: Bool = false
  @State private var isChangeValue = true
  private let text: String?
  private let style: CheckmarkView.Style
  private let action: ((_ newValue: Bool) -> Void)?
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - text: Текст, который будет отображаться рядом с чек боксом
  ///   - toggleValue: Значение по умолчанию
  ///   - isChangeValue: Может менять свое значение
  ///   - style: Стиль
  ///   - action: Действие по нажатию
  public init(
    text: String? = nil,
    toggleValue: Bool = false,
    isChangeValue: Bool = true,
    style: CheckmarkView.Style = .rectangle,
    action: ((_ newValue: Bool) -> Void)?
  ) {
    self.text = text
    self.toggleValue = toggleValue
    self.isChangeValue = isChangeValue
    self.style = style
    self.action = action
  }
  
  // MARK: - Body
  
  public var body: some View {
    HStack {
      HStack(alignment: .center, spacing: .s3) {
        TapGestureView(
          style: .flash,
          touchesEnded: {
            guard isChangeValue else {
              return
            }
            toggleValue.toggle()
            action?(toggleValue)
          }
        ) {
          Image(systemName: style.createSystemName(toggleValue))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(height: .s6)
            .foregroundColor(toggleValue ? SKStyleAsset.constantAzure.swiftUIColor : SKStyleAsset.constantSlate.swiftUIColor)
        }
        
        if let text {
          Text(text)
            .font(.fancy.text.small)
            .foregroundColor(SKStyleAsset.constantSlate.swiftUIColor)
            .lineLimit(.max)
            .allowsHitTesting(false)
          
          Spacer()
        }
      }
    }
  }
}

// MARK: - Constants

private enum Constants {}

// MARK: - Preview

struct CheckmarkView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      HStack {
        SKStyleAsset.onyx.swiftUIColor
      }
      
      VStack {
        HStack {
          Spacer()
          CheckmarkView(
            text: "Я понимаю, что в случае утери фразы восстановления потеряю также доступ к кошельку",
            action: { newValue in }
          )
          Spacer()
        }
      }
    }
    .background(SKStyleAsset.onyx.swiftUIColor)
    .ignoresSafeArea(.all)
  }
}
