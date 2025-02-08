//
//  SegmentedPickerView.swift
//  SKUIKit
//
//  Created by Vitalii Sosin on 13.09.2024.
//

import SwiftUI
import SKStyle

public struct SegmentedPickerView<Element>: View where Element: Collection, Element.Element: CustomStringConvertible {
  
  // MARK: - Private properties
  @State private var selectedSegment = 0
  @State private var isEnabled: Bool = true
  private let action: ((_ newValue: Int) -> Void)?
  private let segments: Element
  
  // MARK: - Initialization
  
  /// Инициализатор
  /// - Parameters:
  ///   - selectedSegment: Выбранный сегмент
  ///   - segments: Список сегментов
  ///   - isEnabled: Свитчер включен
  ///   - action: Действие по нажатию
  public init(
    selectedSegment: Int,
    segments: Element,
    isEnabled: Bool = true,
    action: ((_ newValue: Int) -> Void)?
  ) {
    self.selectedSegment = selectedSegment
    self.segments = segments
    self.isEnabled = isEnabled
    self.action = action
  }
  
  // MARK: - Body
  
  public var body: some View {
    VStack {
      Picker("", selection: $selectedSegment) {
        ForEach(Array(segments.enumerated()), id: \.offset) { index, element in
          Text("\(element.description)").tag(index)
        }
      }
      .pickerStyle(SegmentedPickerStyle())
      .disabled(!isEnabled)
    }
    .onChange(of: selectedSegment) { newValue in
      Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
        action?(newValue)
      }
    }
  }
}

// MARK: - Constants

private enum Constants {}

// MARK: - Preview

struct SegmentedPickerView_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      HStack {
        SKStyleAsset.onyx.swiftUIColor
      }
      
      VStack {
        HStack {
          Spacer()
          SegmentedPickerView(
            selectedSegment: 0,
            segments: ["1", "2"],
            isEnabled: true,
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
