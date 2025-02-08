//
//  FileManagerService.swift
//  SKAbstractions
//
//  Created by Vitalii Sosin on 9.02.2025.
//

import Foundation

public protocol FileManagerService {

  /// Сохранить объект
  /// - Parameters:
  ///  - fileName: Название файла
  ///  - fileExtension: Расширение файла `.txt`
  ///  - data: Файл для записи
  /// - Returns: Путь до файла `URL`
  func saveObjectWith(fileName: String,
                      fileExtension: String,
                      data: Data) -> URL?

  /// Получить объект
  /// - Parameter fileURL: Путь к файлу
  /// - Returns: Путь до файла `URL`
  func readObjectWith(fileURL: URL) -> Data?

  /// Удалить объект
  /// - Parameters:
  ///  - fileURL: Путь к файлу
  ///  - isRemoved: Удален объект или нет
  /// - Returns: Путь до файла `URL`
  func deleteObjectWith(fileURL: URL, isRemoved: ((Bool) -> Void)?)
}
