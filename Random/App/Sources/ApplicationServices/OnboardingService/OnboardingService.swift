//
//  OnboardingService.swift
//  Random
//
//  Created by Artem Pavlov on 28.06.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import WelcomeSheet
import UIKit
import RandomNetwork
import RandomUIKit

protocol OnboardingService {

  func getContent(networkService: NetworkService, storageService: StorageService, completion: (([WelcomeSheetPage]) -> Void)?)
}

final class OnboardingServiceImpl: OnboardingService {

  // MARK: - Internal func

  func getContent(networkService: NetworkService, storageService: StorageService, completion: (([WelcomeSheetPage]) -> Void)?) {
    let appearance = Appearance()
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint

    var onboardingScreenModel: OnboardingScreenModel? {
      get {
        storageService.getData(from: OnboardingScreenModel.self)
      } set {
        storageService.saveData(newValue)
      }
    }

    networkService.performRequestWith(
      urlString: host + apiVersion + endPoint,
      queryItems: [
        .init(name: "language", value: getDefaultLanguage())
      ],
      httpMethod: .get,
      headers: [
        .contentTypeJson,
        .additionalHeaders(set: [
          (key: appearance.apiKey, value: appearance.apiValue)
        ])
      ]) { result in
        DispatchQueue.main.async {
          switch result {
          case let .success(data):
            guard let onboardingPages = networkService.map(data, to: [OnboardingScreenModel.OnboardingData].self) else {
              return
            }
            completion?(self.createWelcomePage(onboardingPages))
          case .failure: break
          }
        }
      }
  }

  private func createOnboardingScreenModel(from pages: [OnboardingScreenModel.OnboardingData], storageService: StorageService) {
    var onboardingScreenModels: [OnboardingScreenModel] = []

    _ = pages.map { page in
      let onboardingScreenModel = OnboardingScreenModel(isWatched: false, onboardingData: page)
      onboardingScreenModels.append(onboardingScreenModel)


    }

    storageService.saveData(onboardingScreenModels)

  }

  private func checkOnboardingPages(_ pages: [OnboardingScreenModel.OnboardingData]) {

  }

  private func createWelcomePage(_ data: [OnboardingScreenModel.OnboardingData]) -> [WelcomeSheetPage] {
    var welcomePages: [WelcomeSheetPage] = []

    _ = data.map { page in
      page.contents.map { pageRow in
        welcomePages.append(WelcomeSheetPage(title: page.title, rows: [
          WelcomeSheetPageRow(
            imageSystemName: pageRow.symbolsSF,
            title: pageRow.title,
            content: pageRow.description
          )
        ]))
      }
    }

    return welcomePages
  }
}

// MARK: - Private

private extension OnboardingServiceImpl {
  func getDefaultLanguage() -> String {
    let language: String
    let localeType = LanguageType.getCurrentLanguageType()

    switch localeType {
    case .ru:
      language = "ru"
    default:
      language = "en"
    }
    return language
  }
}

// MARK: - Appearance

private extension OnboardingServiceImpl {
  struct Appearance {

    let host = "https://sonorous-seat-386117.ew.r.appspot.com"
    let apiVersion = "/api/v1"
    let endPoint = "/onboarding"
    let apiKey = "api_key"
    let apiValue = "4t2AceLVaSW88H8wJ1f6"
  }
}
