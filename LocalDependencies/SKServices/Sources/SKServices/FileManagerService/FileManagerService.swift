//
//  FileManager.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.09.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import SKAbstractions

public final class FileManagerImpl: FileManagerService {
  public init() {}
  
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
