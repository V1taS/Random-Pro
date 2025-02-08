//
//  ImageCacheService.swift
//  SKFoundation
//
//  Created by Vitalii Sosin on 18.05.2024.
//

import UIKit

/// Сервис для кэширования изображений.
public final class ImageCacheService {
  
  // MARK: - Public properties
  
  /// Общий экземпляр сервиса.
  public static let shared = ImageCacheService()
  
  /// Максимальный возраст кэша
  public let cacheMaxAge: CacheDuration = .year
  
  // MARK: - Private properties
  
  /// URLCache для хранения изображений в памяти и на диске.
  private let cache = URLCache(
    memoryCapacity: 50 * 1024 * 1024, // 50 MB
    diskCapacity: 100 * 1024 * 1024, // 100 MB
    diskPath: "imageCache"
  )
  
  // MARK: - Init
  
  /// Приватный инициализатор, чтобы запретить создание других экземпляров.
  private init() {}
  
  /// Получение изображения по URL.
  /// - Parameters:
  ///   - url: URL изображения.
  ///   - completion: Замыкание, вызываемое с загруженным изображением или nil.
  public func getImage(for url: URL?, completion: @escaping (UIImage?) -> Void) {
    guard let url else {
      DispatchQueue.main.async {
        completion(nil)
      }
      return
    }
    let request = URLRequest(url: url)
    
    // Проверка, есть ли изображение в кэше
    if let cachedResponse = cache.cachedResponse(for: request),
       let image = UIImage(data: cachedResponse.data) {
      
      let cachedDate = cachedResponse.userInfo?["cachedDate"] as? Date ?? Date.distantPast
      if Date().timeIntervalSince(cachedDate) < cacheMaxAge.timeInterval{
        DispatchQueue.main.async {
          completion(image)
        }
        return
      } else {
        cache.removeAllCachedResponses()
      }
    }
    
    // Если нет, загрузить изображение
    URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
      guard let self,
            let data,
            let response,
            error == nil,
            let image = UIImage(data: data) else {
        DispatchQueue.main.async {
          completion(nil)
        }
        return
      }
      
      // Кэширование изображения
      let cachedData = CachedURLResponse(
        response: response,
        data: data,
        userInfo: ["cachedDate": Date()],
        storagePolicy: .allowed
      )
      self.cache.storeCachedResponse(cachedData, for: request)
      
      DispatchQueue.main.async {
        completion(image)
      }
    }.resume()
  }
}

// MARK: - CacheDuration

extension ImageCacheService {
  /// Периоды кэширования.
  public enum CacheDuration {
    /// Кэширование на один день.
    case day
    
    /// Кэширование на один месяц.
    case month
    
    /// Кэширование на один год.
    case year
    
    /// Бесконечное время.
    case infinity
    
    /// Возвращает значение времени кэша в секундах.
    /// - Returns: Время кэширования в секундах для соответствующего периода.
    var timeInterval: TimeInterval {
      switch self {
      case .day:
        return 60 * 60 * 24
      case .month:
        return 60 * 60 * 24 * 30
      case .year:
        return 60 * 60 * 24 * 365
      case .infinity:
        return .infinity
      }
    }
  }
}
