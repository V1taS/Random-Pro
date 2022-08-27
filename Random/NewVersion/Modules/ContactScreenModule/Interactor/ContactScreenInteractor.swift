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
  func didReciveError()
  
  /// Были получены данные
  ///  - Parameter model: результат генерации
  func didRecive(model: ContactScreenModel)
  
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
  
  private let permissionService: PermissionService
  @ObjectCustomUserDefaultsWrapper<ContactScreenModel>(key: Appearance().keyUserDefaults)
  private var model: ContactScreenModel?
  
  /// - Parameter permissionService: Сервис запросов доступа
  init(permissionService: PermissionService) {
    self.permissionService = permissionService
  }
  
  // MARK: - Internal func
  
  func getContent() {
    if let model = self.model {
      self.output?.didRecive(model: model)
    } else {
      permissionService.requestContactStore { [weak self] granted, error in
        guard
          let self = self,
          error == nil
        else {
          self?.output?.didReciveError()
          return
        }
        var listContacts: [ContactScreenModel.Contact] = []
        
        if granted {
          let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
          let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
          do {
            let store = CNContactStore()
            try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
              listContacts.append(ContactScreenModel.Contact(
                firstName: contact.givenName,
                lastName: contact.familyName,
                telephone: contact.phoneNumbers.first?.value.stringValue ?? ""
              ))
            })
          } catch {
            self.output?.didReciveError()
          }
        }
        let newModel = ContactScreenModel(
          allContacts: listContacts,
          listResult: [],
          result: Appearance().resultLabel
        )
        self.model = newModel
        self.output?.didRecive(model: newModel)
      }
    }
  }
  
  func generateButtonAction() {
    guard
      let model = model,
      let contact = model.allContacts.shuffled().first
    else {
      return
    }
    
    var listResult = model.listResult
    let result = "\(contact.lastName) \(contact.firstName) \n\(contact.telephone)"
    listResult.append(result)
    let newModel = ContactScreenModel(
      allContacts: model.allContacts,
      listResult: listResult,
      result: result
    )
    self.model = newModel
    output?.didRecive(model: newModel)
  }
  
  func returnCurrentModel() -> ContactScreenModel {
    guard let model = model else {
      return ContactScreenModel(allContacts: [], listResult: [], result: Appearance().resultLabel)
    }
    return model
  }
  
  func cleanButtonAction() {
    self.model = nil
    getContent()
    output?.cleanButtonWasSelected()
  }
}

// MARK: - Appearance

private extension ContactScreenInteractor {
  struct Appearance {
    let resultLabel = "?"
    let keyUserDefaults = "contact_screen_user_defaults_key"
  }
}
