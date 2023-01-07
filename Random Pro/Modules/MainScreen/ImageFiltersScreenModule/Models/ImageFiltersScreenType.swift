//
//  ImageFiltersScreenType.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

enum ImageFiltersScreenType: CaseIterable {
  
  /// Название фильтра
  var rawValue: String {
    switch self {
    case .chrome:
      return "CIPhotoEffectChrome"
    case .fade:
      return "CIPhotoEffectFade"
    case .instant:
      return "CIPhotoEffectInstant"
    case .mono:
      return "CIPhotoEffectMono"
    case .noir:
      return "CIPhotoEffectNoir"
    case .process:
      return "CIPhotoEffectProcess"
    case .tonal:
      return "CIPhotoEffectTonal"
    case .transfer:
      return "CIPhotoEffectTransfer"
    case .sepiaTone:
      return "CISepiaTone"
    case .halftone:
      return "CICMYKHalftone"
    case .unsharpMask:
      return "CIUnsharpMask"
    case .exposureAdjust:
      return "CIExposureAdjust"
    case .colorPosterize:
      return "CIColorPosterize"
    case .morphologyMaximum:
      return "CIMorphologyMaximum"
    case .gammaAdjust:
      return "CIGammaAdjust"
    case .morphologyMinimum:
      return "CIMorphologyMinimum"
    case .hueAdjust:
      return "CIHueAdjust"
    case .linearToSRGBToneCurve:
      return "CILinearToSRGBToneCurve"
    case .sharpenLuminance:
      return "CISharpenLuminance"
    case .vibrance:
      return "CIVibrance"
    case .motionBlur:
      return "CIMotionBlur"
    case .whitePointAdjust:
      return "CIWhitePointAdjust"
    case .colorMonochrome:
      return "CIColorMonochrome"
    case .dither:
      return "CIDither"
    }
  }
  
  /// Увеличивает контраст
  case chrome
  
  /// Затемнение изображения
  case fade
  
  /// Добавление синего
  case instant
  
  /// Черно-белый цвет
  case mono
  
  /// Черно-белый цвет более насыщенный
  case noir
  
  /// Добавление зеленого
  case process
  
  /// Черно-белый (светлый) цвет
  case tonal
  
  /// Цветной контраст
  case transfer
  
  /// Светло-коричневый
  case sepiaTone
  
  /// Черная сеточка
  case halftone
  
  /// Делает более четкое изображение
  case unsharpMask
  
  /// Осветляет фото
  case exposureAdjust
  
  /// Фильтр художника
  case colorPosterize
  
  /// Имитация рисунка
  case morphologyMaximum
  
  /// Делает затемнение
  case gammaAdjust
  
  /// Темные цвета будут еще более темные
  case morphologyMinimum
  
  /// Перекрашивает в разные цвета
  case hueAdjust
  
  /// Осветляет изображение
  case linearToSRGBToneCurve
  
  /// Улучшает качество изображения
  case sharpenLuminance
  
  /// Добавляет теплоты к фото
  case vibrance
  
  /// Добавляются прозрачные кубики на изображение
  case motionBlur
  
  /// Добавляет определенный цвет к темным цветам
  case whitePointAdjust
  
  /// Добавляет определенный цвет
  case colorMonochrome
  
  /// Делает мазайку
  case dither
}
