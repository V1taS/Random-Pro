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
  func getOnboardingPagesForPresent(network: NetworkService,
                                    storage: StorageService,
                                    completion: (([WelcomeSheetPage]) -> Void)?)
}

final class OnboardingServiceImpl: OnboardingService {
  
  // MARK: - Internal func
  
  func getOnboardingPagesForPresent(network: NetworkService,
                                    storage: StorageService,
                                    completion: (([WelcomeSheetPage]) -> Void)?) {
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
    
    cashedOnboardingModels.enumerated().forEach { index, cashedScreen in
      if models.contains(where: { $0.title == cashedScreen.onboardingData.title }) {
        cashedOnboardingModels[index].isWatched = true
      }
    }
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
  
  func fetchContent(from network: NetworkService, completion: (([OnboardingScreenModel]) -> Void)?) {
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
            guard let onboardingPageDTO = network.map(
              data,
              to: [OnboardingScreenModel.OnboardingData].self
            ) else {
              return
            }
            let models = onboardingPageDTO.compactMap {
              return OnboardingScreenModel(isWatched: false, onboardingData: $0)
            }
            completion?(models)
          case .failure:
            break
          }
        }
      }
  }
  
  func getOnboardingScreenModels(from storageService: StorageService) -> [OnboardingScreenModel] {
    storageService.getData(from: [OnboardingScreenModel].self) ?? []
  }
  
  func saveFetchedModels(_ fetchedModels: [OnboardingScreenModel], to storage: StorageService) {
    guard !fetchedModels.isEmpty else {
      return
    }
    
    let cachedOnboardingScreenModels = getOnboardingScreenModels(from: storage)
    let cachedTitles = cachedOnboardingScreenModels.map { $0.onboardingData.title }
    let newPageModels = fetchedModels.filter { !cachedTitles.contains($0.onboardingData.title) }
    let modelsToSave = cachedOnboardingScreenModels + newPageModels
    storage.saveData(modelsToSave)
  }
  
  func createWelcomePagesForPresent(from storage: StorageService) -> [WelcomeSheetPage] {
    let unwatchedModels = getOnboardingScreenModels(from: storage).filter { !$0.isWatched }
    
    return unwatchedModels.prefix(3).enumerated().map { index, model in
      var welcomeSheetPage = WelcomeSheetPage(title: model.onboardingData.title,
                                              rows: model.onboardingData.contents.map {
        WelcomeSheetPageRow(imageSystemName: $0.symbolsSF, title: $0.title, content: $0.description)
      })
      
      if unwatchedModels.count == 1 || index + 1 == 3 {
        welcomeSheetPage.mainButtonTitle = RandomStrings.Localizable.complete
      } else {
        welcomeSheetPage.mainButtonTitle = RandomStrings.Localizable.continue
      }
      return welcomeSheetPage
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
