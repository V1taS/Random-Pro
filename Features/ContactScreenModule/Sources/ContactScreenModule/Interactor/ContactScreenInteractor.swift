//
//  ContactScreenInteractor.swift
//  Random Pro
//
//  Created by Tatyana Sosina on 24.08.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit
import Contacts

/// События которые отправляем из Interactor в Presenter
protocol ContactScreenInteractorOutput: AnyObject {
  
  /// Была получена ошибка
  func didReceiveError()
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didReceive(model: ContactScreenModel)
  
  /// Кнопка очистить была нажата
  func cleanButtonWasSelected()
}

/// События которые отправляем от Presenter ко Interactor
protocol ContactScreenInteractorInput {
  
  /// Получить данные
  func getContent()
  
  /// Кнопка нажата пользователем
  func generateButtonAction()
  
  /// Запросить текущую модель
  func returnCurrentModel() -> ContactScreenModel
  
  /// Событие, кнопка `Очистить` была нажата
  func cleanButtonAction()
}

final class ContactScreenInteractor: ContactScreenInteractorInput {
  
  // MARK: - Internal property
  
  weak var output: ContactScreenInteractorOutput?
  
  // MARK: - Private property
  
  private let permissionService: PermissionServiceProtocol
  private var storageService: StorageServiceProtocol
  
  /// - Parameters:
  ///  - permissionService: Сервис запросов доступа
  ///  - storageService: Сервис сохранения данных
  init(permissionService: PermissionServiceProtocol,
       storageService: StorageServiceProtocol) {
    self.permissionService = permissionService
    self.storageService = storageService
  }
  
  // MARK: - Internal func
  
  func getContent() {
    if let model = storageService.contactScreenModel?.toCodable() {
      self.output?.didReceive(model: model)
    } else {
      permissionService.requestContactStore { [weak self] granted, error in
        guard
          let self = self,
          error == nil
        else {
          self?.output?.didReceiveError()
          return
        }
        var listContacts: [ContactScreenModel.Contact] = []
        
        if granted {
          let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
          let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
          do {
            let store = CNContactStore()
            try store.enumerateContacts(with: request, usingBlock: { (contact, _) in
              listContacts.append(ContactScreenModel.Contact(
                firstName: contact.givenName,
                lastName: contact.familyName,
                telephone: contact.phoneNumbers.first?.value.stringValue ?? ""
              ))
            })
          } catch {
            self.output?.didReceiveError()
          }
        }
        let newModel = ContactScreenModel(
          allContacts: listContacts,
          listResult: [],
          result: Appearance().resultLabel
        )
        self.storageService.contactScreenModel = newModel
        self.output?.didReceive(model: newModel)
      }
    }
  }
  
  func generateButtonAction() {
    guard
      let model = storageService.contactScreenModel,
      let contact = model.allContacts.shuffled().first,
      let allContacts = model.allContacts as? [ContactScreenModel.Contact] else {
      return
    }
    
    var listResult = model.listResult
    let result = "\(contact.lastName) \(contact.firstName) \n\(contact.telephone)"
    listResult.append(result)
    let newModel = ContactScreenModel(
      allContacts: allContacts,
      listResult: listResult,
      result: result
    )
    self.storageService.contactScreenModel = newModel
    output?.didReceive(model: newModel)
  }
  
  func returnCurrentModel() -> ContactScreenModel {
    guard let model = storageService.contactScreenModel?.toCodable() else {
      return ContactScreenModel(allContacts: [], listResult: [], result: Appearance().resultLabel)
    }
    return model
  }
  
  func cleanButtonAction() {
    self.storageService.contactScreenModel = nil
    getContent()
    output?.cleanButtonWasSelected()
  }
}

// MARK: - Appearance

private extension ContactScreenInteractor {
  struct Appearance {
    let resultLabel = "?"
  }
}
