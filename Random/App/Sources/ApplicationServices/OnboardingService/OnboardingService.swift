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

  func addWatchedStatusForModels(_ models: [WelcomeSheetPage], storageService: StorageService)

  func getOnboardingModelsForPresentation(storageService: StorageService) -> [WelcomeSheetPage]
}

final class OnboardingServiceImpl: OnboardingService {

  typealias WelcomePages = OnboardingScreenModel.OnboardingData

  // MARK: - Internal func

  func getContent(networkService: NetworkService, storageService: StorageService, completion: (([WelcomeSheetPage]) -> Void)?) {

    let appearance = Appearance()
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint

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
            guard let onboardingPages = networkService.map(data, to: [WelcomePages].self) else {
              return
            }

            let onboardingScreenModels = self.createOnboardingScreenModels(from: onboardingPages)
            self.saveOnboardingScreensToStorage(storageService: storageService, fetchedOnboardingScreens: onboardingScreenModels)

            completion?(self.getOnboardingModelsForPresentation(storageService: storageService))
          case .failure: break
          }
        }
      }
  }

  func getOnboardingModelsForPresentation(storageService: StorageService) -> [WelcomeSheetPage] {
    var modelsForPresentation: [WelcomePages] = []

    var cashedOnboardingScreens = getOnboardingScreensFromStorage(storageService: storageService)

    _ = cashedOnboardingScreens.map { cashedScreen in
      if cashedScreen.isWatched == false {
        modelsForPresentation.append(cashedScreen.onboardingData)
      }
    }

    var pagesForPresentation: [WelcomePages] = []

    _ = modelsForPresentation.enumerated().map { element in
      if element.offset <= 2 {
        pagesForPresentation.append(element.element)
      } else {
        return
      }
    }

    return createWelcomePage(pagesForPresentation)
  }

  func addWatchedStatusForModels(_ watchedModels: [WelcomeSheetPage], storageService: StorageService) {
    var cashedOnboardingScreens = getOnboardingScreensFromStorage(storageService: storageService)
    var timeModel: [OnboardingScreenModel] = []

    _ = cashedOnboardingScreens.map { cashedScreen in

      var index = 0

      _ = watchedModels.map { watchedScreen in

        if cashedScreen.onboardingData.title == watchedScreen.title {
          let newOnboardingScreen = OnboardingScreenModel(isWatched: true, onboardingData: cashedScreen.onboardingData)
          cashedOnboardingScreens.remove(at: index)
          index -= 1
          timeModel.append(newOnboardingScreen)
        }

      }
      index += 1
    }

    cashedOnboardingScreens += timeModel
    storageService.saveData(cashedOnboardingScreens)
  }

  private func getOnboardingScreensFromStorage(storageService: StorageService) -> [OnboardingScreenModel] {
    var models: [OnboardingScreenModel] = []
    models = storageService.getData(from: [OnboardingScreenModel].self) ?? []
    return models
  }

  private func saveOnboardingScreensToStorage(storageService: StorageService, fetchedOnboardingScreens: [OnboardingScreenModel]) {
    guard fetchedOnboardingScreens != [] else {
      return
    }

    let cashedOnboardingScreens = getOnboardingScreensFromStorage(storageService: storageService)
    var newScreens: [OnboardingScreenModel] = []

    let cashedModels = cashedOnboardingScreens.compactMap { model in
      model.onboardingData
    }

    if cashedOnboardingScreens.count == 0 {
      newScreens = fetchedOnboardingScreens
    } else {
      _ = fetchedOnboardingScreens.map { fetchedModel in
        if !cashedModels.contains(fetchedModel.onboardingData) {
          newScreens.append(fetchedModel)
        }
      }
    }

    let onboardingScreensToSave = cashedOnboardingScreens + newScreens

    storageService.saveData(onboardingScreensToSave)
  }

  private func createOnboardingScreenModels(from pages: [WelcomePages]) -> [OnboardingScreenModel] {
    var onboardingScreenModels: [OnboardingScreenModel] = []

    _ = pages.map { page in
      let onboardingScreenModel = OnboardingScreenModel(isWatched: false, onboardingData: page)
      onboardingScreenModels.append(onboardingScreenModel)
    }

    return onboardingScreenModels
  }

  private func createWelcomePage(_ data: [WelcomePages]) -> [WelcomeSheetPage] {
    var welcomePages: [WelcomeSheetPage] = []

    _ = data.map { page in
      welcomePages.append(WelcomeSheetPage(
        title: page.title,
        rows: page.contents.map { row in
          WelcomeSheetPageRow(
            imageSystemName: row.symbolsSF,
            title: row.title,
            content: row.description
          )
        }
      ))
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
