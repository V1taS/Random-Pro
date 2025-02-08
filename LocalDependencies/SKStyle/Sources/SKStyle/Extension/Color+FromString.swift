//
//  Color+FromString.swift
//  SKStyle
//
//  Created by Vitalii Sosin on 15.08.2024.
//

import SwiftUI
import CryptoKit

public extension Color {
  /// Генерирует цвет на основе входной строки.
  ///
  /// - Параметр input: Строка, на основе которой будет генерироваться цвет.
  /// - Возвращаемое значение: Яркий цвет, основанный на входной строке, с различными оттенками, выбираемыми из 50 базовых цветов.
  ///
  /// Функция генерирует хэш-значение из входной строки и использует его для выбора одного из 50 заранее определенных ярких цветов. После этого функция варьирует оттенок выбранного цвета, создавая более разнообразные варианты.
  ///
  /// Пример использования:
  /// ```
  /// let color = Color.colorFromString("Hello world")
  /// ```
  static func colorFromString(_ input: String) -> Color {
    // Генерируем хэш-значение с использованием SHA256
    let data = Data(input.utf8)
    let hash = SHA256.hash(data: data)
    
    // Преобразуем хэш в массив байт
    let hashBytes = Array(hash)
    
    // Массив из 50 ярких цветов без фиолетовых и похожих
    let baseColors: [(red: Double, green: Double, blue: Double)] = [
      (red: 1.0, green: 0.0, blue: 0.0),    // Красный
      (red: 0.0, green: 1.0, blue: 0.0),    // Зеленый
      (red: 0.0, green: 0.0, blue: 1.0),    // Синий
      (red: 1.0, green: 0.65, blue: 0.0),   // Оранжевый
      (red: 1.0, green: 1.0, blue: 0.0),    // Желтый
      (red: 0.0, green: 1.0, blue: 1.0),    // Голубой
      (red: 1.0, green: 0.5, blue: 0.5),    // Светло-красный
      (red: 0.0, green: 0.5, blue: 1.0),    // Светло-синий
      (red: 0.5, green: 1.0, blue: 0.5),    // Светло-зеленый
      (red: 1.0, green: 0.0, blue: 0.5),    // Розовый
      (red: 1.0, green: 0.25, blue: 0.25),  // Алый
      (red: 0.25, green: 0.75, blue: 0.75), // Бирюзовый
      (red: 0.5, green: 1.0, blue: 0.0),    // Лаймовый
      (red: 1.0, green: 0.75, blue: 0.0),   // Золотой
      (red: 0.0, green: 0.5, blue: 0.5),    // Темно-бирюзовый
      (red: 1.0, green: 0.85, blue: 0.0),   // Ярко-желтый
      (red: 0.75, green: 1.0, blue: 0.25),  // Лайм
      (red: 1.0, green: 0.85, blue: 0.25),  // Светло-золотой
      (red: 0.25, green: 0.75, blue: 1.0),  // Голубой топаз
      (red: 0.75, green: 0.75, blue: 0.0),  // Оливковый
      (red: 1.0, green: 0.25, blue: 0.75),  // Розовый кварц
      (red: 0.25, green: 1.0, blue: 0.5),   // Мятный
      (red: 1.0, green: 0.5, blue: 0.0),    // Коралловый
      (red: 0.85, green: 0.85, blue: 0.1),  // Грушевый
      (red: 1.0, green: 0.85, blue: 0.85),  // Персиковый
      (red: 0.75, green: 0.25, blue: 0.25), // Шоколадный
      (red: 0.0, green: 0.5, blue: 0.25),   // Изумрудный
      (red: 1.0, green: 0.75, blue: 0.75),  // Кремово-розовый
      (red: 0.5, green: 0.25, blue: 0.0),   // Светло-коричневый
      (red: 0.85, green: 0.65, blue: 0.1),  // Горчичный
      (red: 0.0, green: 0.75, blue: 0.5),   // Малахитовый
      (red: 0.5, green: 0.75, blue: 0.75),  // Серо-голубой
      (red: 1.0, green: 0.65, blue: 0.65),  // Светло-красный
      (red: 0.65, green: 0.85, blue: 1.0),  // Светло-голубой
      (red: 1.0, green: 0.5, blue: 0.25),   // Оранжево-красный
      (red: 0.25, green: 1.0, blue: 0.25),  // Ярко-зеленый
      (red: 0.25, green: 0.75, blue: 0.0),  // Лайм-зеленый
      (red: 1.0, green: 0.85, blue: 0.65),  // Светло-оранжевый
      (red: 0.5, green: 0.85, blue: 0.0),   // Ярко-лаймовый
      (red: 0.75, green: 0.5, blue: 0.0),   // Темно-оранжевый
      (red: 0.0, green: 0.65, blue: 0.25),  // Малахитово-зеленый
      (red: 0.85, green: 1.0, blue: 0.0),   // Ярко-желто-зеленый
      (red: 1.0, green: 0.5, blue: 0.5),    // Светло-коралловый
      (red: 0.85, green: 0.75, blue: 0.0),  // Горчично-желтый
      (red: 0.75, green: 0.25, blue: 0.0),  // Каштановый
      (red: 0.75, green: 0.85, blue: 0.25), // Оливково-зеленый
      (red: 1.0, green: 0.85, blue: 0.75),  // Пастельно-оранжевый
      (red: 0.85, green: 0.85, blue: 0.65), // Песочный
      (red: 1.0, green: 0.0, blue: 0.25)    // Ярко-красный
    ]
    
    // Выбор одного из 50 базовых цветов
    let colorIndex = Int(hashBytes[0] % 50)
    let baseColor = baseColors[colorIndex]
    
    // Варьируем оттенок в выбранном диапазоне с расширенными вариациями
    let redVariation = Double(hashBytes[1] % 255) / 255.0 * 0.6 // Варьируем до ±60% от базового
    let greenVariation = Double(hashBytes[2] % 255) / 255.0 * 0.6
    let blueVariation = Double(hashBytes[3] % 255) / 255.0 * 0.6
    
    let red = min(baseColor.red + redVariation, 1.0)
    let green = min(baseColor.green + greenVariation, 1.0)
    let blue = min(baseColor.blue + blueVariation, 1.0)
    
    // Возвращаем цвет с заметным изменением оттенка
    return Color(red: red, green: green, blue: blue)
  }
}
