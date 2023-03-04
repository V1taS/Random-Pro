//
//  FileManagerService.swift
//  FileManagerService
//
//  Created by Vitalii Sosin on 24.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

public final class FileManagerImpl: FileManagerServiceProtocol {
  
  // MARK: - Init
  
  public init() {}
  
  // MARK: - public func
  
  public func saveObjectWith(fileName: String,
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
  
  public func readObjectWith(fileURL: URL) -> Data? {
    do {
      return try Data(contentsOf: fileURL)
    } catch {
      return nil
    }
  }
  
  public func deleteObjectWith(fileURL: URL, isRemoved: ((Bool) -> Void)?) {
    do {
      try FileManager.default.removeItem(at: fileURL)
      isRemoved?(true)
    } catch {
      isRemoved?(false)
    }
  }
}
