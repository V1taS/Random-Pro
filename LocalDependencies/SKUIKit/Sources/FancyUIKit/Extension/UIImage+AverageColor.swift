//
//  UIImage+AverageColor.swift
//  
//
//  Created by Vitalii Sosin on 02.01.2023.
//

import UIKit

public extension UIImage {
  func getAverageColor(completion: @escaping (UIColor?) -> Void) {
    DispatchQueue.global().async {
      guard let inputImage = CIImage(image: self) else {
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }
      let extentVector = CIVector(x: inputImage.extent.origin.x,
                                  y: inputImage.extent.origin.y,
                                  z: inputImage.extent.size.width,
                                  w: inputImage.extent.size.height)
      
      guard let filter = CIFilter(name: "CIAreaAverage",
                                  parameters: [kCIInputImageKey: inputImage,
                                              kCIInputExtentKey: extentVector]) else {
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }
      
      guard let outputImage = filter.outputImage, let kCFNull = kCFNull else {
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }
      
      var bitmap = [UInt8](repeating: .zero, count: 4)
      let context = CIContext(options: [.workingColorSpace: kCFNull])
      context.render(outputImage,
                     toBitmap: &bitmap,
                     rowBytes: 4,
                     bounds: CGRect(x: .zero,
                                    y: .zero,
                                    width: 1,
                                    height: 1),
                     format: .RGBA8,
                     colorSpace: nil)
      DispatchQueue.main.async {
        completion(UIColor(red: CGFloat(bitmap[.zero]) / 255,
                           green: CGFloat(bitmap[1]) / 255,
                           blue: CGFloat(bitmap[2]) / 255,
                           alpha: CGFloat(bitmap[3]) / 255))
      }
    }
  }
}
