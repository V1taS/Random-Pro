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

  /// Сохранение статус просмотрено для онбоардинг моделей
  ///  - Parameter storage: StorageService
  ///  - Parameter models: массив просмотренных моделей
  func saveWatchedStatus(to storage: StorageService, for models: [WelcomeSheetPage])

  /// Получить онбоардинг модели для представления
  ///  - Parameter network: NetworkService
  ///  - Parameter storage: StorageService
  ///  - Parameter completion: полученные онбоардинг модели
  func getOnboardingPagesForPresent(network: NetworkService, storage: StorageService, completion: (([WelcomeSheetPage]) -> Void)?)
}

final class OnboardingServiceImpl: OnboardingService {

  typealias OnboardingPageModel = OnboardingScreenModel.OnboardingData

  // MARK: - Internal func

  func getOnboardingPagesForPresent(network: NetworkService, storage: StorageService, completion: (([WelcomeSheetPage]) -> Void)?) {
    fetchContent(from: network) { [weak self] fetchedPageModels in
      guard let self = self else {
        return
      }

      self.saveFetchedModels(fetchedPageModels, to: storage)
      completion?(self.createWelcomePagesForPresent(from: storage))
    }
  }

  func saveWatchedStatus(to storage: StorageService, for models: [WelcomeSheetPage]) {
    var cashedOnboardingModels = getOnboardingScreenModels(from: storage)
    var watchedModels: [OnboardingScreenModel] = []

    _ = cashedOnboardingModels.map { cashedScreen in
      var index = 0

      _ = models.map { watchedModel in
        if cashedScreen.onboardingData.title == watchedModel.title {
          let newOnboardingModel = OnboardingScreenModel(isWatched: true, onboardingData: cashedScreen.onboardingData)
          cashedOnboardingModels.remove(at: index)
          index -= 1
          watchedModels.append(newOnboardingModel)
        }
      }
      index += 1
    }

    cashedOnboardingModels += watchedModels
    storage.saveData(cashedOnboardingModels)
  }
}

// MARK: - Private func

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

  func fetchContent(from network: NetworkService, completion: (([OnboardingPageModel]) -> Void)?) {
    let appearance = Appearance()
    let host = appearance.host
    let apiVersion = appearance.apiVersion
    let endPoint = appearance.endPoint

    network.performRequestWith(
      urlString: host + apiVersion + endPoint,
      queryItems: [
        .init(name: "language", value: getDefaultLanguage())
      ],
      httpMethod: .get,
      headers: [
        .contentTypeJson,
        .additionalHeaders(set: [(key: appearance.apiKey, value: appearance.apiValue)])
      ]) { result in
        DispatchQueue.main.async {
          switch result {
          case let .success(data):
            guard let onboardingPageModels = network.map(data, to: [OnboardingPageModel].self) else {
              return
            }
            completion?(onboardingPageModels)
          case .failure: break
          }
        }
      }
  }

  func getOnboardingScreenModels(from storageService: StorageService) -> [OnboardingScreenModel] {
    storageService.getData(from: [OnboardingScreenModel].self) ?? []
  }

  func createOnboardingScreenModels(from onboardingPageModels: [OnboardingPageModel]) -> [OnboardingScreenModel] {
    onboardingPageModels.compactMap { OnboardingScreenModel(isWatched: false, onboardingData: $0) }
  }

  func saveFetchedModels(_ fetchedModels: [OnboardingPageModel], to storage: StorageService) {
    guard fetchedModels != [] else {
      return
    }

    let cashedOnboardingScreenModels = getOnboardingScreenModels(from: storage)

    let newPageModels = cashedOnboardingScreenModels.count == 0
    ? fetchedModels
    : fetchedModels.filter { !cashedOnboardingScreenModels.compactMap { $0.onboardingData}.contains($0) }

    let modelsToSave = cashedOnboardingScreenModels + createOnboardingScreenModels(from: newPageModels)
    storage.saveData(modelsToSave)
  }

  func createWelcomePagesForPresent(from storage: StorageService) -> [WelcomeSheetPage] {
    getOnboardingScreenModels(from: storage)
      .lazy
      .filter { $0.isWatched == false }
      .enumerated()
      .filter { $0.offset <= 2 }
      .compactMap {
        WelcomeSheetPage(title: $0.element.onboardingData.title,
                         rows: $0.element.onboardingData.contents.map {
          WelcomeSheetPageRow(imageSystemName: $0.symbolsSF, title: $0.title, content: $0.description)
        })
      }
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
