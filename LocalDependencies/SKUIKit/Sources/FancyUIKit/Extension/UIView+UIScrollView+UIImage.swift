//
//  UIView+UIScrollView+UIImage.swift
//  
//
//  Created by Vitalii Sosin on 28.08.2022.
//

import UIKit

/// UIView делаем изображением
public extension UIView {
  
  /// Изображение
  var asImage: UIImage? {
    get {
      return generateMockup()
    }
  }
  
  private func generateMockup() -> UIImage? {
    let rect = CGRect(x: .zero, y: .zero, width: bounds.size.width, height: bounds.size.height)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
    drawHierarchy(in: rect, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
  }
}

/// UIScrollView делаем изображением
public extension UIScrollView {
  
  /// Сделать изображение видимого контента
  func asImage(scale: CGFloat = UIScreen.main.scale) -> UIImage? {
    let currentSize = frame.size
    let currentOffset = contentOffset
    
    frame.size = contentSize
    setContentOffset(.zero, animated: false)
    
    let rect = CGRect(x: .zero, y: .zero, width: bounds.size.width, height: bounds.size.height)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
    drawHierarchy(in: rect, afterScreenUpdates: true)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    frame.size = currentSize
    setContentOffset(currentOffset, animated: false)
    
    return resizeUIImage(image: image, scale: scale)
  }
  
  /// Сделать изображение всего контента
  func screenShotFullContent(scale: CGFloat = UIScreen.main.scale,
                             completion: @escaping (_ screenshot: UIImage?) -> Void) {
    let pointsAndFrames = getScreenshotRects()
    let points = pointsAndFrames.points
    let frames = pointsAndFrames.frames
    let finalSize = CGSize(width: contentSize.width * scale, height: contentSize.height * scale)
    
    makeScreenshots(points: points, frames: frames, scale: scale) { (screenshots) -> Void in
      let stitched = self.stitchImages(images: screenshots, finalSize: finalSize)
      completion(stitched)
    }
  }
  
  // MARK: - Private
  
  private func makeScreenshots(points points_I: [[CGPoint]],
                               frames frames_I: [[CGRect]],
                               scale: CGFloat,
                               completion: @escaping (_ screenshots: [[UIImage]]) -> Void) {
    
    var counter: Int = .zero
    var images: [[UIImage]] = [] {
      didSet {
        if counter < points_I.count {
          internalScreenshotRow()
        } else {
          completion(images)
        }
      }
    }
    
    func internalScreenshotRow() {
      makeScreenshotRow(points: points_I[counter], frames: frames_I[counter], scale: scale) { (screenshot) -> Void in
        counter += 1
        images.append(screenshot)
      }
    }
    internalScreenshotRow()
  }
  
  
  private func makeScreenshotRow(points points_I: [CGPoint],
                                 frames frames_I: [CGRect],
                                 scale: CGFloat,
                                 completion: @escaping (_ screenshots: [UIImage]) -> Void) {
    var counter: Int = .zero
    var images: [UIImage] = [] {
      didSet {
        if counter < points_I.count {
          internalTakeScreenshotAtPoint()
        } else {
          completion(images)
        }
      }
    }
    
    func internalTakeScreenshotAtPoint() {
      takeScreenshotAtPoint(point: points_I[counter], scale: scale) { (screenshot) -> Void in
        if let screenshot = screenshot {
          counter += 1
          images.append(screenshot)
        }
      }
    }
    
    internalTakeScreenshotAtPoint()
  }
  
  private func getScreenshotRects() -> (points: [[CGPoint]],
                                        frames: [[CGRect]]) {
    let zeroOriginBounds = CGRect(x: .zero,
                                  y: .zero,
                                  width: bounds.size.width,
                                  height: bounds.size.height)
    var currentOffset = CGPoint(x: 0, y: 0)
    let xPartial = contentSize.width.truncatingRemainder(dividingBy: bounds.size.width)
    let yPartial = contentSize.height.truncatingRemainder(dividingBy: bounds.size.height)
    
    let xSlices = Int((contentSize.width - xPartial) / bounds.size.width)
    let ySlices = Int((contentSize.height - yPartial) / bounds.size.height)
    
    var offsets : [[CGPoint]] = []
    var rects : [[CGRect]] = []
    
    var xSlicesWithPartial : Int = xSlices
    
    if xPartial > .zero {
      xSlicesWithPartial += 1
    }
    
    var ySlicesWithPartial : Int = ySlices
    
    if yPartial > .zero {
      ySlicesWithPartial += 1
    }
    
    for y in 0..<ySlicesWithPartial {
      var offsetRow : [CGPoint] = []
      var rectRow : [CGRect] = []
      currentOffset.x = .zero
      
      for x in 0..<xSlicesWithPartial {
        if y == ySlices && x == xSlices {
          let rect = CGRect(x: bounds.width - xPartial,
                            y: bounds.height - yPartial,
                            width: xPartial,
                            height: yPartial)
          rectRow.append(rect)
        } else if y == ySlices {
          let rect = CGRect(x: .zero,
                            y: bounds.height - yPartial,
                            width: bounds.width,
                            height: yPartial)
          rectRow.append(rect)
        } else if x == xSlices {
          let rect = CGRect(x: bounds.width - xPartial,
                            y: .zero,
                            width: xPartial,
                            height: bounds.height)
          rectRow.append(rect)
        } else {
          rectRow.append(zeroOriginBounds)
        }
        
        offsetRow.append(currentOffset)
        
        if x == xSlices {
          currentOffset.x = contentSize.width - bounds.size.width
        } else {
          currentOffset.x = currentOffset.x + bounds.size.width
        }
      }
      if y == ySlices {
        currentOffset.y = contentSize.height - bounds.size.height
      } else {
        currentOffset.y = currentOffset.y + bounds.size.height
      }
      
      offsets.append(offsetRow)
      rects.append(rectRow)
    }
    return (points: offsets, frames: rects)
  }
  
  
  private func takeScreenshotAtPoint(point point_I: CGPoint,
                                     scale: CGFloat,
                                     completion: @escaping (_ screenshot: UIImage?) -> Void) {
    let rect = CGRect(x: .zero,
                      y: .zero,
                      width: bounds.size.width,
                      height: bounds.size.height)
    let currentOffset = contentOffset
    setContentOffset(point_I, animated: false)

    delay(delay: 0.002) { [weak self] in
      guard let self = self else {
        return
      }

      UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
      self.drawHierarchy(in: rect, afterScreenUpdates: true)

      var image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()

      if scale != 1 {
        image = self.resizeUIImage(image: image, scale: scale)
      }
      
      self.setContentOffset(currentOffset, animated: false)
      completion(image)
    }
  }
  
  private func delay(delay: Double, closure: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
      closure()
    })
  }
  
  private func resizeUIImage(image: UIImage?, scale: CGFloat) -> UIImage? {
    guard let image = image else {
      return nil
    }
    
    let size = image.size
    let targetSize = CGSize(width: size.width * scale, height: size.height * scale)
    let rect = CGRect(x: .zero, y: .zero, width: targetSize.width, height: targetSize.height)
    
    UIGraphicsBeginImageContextWithOptions(targetSize, false, UIScreen.main.scale)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage
  }
  
  private func stitchImages(images imagesI: [[UIImage]], finalSize finalSizeI: CGSize) -> UIImage? {
    let finalRect = CGRect(x: .zero, y: .zero, width: finalSizeI.width, height: finalSizeI.height)
    
    guard let firstRow = imagesI.first, let _ = firstRow.first else {
      return nil
    }
    
    UIGraphicsBeginImageContext(finalRect.size)
    var offsetY: CGFloat = .zero
    
    for imageRow in imagesI {
      var offsetX : CGFloat = .zero
      
      for image in imageRow {
        let width = image.size.width
        let height = image.size.height
        
        let rect = CGRect(x: offsetX, y: offsetY, width: width, height: height)
        image.draw(in: rect)
        offsetX += width
      }
      
      if let firstimage = imageRow.first {
        offsetY += firstimage.size.height
      }
    }
    
    let stitchedImages = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return stitchedImages
  }
}
