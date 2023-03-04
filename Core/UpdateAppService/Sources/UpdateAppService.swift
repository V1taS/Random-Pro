//
//  UpdateAppService.swift
//  UpdateAppService
//
//  Created by Vitalii Sosin on 25.02.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation

public final class UpdateAppServiceImpl: UpdateAppServiceProtocol {
  
  // MARK: - Init
  
  public init() {}
  
  // MARK: - Private properties
  
  public func checkIsUpdateAvailable(completion: @escaping (Result<UpdateAppServiceModelProtocol, Error>) -> Void) {
    let appearance = Appearance()
    guard let info = Bundle.main.infoDictionary,
          let currentDeviceVersion = info["CFBundleShortVersionString"] as? String,
          let identifier = info["CFBundleIdentifier"] as? String,
          let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
      completion(.failure(UpdateAppServiceError.invalidBundleInfo))
      return
    }
    
    DispatchQueue.global().async {
      URLSession.shared.dataTask(with: url) { (data, _, error) in
        if let error {
          DispatchQueue.main.async {
            completion(.failure(UpdateAppServiceError.somethingWrongWith(error.localizedDescription)))
          }
          return
        }
        
        guard let data else {
          DispatchQueue.main.async {
            completion(.failure(UpdateAppServiceError.invalidData))
          }
          return
        }
        
        do {
          let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
          guard let result = (json?["results"] as? [Any])?.first as? [String: Any],
                let appStoreVersion = result["version"] as? String else {
            completion(.failure(UpdateAppServiceError.invalidResponse))
            return
          }
          DispatchQueue.main.async {
            if UserDefaults.standard.string(forKey: appearance.keyUserDefaults) == appStoreVersion {
              completion(.failure(UpdateAppServiceError.invalidResponse))
            } else {
              completion(.success(UpdateAppServiceModel(isUpdateAvailable: appStoreVersion != currentDeviceVersion,
                                                        appStoreVersion: appStoreVersion,
                                                        currentDeviceVersion: currentDeviceVersion)))
            }
            UserDefaults.standard.set(appStoreVersion, forKey: appearance.keyUserDefaults)
          }
        } catch {
          DispatchQueue.main.async {
            completion(.failure(UpdateAppServiceError.somethingWrongWith(error.localizedDescription)))
          }
        }
      }.resume()
    }
  }
}

// MARK: - Appearance

private extension UpdateAppServiceImpl {
  struct Appearance {
    let keyUserDefaults = "update_app_user_defaults_key"
  }
}
