//
//  URL+UTType.swift
//  SKFoundation
//
//  Created by Vitalii Sosin on 02.08.2024.
//

import Foundation
import UniformTypeIdentifiers

@available(iOS 14.0, *)
extension URL {
  /// Определяет тип содержимого файла по его URL.
  /// - Returns: Тип содержимого файла в виде `UTType`, если его удается определить, иначе `nil`.
  public func getFileType() -> UTType? {
    do {
      let resourceValues = try self.resourceValues(forKeys: [.contentTypeKey])
      return resourceValues.contentType
    } catch {
      return nil
    }
  }
  
  /// Проверяет, является ли файл изображением.
  /// - Returns: `true`, если файл является изображением, иначе `false`.
  public func isImageFile() -> Bool {
    if let fileType = self.getFileType() {
      return fileType.conforms(to: .image)
    } else {
      return ["jpg", "jpeg", "png", "gif", "bmp", "tiff", "heic"].contains(self.pathExtension.lowercased())
    }
  }
  
  /// Проверяет, является ли файл видео.
  /// - Returns: `true`, если файл является видео, иначе `false`.
  public func isVideoFile() -> Bool {
    if let fileType = self.getFileType() {
      return fileType.conforms(to: .movie)
    } else {
      return ["mp4", "mov", "avi", "mkv", "wmv"].contains(self.pathExtension.lowercased())
    }
  }
  
  /// Проверяет, является ли файл аудио.
  /// - Returns: `true`, если файл является аудио, иначе `false`.
  public func isAudioFile() -> Bool {
    if let fileType = self.getFileType() {
      return fileType.conforms(to: .audio)
    } else {
      return ["mp3", "wav", "aac", "flac"].contains(self.pathExtension.lowercased())
    }
  }
}
