//
//  IdentifiableAndCodable.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 17.05.2024.
//

import Foundation

// MARK: - Hashable, Equatable, Codable

/// `IdentifiableAndCodable` — это typealias, который объединяет протоколы `Hashable`, `Equatable` и `Codable`.
///
/// Применение этого typealias позволяет классу или структуре соответствовать всем трем протоколам,
/// что обеспечивает возможность:
/// - Хэширования для использования в коллекциях, таких как `Set` или в качестве ключей `Dictionary`.
/// - Сравнения на равенство для проверки идентичности объектов.
/// - Кодирования и декодирования для сериализации данных, что полезно для сохранения и передачи данных.
///
/// Пример использования:
/// ```swift
/// public typealias IdentifiableAndCodable = Hashable & Equatable & Codable
///
/// struct WalletModel: IdentifiableAndCodable {
///     var id: String
///     var balance: Double
///     // Другие свойства и методы
/// }
/// ```
public typealias IdentifiableAndCodable = Hashable & Equatable & Codable
