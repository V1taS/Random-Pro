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
    case let .teams(generatedTeamsCount, allPlayersCount, generatedPlayersCount):
      tableViewModels.append(.titleAndDescription(title: appearance.generatedTeamsCountTitle,
                                                  description: generatedTeamsCount))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.allPlayersCount,
                                                  description: allPlayersCount))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.generatedPlayersCount,
                                                  description: generatedPlayersCount))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndChevron(title: appearance.titleAndImageTitle))
      
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndChevron(title: appearance.chooseCardStyle,
                                              id: .playerCardSelection))
      
      tableViewModels.append(.divider)
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case let .number(withoutRepetition, itemsGenerated, lastItem):
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
        tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
        tableViewModels.append(.divider)
      }
      
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case let .yesOrNo(itemsGenerated, lastItem):
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case let .letter(withoutRepetition, itemsGenerated, lastItem):
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
        tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case let .coin(isShowlistGenerated, itemsGenerated, lastItem):
      tableViewModels.append(.titleAndSwitcher(title: appearance.numberOfGenerations,
                                               isEnabled: isShowlistGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case let .dateAndTime(itemsGenerated, lastItem):
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case let .lottery(itemsGenerated, lastItem):
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case let .password(itemsGenerated, _):
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case let .contact(itemsGenerated, _):
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case let .cube(isShowlistGenerated, itemsGenerated, lastItem):
      tableViewModels.append(.titleAndSwitcher(title: appearance.numberOfGenerations,
                                               isEnabled: isShowlistGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(itemsGenerated), itemsGenerated > 0 {
        tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case let .list(withoutRepetition, generatedTextCount, allTextCount, lastItem):
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
      tableViewModels.append(.titleAndChevron(title: appearance.createListTitle, id: .createList))
      tableViewModels.append(.divider)
      if let itemsGenerated = Int(generatedTextCount), itemsGenerated > .zero {
        tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
        tableViewModels.append(.divider)
      }
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case .films: break
    case let .nickname(itemsGenerated, lastItem):
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
      tableViewModels.append(.divider)
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case let .names(itemsGenerated, lastItem, currentCountry, listOfItems, valueChanged):
      let index = listOfItems.firstIndex(of: currentCountry) ?? .zero
      tableViewModels.append(.labelWithSegmentedControl(title: Appearance().selectCountryTitle,
                                                        listOfItems: listOfItems,
                                                        startSelectedSegmentIndex: index,
                                                        valueChanged: valueChanged))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.latestGeneration,
                                                  description: lastItem))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
      tableViewModels.append(.divider)
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case let .congratulations(itemsGenerated, _, currentCountry, listOfItems, valueChanged):
      let index = listOfItems.firstIndex(of: currentCountry) ?? .zero
      tableViewModels.append(.labelWithSegmentedControl(title: Appearance().selectCountryTitle,
                                                        listOfItems: listOfItems,
                                                        startSelectedSegmentIndex: index,
                                                        valueChanged: valueChanged))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
      tableViewModels.append(.divider)
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    case let .goodDeedsS(itemsGenerated, _, currentCountry, listOfItems, valueChanged):
      let index = listOfItems.firstIndex(of: currentCountry) ?? .zero
      tableViewModels.append(.labelWithSegmentedControl(title: Appearance().selectCountryTitle,
                                                        listOfItems: listOfItems,
                                                        startSelectedSegmentIndex: index,
                                                        valueChanged: valueChanged))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndDescription(title: appearance.countGeneratedTitle,
                                                  description: itemsGenerated))
      tableViewModels.append(.divider)
      tableViewModels.append(.titleAndChevron(title: appearance.numberOfGenerations))
      tableViewModels.append(.divider)
      tableViewModels.append(.cleanButtonModel(title: appearance.cleanButtonTitle))
    }
    output?.didReceive(models: tableViewModels)
  }
}

// MARK: - Appearance

private extension SettingsScreenFactory {
  struct Appearance {
    let withoutRepetitionTitle = RandomStrings.Localizable.noRepetitions
    let countGeneratedTitle = RandomStrings.Localizable.generated
    let latestGeneration = RandomStrings.Localizable.lastGeneration
    let cleanButtonTitle = RandomStrings.Localizable.clean
    let numberOfGenerations = RandomStrings.Localizable.listOfResults
    let titleAndImageTitle = RandomStrings.Localizable.listOfPlayers
    let createListTitle = RandomStrings.Localizable.createList
    let generatedTeamsCountTitle = RandomStrings.Localizable.generatedTeams
    let allPlayersCount = RandomStrings.Localizable.totalPlayers
    let allTextCount = RandomStrings.Localizable.totalElements
    let generatedPlayersCount = RandomStrings.Localizable.generatedPlayers
    let chooseCardStyle = RandomStrings.Localizable.selectCardStyle
    let selectCountryTitle = RandomStrings.Localizable.selectCountry
  }
}
