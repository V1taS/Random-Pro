//
//  UIImage+Compress.swift
//  
//
//  Created by Vitalii Sosin on 07.01.2023.
//

import UIKit

public extension UIImage {
  func compress(maxKb: Double) -> Data? {
    let quality: CGFloat = maxKb / sizeAsKb()
    let compressedData: Data? = self.jpegData(compressionQuality: quality)
    return compressedData
  }
  
  func sizeAsKb() -> Double {
    Double(self.pngData()?.count ?? .zero / 1024)
  }
}
