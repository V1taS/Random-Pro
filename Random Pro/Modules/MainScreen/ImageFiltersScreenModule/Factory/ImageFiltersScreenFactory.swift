//
//  ImageFiltersScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.01.2023.
//

import UIKit
import CoreImage

/// Cобытия которые отправляем из Factory в Presenter
protocol ImageFiltersScreenFactoryOutput: AnyObject {
  
  /// Получена ошибка
  func didReceiveError()
  
  /// Новое изображение получено
  /// - Parameter image: Изображение
  func didReceiveNewImage(_ image: Data)
}

/// Cобытия которые отправляем от Presenter к Factory
protocol ImageFiltersScreenFactoryInput {
  
  /// Сгенерировать новый фильтр
  /// - Parameter image: Изображение
  func generateImageFilterFor(image: Data?)
}

/// Фабрика
final class ImageFiltersScreenFactory: ImageFiltersScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: ImageFiltersScreenFactoryOutput?
  
  // MARK: - Private properties
  
  private lazy var filtersType = createImageFiltersType()
  
  // MARK: - Internal func
  
  func generateImageFilterFor(image: Data?) {
    let imageData = image
    
    if filtersType.isEmpty {
      filtersType = createImageFiltersType()
    }
    
    guard let imageData,
          let image = UIImage(data: imageData),
          let imageFilter = filtersType.first else {
      output?.didReceiveError()
      return
    }
    
    var filterValues: [ImageFiltersScreenModel] = []
    
    switch imageFilter {
    case .chrome, .fade, .instant, .mono, .noir, .process, .tonal,
        .transfer, .sepiaTone, .halftone, .linearToSRGBToneCurve:
      filterValues = []
    case .unsharpMask:
      filterValues = [
        ImageFiltersScreenModel(value: 1, key: kCIInputRadiusKey),
        ImageFiltersScreenModel(value: 2, key: kCIInputIntensityKey)
      ]
    case .exposureAdjust:
      filterValues = [
        ImageFiltersScreenModel(value: 1, key: kCIInputEVKey)
      ]
    case .colorPosterize:
      let value = NSNumber(value: Int.random(in: 6...12))
      filterValues = [
        ImageFiltersScreenModel(value: value, key: "inputLevels")
      ]
    case .morphologyMaximum:
      filterValues = [
        ImageFiltersScreenModel(value: 1, key: kCIInputRadiusKey)
      ]
    case .gammaAdjust:
      filterValues = [
        ImageFiltersScreenModel(value: 1.5, key: "inputPower")
      ]
    case .morphologyMinimum:
      filterValues = [
        ImageFiltersScreenModel(value: 1, key: kCIInputRadiusKey)
      ]
    case .hueAdjust:
      let value = NSNumber(value: Int.random(in: 1...1_000_000))
      filterValues = [
        ImageFiltersScreenModel(value: value, key: kCIInputAngleKey)
      ]
    case .sharpenLuminance:
      let value = NSNumber(value: Int.random(in: 1...20))
      filterValues = [
        ImageFiltersScreenModel(value: value, key: kCIInputSharpnessKey),
        ImageFiltersScreenModel(value: 1, key: kCIInputRadiusKey)
      ]
    case .vibrance:
      filterValues = [
        ImageFiltersScreenModel(value: 1, key: "inputAmount")
      ]
    case .motionBlur:
      let value = NSNumber(value: Int.random(in: 1...3))
      filterValues = [
        ImageFiltersScreenModel(value: value, key: kCIInputRadiusKey),
        ImageFiltersScreenModel(value: 1, key: kCIInputAngleKey)
      ]
    case .whitePointAdjust:
      let value = CIColor(red: CGFloat.random(in: 0...1),
                          green: CGFloat.random(in: 0...1),
                          blue: CGFloat.random(in: 0...1),
                          alpha: 1)
      
      filterValues = [
        ImageFiltersScreenModel(value: value, key: kCIInputColorKey)
      ]
    case .colorMonochrome:
      let intensity = NSNumber(value: Double.random(in: 0.2...1))
      let color = CIColor(red: CGFloat.random(in: 0...1),
                          green: CGFloat.random(in: 0...1),
                          blue: CGFloat.random(in: 0...1),
                          alpha: 1)
      
      filterValues = [
        ImageFiltersScreenModel(value: color, key: kCIInputColorKey),
        ImageFiltersScreenModel(value: intensity, key: kCIInputIntensityKey)
      ]
    case .dither:
      let intensity = NSNumber(value: Double.random(in: 0.1...1))
      filterValues = [
        ImageFiltersScreenModel(value: intensity, key: kCIInputIntensityKey)
      ]
    }
    
    addFilterFor(image: image,
                 filter: imageFilter,
                 filterValues: filterValues) { [weak self] result in
      guard let result,
            let imageData = result.jpegData(compressionQuality: 1) else {
        self?.output?.didReceiveError()
        return
      }
      self?.output?.didReceiveNewImage(imageData)
    }
    filtersType.removeFirst()
  }
}

// MARK: - Private

private extension ImageFiltersScreenFactory {
  func createImageFiltersType() -> [ImageFiltersScreenType] {
    var listImageFiltersType = ImageFiltersScreenType.allCases
    (1...30).forEach { _ in
      listImageFiltersType.append(.hueAdjust)
    }
    
    (1...3).forEach { _ in
      listImageFiltersType.append(.sharpenLuminance)
    }
    
    (1...20).forEach { _ in
      listImageFiltersType.append(.colorMonochrome)
    }
    return listImageFiltersType.shuffled()
  }
  
  func addFilterFor(image: UIImage,
                    filter: ImageFiltersScreenType,
                    filterValues: [ImageFiltersScreenModel],
                    completion: @escaping (UIImage?) -> Void) {
    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
      let rotateImage = self?.rotateImage(image: image) ?? UIImage()
      let filter = CIFilter(name: filter.rawValue)
      let ciInput = CIImage(image: rotateImage)
      filter?.setValue(ciInput, forKey: Appearance().inputImageKey)
      filterValues.forEach {
        filter?.setValue($0.value, forKey: $0.key)
      }
      
      let ciOutput = filter?.outputImage
      let ciContext = CIContext()
      
      guard let ciOutput,
            let cgImage = ciContext.createCGImage(ciOutput, from: ciOutput.extent) else {
        DispatchQueue.main.async {
          completion(nil)
        }
        completion(nil)
        return
      }
      DispatchQueue.main.async {
        completion(UIImage(cgImage: cgImage))
      }
    }
  }
  
  func rotateImage(image: UIImage) -> UIImage? {
    if image.imageOrientation == UIImage.Orientation.up {
      return image
    }
    UIGraphicsBeginImageContext(image.size)
    image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
    let copy = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return copy
  }
}

// MARK: - Appearance

private extension ImageFiltersScreenFactory {
  struct Appearance {
    let inputImageKey = "inputImage"
  }
}
