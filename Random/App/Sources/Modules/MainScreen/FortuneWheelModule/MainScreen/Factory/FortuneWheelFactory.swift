//
//  FortuneWheelFactory.swift
//  Random
//
//  Created by Vitalii Sosin on 11.06.2023.
//

import UIKit
import RandomWheel

/// Cобытия которые отправляем из Factory в Presenter
protocol FortuneWheelFactoryOutput: AnyObject {}

/// Cобытия которые отправляем от Presenter к Factory
protocol FortuneWheelFactoryInput {}

/// Фабрика
final class FortuneWheelFactory: FortuneWheelFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: FortuneWheelFactoryOutput?
  
  // MARK: - Internal func
  
  func highlightWinnerWith(finishIndex: Int,
                           slices: [RandomWheel.Slice],
                           isHighlight: Bool) -> [RandomWheel.Slice] {
    let rotateSlices = rotateArray(
      fromIndex: finishIndex,
      in: slices
    )
    
    if isHighlight {
      let newSlices = rotateSlices.enumerated().compactMap { index, slice in
        if index == .zero {
          return slice
        } else {
          var slice = slice
          slice.backgroundColor = slice.backgroundColor?.withAlphaComponent(0.4)
          return slice
        }
      }
      return newSlices
    } else {
      let newSlices = rotateSlices.compactMap {
        var slice = $0
        slice.backgroundColor = slice.backgroundColor?.withAlphaComponent(1)
        return slice
      }
      return newSlices
    }
  }
  
  func rotateArray<T>(fromIndex index: Int, in array: [T]) -> [T] {
    guard array.indices.contains(index), !array.isEmpty else {
      return array
    }
    let head = array[index..<array.endIndex]
    let tail = array[array.startIndex..<index]
    return Array(head) + Array(tail)
  }
}

// MARK: - Appearance

private extension FortuneWheelFactory {
  struct Appearance {}
}
