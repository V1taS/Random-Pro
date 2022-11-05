//
//  SettingsScreenFactory.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 23.05.2022.
//

import UIKit

/// Cобытия которые отправляем из Factory в Presenter
protocol SettingsScreenFactoryOutput: AnyObject {
  
  /// Были получены данные
  ///  - Parameter models: результат генерации для таблички
  func didReceive(models: [SettingsScreenTableViewType])
}

/// Cобытия которые отправляем от Presenter к Factory
protocol SettingsScreenFactoryInput {
  
  /// Создаем модельку для таблички
  ///  - Parameter model: Модель с данными
  func createListModelFrom(type: SettingsScreenType)
}

/// Фабрика
final class SettingsScreenFactory: SettingsScreenFactoryInput {
  
  // MARK: - Internal properties
  
  weak var output: SettingsScreenFactoryOutput?
  
  // MARK: - Internal func
  
  func createListModelFrom(type: SettingsScreenType) {
    let appearance = Appearance()
    var tableViewModels: [SettingsScreenTableViewType] = []
    switch type {
    case .teams(generatedTeamsCount: let generatedTeamsCount,
                allPlayersCount: let allPlayersCount,
                generatedPlayersCount: let generatedPlayersCount):
      tableViewModels.append(.titleAndDescription(title: appearance.generatedTeamsCountTitle,
                                                  description: generatedTeamsCount))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.allPlayersCount,
                                                  description: allPlayersCount))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.generatedPlayersCount,
                                                  description: generatedPlayersCount))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndImage(title: appearance.titleAndImageTitle,
                                            asideImage: nil))
      tableViewModels.append(.divider)
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case .number(withoutRepetition: let withoutRepetition,
                 itemsGenerated: let itemsGenerated,
                 lastItem: let lastItem):
      tableViewModels.append(.titleAndSwitcher(title: appearance.withoutRepetitionTitle,
                                               isEnabled: withoutRepetition))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndImage(title: appearance.numberOfGenerations,
                                              asideImage: nil))
        tableViewModels.append(.divider)
      }
      
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case .yesOrNo(itemsGenerated: let itemsGenerated,
                  lastItem: let lastItem):
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndImage(title: appearance.numberOfGenerations,
                                              asideImage: nil))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case .letter(withoutRepetition: let withoutRepetition,
                 itemsGenerated: let itemsGenerated,
                 lastItem: let lastItem):
      tableViewModels.append(.titleAndSwitcher(title: appearance.withoutRepetitionTitle,
                                               isEnabled: withoutRepetition))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndImage(title: appearance.numberOfGenerations,
                                              asideImage: nil))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case .coin(itemsGenerated: let itemsGenerated,
               lastItem: let lastItem):
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndImage(title: appearance.numberOfGenerations,
                                              asideImage: nil))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case .dateAndTime(itemsGenerated: let itemsGenerated,
                      lastItem: let lastItem):
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndImage(title: appearance.numberOfGenerations,
                                              asideImage: nil))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case .lottery(itemsGenerated: let itemsGenerated,
                  lastItem: let lastItem):
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndImage(title: appearance.numberOfGenerations,
                                              asideImage: nil))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case .password(itemsGenerated: let itemsGenerated, _):
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndImage(title: appearance.numberOfGenerations,
                                              asideImage: nil))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case .contact(itemsGenerated: let itemsGenerated, _):
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndImage(title: appearance.numberOfGenerations,
                                              asideImage: nil))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case .cube(itemsGenerated: let itemsGenerated,
               lastItem: let lastItem):
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndImage(title: appearance.numberOfGenerations,
                                              asideImage: nil))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case .list(let withoutRepetition,
               let generatedTextCount,
               let allTextCount,
               let lastItem):
      tableViewModels.append(.titleAndSwitcher(title: appearance.withoutRepetitionTitle,
                                               isEnabled: withoutRepetition))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: generatedTextCount))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.allTextCount,
                                                  description: allTextCount))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndImage(title: appearance.createListTitle,
                                            asideImage: nil,
                                            id: appearance.createListID))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(generatedTextCount), itemsGenerated > .zero {
        tableViewModels.append(.titleAndImage(title: appearance.numberOfGenerations,
                                              asideImage: nil))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case .films: break
    }
    output?.didReceive(models: tableViewModels)
  }
}

// MARK: - Appearance

private extension SettingsScreenFactory {
  struct Appearance {
    let withoutRepetitionTitle = NSLocalizedString("Без повторений",
                                                   comment: "")
    let countGeneratedTitle = NSLocalizedString("Cгенерировано",
                                                comment: "")
    let latestGeneration = NSLocalizedString("Последняя генерация",
                                             comment: "")
    let cleanButtonTitle = NSLocalizedString("Очистить",
                                             comment: "")
    
    let numberOfGenerations = NSLocalizedString("Список результатов",
                                                comment: "")
    let titleAndImageTitle = NSLocalizedString("Список игроков",
                                               comment: "")
    
    let createListTitle = NSLocalizedString("Создать список",
                                            comment: "")
    
    let generatedTeamsCountTitle = NSLocalizedString("Cгенерировано команд",
                                                     comment: "")
    let allPlayersCount = NSLocalizedString("Всего игроков",
                                            comment: "")
    let allTextCount = NSLocalizedString("Всего элементов",
                                            comment: "")
    let generatedPlayersCount = NSLocalizedString("Cгенерировано игроков",
                                                  comment: "")
    let createListID = "createListID"
  }
}
