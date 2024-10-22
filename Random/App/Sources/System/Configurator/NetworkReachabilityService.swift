//
//  NetworkReachabilityService.swift
//  SKServices
//
//  Created by Vitalii Sosin on 21.10.2024.
//

#if !os(watchOS)

import Foundation
import SystemConfiguration

public protocol INetworkReachabilityService {
  
  /// Доступность интернета
  var isReachable: Bool { get }
}

/// Класс `NetworkReachabilityManager` отслеживает изменения доступности хостов и адресов как для WWAN, так и для
/// сетевых интерфейсов Wi-Fi.
///
/// Достижимость можно использовать для определения справочной информации о том, почему сетевая операция не удалась, или для повторной попытки
/// сетевые запросы при установлении соединения. Его не следует использовать для предотвращения запуска сети пользователем.
/// запрос, так как первоначальный запрос может потребоваться для установления достижимости.
public final class NetworkReachabilityService {
  
  /// Определяет различные состояния доступности сети.
  ///
  /// - unknown: неизвестно, доступна ли сеть.
  /// - notReachable: сеть недоступна.
  /// - reachable: сеть доступ.
  public enum NetworkReachabilityStatus {
    case unknown
    case notReachable
    case reachable(ConnectionType)
  }
  
  /// Определяет различные типы соединений, обнаруженные флагами достижимости.
  ///
  /// - ethernetOrWiFi: тип соединения — через Ethernet или WiFi.
  /// - wwan: тип соединения — соединение WWAN.
  public enum ConnectionType {
    case ethernetOrWiFi
    case wwan
  }
  
  /// Closure, выполняется при изменении состояния доступности сети. Закрытие принимает один аргумент:
  /// состояние доступности сети.
  public typealias Listener = (NetworkReachabilityStatus) -> Void
  
  // MARK: - Public properties
  
  /// Доступна ли сеть в данный момент.
  public var isReachable: Bool {
    isReachableOnWWAN || isReachableOnEthernetOrWiFi
  }
  
  /// Доступна ли сеть в данный момент через интерфейс WWAN.
  public var isReachableOnWWAN: Bool {
    networkReachabilityStatus == .reachable(.wwan)
  }
  
  /// Доступна ли сеть в данный момент через интерфейс Ethernet или WiFi.
  public var isReachableOnEthernetOrWiFi: Bool {
    networkReachabilityStatus == .reachable(.ethernetOrWiFi)
  }
  
  /// Текущий статус доступности сети.
  public var networkReachabilityStatus: NetworkReachabilityStatus {
    guard let flags = self.flags else { return .unknown }
    return networkReachabilityStatusForFlags(flags)
  }
  
  /// Очередь отправки для выполнения `listener`.
  public var listenerQueue: DispatchQueue = DispatchQueue.main
  
  /// Closure, выполняется при изменении состояния доступности сети.
  public var listener: Listener?
  
  /// Флаги, указывающие на доступность имени или адреса сетевого узла, в том числе на то,
  /// требуется ли соединение и может ли потребоваться какое-либо вмешательство пользователя
  /// при установлении соединения.
  public var flags: SCNetworkReachabilityFlags? {
    var flags = SCNetworkReachabilityFlags()
    
    if SCNetworkReachabilityGetFlags(reachability, &flags) {
      return flags
    }
    
    return nil
  }
  
  /// Кеш `SCNetworkReachabilityFlags`
  public var previousFlags: SCNetworkReachabilityFlags
  
  // MARK: - Private properties
  
  private let reachability: SCNetworkReachability
  
  // MARK: - Initialization
  
  /// Создает экземпляр `NetworkReachabilityManager` с указанным хостом.
  ///
  /// - parameter host: Хост, используемый для оценки доступности сети.
  ///
  /// - returns: Новый экземпляр `NetworkReachabilityManager`.
  public convenience init?(host: String) {
    guard let reachability = SCNetworkReachabilityCreateWithName(nil, host) else { return nil }
    self.init(reachability: reachability)
  }
  
  /// Создает экземпляр `NetworkReachabilityManager`, который отслеживает адрес 0.0.0.0.
  ///
  /// Доступность обрабатывает адрес 0.0.0.0 как специальный токен, который заставляет его отслеживать общую маршрутизацию.
  /// статус устройства, как IPv4, так и IPv6.
  ///
  /// - returns: Новый экземпляр `NetworkReachabilityManager`.
  public convenience init?() {
    var address = sockaddr_in()
    address.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    address.sin_family = sa_family_t(AF_INET)
    
    guard let reachability = withUnsafePointer(to: &address, { pointer in
      return pointer.withMemoryRebound(to: sockaddr.self, capacity: MemoryLayout<sockaddr>.size) {
        return SCNetworkReachabilityCreateWithAddress(nil, $0)
      }
    }) else { return nil }
    
    self.init(reachability: reachability)
  }
  
  private init(reachability: SCNetworkReachability) {
    self.reachability = reachability
    
    // Установите для предыдущих флагов незарезервированное значение, чтобы представить неизвестный статус
    self.previousFlags = SCNetworkReachabilityFlags(rawValue: 1 << 30)
  }
  
  deinit {
    stopListening()
  }
  
  // MARK: - Public func
  
  /// Начинает прослушивать изменения состояния доступности сети.
  ///
  /// - returns: `true` if listening was started successfully, `false` otherwise.
  @discardableResult
  public func startListening() -> Bool {
    var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
    context.info = Unmanaged.passUnretained(self).toOpaque()
    
    let callbackEnabled = SCNetworkReachabilitySetCallback(
      reachability,
      { (_, flags, info) in
        let reachability = Unmanaged<NetworkReachabilityService>.fromOpaque(info!).takeUnretainedValue()
        reachability.notifyListener(flags)
      },
      &context
    )
    
    let queueEnabled = SCNetworkReachabilitySetDispatchQueue(reachability, listenerQueue)
    
    listenerQueue.async {
      self.previousFlags = SCNetworkReachabilityFlags(rawValue: 1 << 30)
      
      guard let flags = self.flags else { return }
      
      self.notifyListener(flags)
    }
    
    return callbackEnabled && queueEnabled
  }
  
  /// Прекращает прослушивание изменений состояния доступности сети.
  public func stopListening() {
    SCNetworkReachabilitySetCallback(reachability, nil, nil)
    SCNetworkReachabilitySetDispatchQueue(reachability, nil)
  }
  
  // MARK: - Internal func
  
  /// Уведомление слушателя
  func notifyListener(_ flags: SCNetworkReachabilityFlags) {
    guard previousFlags != flags else { return }
    previousFlags = flags
    
    listener?(networkReachabilityStatusForFlags(flags))
  }
  
  /// Статус доступности сети
  func networkReachabilityStatusForFlags(_ flags: SCNetworkReachabilityFlags) -> NetworkReachabilityStatus {
    guard isNetworkReachable(with: flags) else { return .notReachable }
    
    var networkStatus: NetworkReachabilityStatus = .reachable(.ethernetOrWiFi)
    
#if os(iOS)
    if flags.contains(.isWWAN) { networkStatus = .reachable(.wwan) }
#endif
    
    return networkStatus
  }
  
  /// Проверка доступности по сети
  func isNetworkReachable(with flags: SCNetworkReachabilityFlags) -> Bool {
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    let canConnectAutomatically = flags.contains(.connectionOnDemand) || flags.contains(.connectionOnTraffic)
    let canConnectWithoutUserInteraction = canConnectAutomatically && !flags.contains(.interventionRequired)
    
    return isReachable && (!needsConnection || canConnectWithoutUserInteraction)
  }
}

// MARK: - Equatable

extension NetworkReachabilityService.NetworkReachabilityStatus: Equatable {
  
  /// Возвращает, равны ли два значения состояния доступности сети.
  ///
  /// - parameter lhs: Левое значение для сравнения.
  /// - parameter rhs: Значение правой стороны для сравнения.
  ///
  /// - returns: `true`, если два значения равны, `false` в противном случае.
  public static func ==(lhs: NetworkReachabilityService.NetworkReachabilityStatus,
                        rhs: NetworkReachabilityService.NetworkReachabilityStatus) -> Bool {
    switch (lhs, rhs) {
    case (.unknown, .unknown):
      return true
    case (.notReachable, .notReachable):
      return true
    case let (.reachable(lhsConnectionType), .reachable(rhsConnectionType)):
      return lhsConnectionType == rhsConnectionType
    default:
      return false
    }
  }
}

extension NetworkReachabilityService: INetworkReachabilityService {}

#endif
