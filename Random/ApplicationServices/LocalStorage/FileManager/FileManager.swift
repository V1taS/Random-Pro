//
//  FileManager.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol FileManagerService {
  
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

final class FileManagerImpl: FileManagerService {
  
  func saveObjectWith(fileName: String,
                      fileExtension: String,
                      data: Data) -> URL? {
    let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[.zero]
    let fileURL = URL(fileURLWithPath: fileName + fileExtension, relativeTo: directoryURL)
    
    do {
      try data.write(to: fileURL)
      return fileURL.absoluteURL
    } catch {
      return nil
    }
  }
  
  func readObjectWith(fileURL: URL) -> Data? {
    do {
      return try Data(contentsOf: fileURL)
    } catch {
      return nil
    }
  }
  
  func deleteObjectWith(fileURL: URL, isRemoved: ((Bool) -> Void)?) {
    do {
      try FileManager.default.removeItem(at: fileURL)
      isRemoved?(true)
    } catch {
      isRemoved?(false)
    }
  }
}
