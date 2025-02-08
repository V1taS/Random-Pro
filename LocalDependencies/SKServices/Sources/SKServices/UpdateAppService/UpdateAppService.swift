//
//  UpdateAppService.swift
//  Random Pro
//
//  Created by SOSIN Vitaly on 10.01.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import Foundation
import SKAbstractions

public final class UpdateAppServiceImpl: UpdateAppService {
  public init() {}

  // MARK: - Private properties

  public func checkIsUpdateAvailable(isOneCheckVersion: Bool,
                                     completion: @escaping (Result<UpdateAppServiceModel, UpdateAppServiceError>) -> Void) {
    let appearance = Appearance()
    guard let info = Bundle.main.infoDictionary,
          let currentDeviceVersion = info["CFBundleShortVersionString"] as? String,
          let identifier = info["CFBundleIdentifier"] as? String,
          let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(identifier)") else {
      completion(.failure(.invalidBundleInfo))
      return
    }

    DispatchQueue.global().async {
      URLSession.shared.dataTask(with: url) { (data, _, error) in
        if let error {
          DispatchQueue.main.async {
            completion(.failure(.somethingWrongWith(error.localizedDescription)))
          }
          return
        }

        guard let data else {
          DispatchQueue.main.async {
            completion(.failure(.invalidData))
          }
          return
        }

        do {
          let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any]
          guard let result = (json?["results"] as? [Any])?.first as? [String: Any],
                let appStoreVersion = result["version"] as? String else {
            completion(.failure(.invalidResponse))
            return
          }
          DispatchQueue.main.async {
            if isOneCheckVersion {
              if UserDefaults.standard.string(forKey: appearance.keyUserDefaults) == appStoreVersion {
                completion(.failure(.invalidResponse))
              } else {
                completion(.success(UpdateAppServiceModel(isUpdateAvailable: appStoreVersion != currentDeviceVersion,
                                                          appStoreVersion: appStoreVersion,
                                                          currentDeviceVersion: currentDeviceVersion)))
              }
              UserDefaults.standard.set(appStoreVersion, forKey: appearance.keyUserDefaults)
            } else {
              completion(.success(UpdateAppServiceModel(isUpdateAvailable: appStoreVersion != currentDeviceVersion,
                                                        appStoreVersion: appStoreVersion,
                                                        currentDeviceVersion: currentDeviceVersion)))
            }
          }
        } catch {
          DispatchQueue.main.async {
            completion(.failure(.somethingWrongWith(error.localizedDescription)))
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
