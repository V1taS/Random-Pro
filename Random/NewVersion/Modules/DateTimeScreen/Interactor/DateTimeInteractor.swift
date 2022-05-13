//
//  DateTimeInteractor.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 13.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol DateTimeInteractorOutput: AnyObject {
    
    /// Были получены данные
    ///  - Parameter result: результат генерации
    func didRecive(result: String?)
    
    /// Возвращает список результатов
    ///  - Parameter listResult: массив результатов
    func didRecive(listResult: [String])
}

protocol DateTimeInteractorInput: AnyObject {
    
    /// Получить данные
    func getContent()
    
    /// Создать новые данные date
    func generateContentDate()
    
    /// Создать новые данные time
    func generateContentTime()
    
    /// Создать новые данные day
    func generateContentDay()
    
    /// Создать новые данные month
    func generateContentMonth()
}

final class DateTimeInteractor: DateTimeInteractorInput {
    
    // MARK: - Internal property
    
    weak var output: DateTimeInteractorOutput?
    
    // MARK: - Private property
    
    private var result = Appearance().result
    private var listResult: [String] = []
    
    // MARK: - Internal func
    
    func getContent() {
        output?.didRecive(listResult: listResult)
        output?.didRecive(result: result)
    }
    
    func generateContentDate() {
        listResult.append("\(Appearance().randomDate)")
        result = ("\(Appearance().randomDate)")

        output?.didRecive(result: result)
        output?.didRecive(listResult: listResult)
    }
    
    func generateContentTime() {
        let appearance = Appearance()
        
        listResult.append("\(appearance.randomTimeHours) : \(appearance.randomTimeMinets)")
        result = ("\(appearance.randomTimeHours) : \(appearance.randomTimeMinets)")
        
        output?.didRecive(result: result)
        output?.didRecive(listResult: listResult)
    }
    
    func generateContentDay() {
        let randomElementDay = Appearance().listDay.shuffled().first ?? ""
        listResult.append(randomElementDay)
        result = randomElementDay
        
        output?.didRecive(result: result)
        output?.didRecive(listResult: listResult)
    }
    
    func generateContentMonth() {
        let randomElementMonth = Appearance().listMonth.shuffled().first ?? ""
        listResult.append(randomElementMonth)
        result = randomElementMonth
        
        output?.didRecive(result: result)
        output?.didRecive(listResult: listResult)
    }
}

// MARK: - Private Appearance

private extension DateTimeInteractor {
    struct Appearance {
        let result = "?"
        let randomTimeHours = Int.random(in: 1...12)
        let randomTimeMinets = Int.random(in: 1...59)
        let randomDate = Int.random(in: 1...30)
        let listDay = [
        "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"
        ]
        let listMonth = [
            "Январь", "Февраль", "Март", "Апрель", "Май", "Июнь", "Июль", "Август",
            "Сентябрь", "Октябрь", "Ноябрь", "Декабрь"
        ]
    }
}
