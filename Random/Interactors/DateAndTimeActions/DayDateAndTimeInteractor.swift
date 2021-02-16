//
//  DayDateAndTimeInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

protocol DayDateAndTimeInteractor {
    func generateDay(state: Binding<AppState.AppData>)
    func cleanDay(state: Binding<AppState.AppData>)
}

extension DateAndTimeInteractorImpl {
    
    func generateDay(state: Binding<AppState.AppData>) {
        
        switch state.dateAndTime.noRepetitionsDay.wrappedValue {
        case true:
            noRepetitionsDay(state: state)
        case false: 
            repetitionsDay(state: state)
        }
    }
    
    func cleanDay(state: Binding<AppState.AppData>) {
        state.dateAndTime.listDay.wrappedValue = [NSLocalizedString("Понедельник", comment: ""), NSLocalizedString("Вторник", comment: ""), NSLocalizedString("Среда", comment: ""), NSLocalizedString("Четверг", comment: ""), NSLocalizedString("Пятница", comment: ""), NSLocalizedString("Суббота", comment: ""), NSLocalizedString("Воскресенье", comment: "")]
    }
}

// MARK - No Repetitions Day
extension DateAndTimeInteractorImpl {
    private func noRepetitionsDay(state: Binding<AppState.AppData>) {
        shuffledistRandomDay(state: state)
        takeDayFromList(state: state)
    }
    
    private func shuffledistRandomDay(state: Binding<AppState.AppData>) {
        state.dateAndTime.listDay.wrappedValue.shuffle()
    }
    
    private func takeDayFromList(state: Binding<AppState.AppData>) {
        if state.dateAndTime.listDay.wrappedValue.count != 0 {
            state.dateAndTime.result.wrappedValue = "\(state.dateAndTime.listDay.wrappedValue.first!)"
            state.dateAndTime.listResult.wrappedValue.insert("\(state.dateAndTime.listDay.wrappedValue.first!)", at: 0)
            state.dateAndTime.listDay.wrappedValue.removeFirst()
        }
    }
}

// MARK - Repetitions Day
extension DateAndTimeInteractorImpl {
    private func repetitionsDay(state: Binding<AppState.AppData>) {
        if state.dateAndTime.listResult.wrappedValue.count < state.dateAndTime.listDay.wrappedValue.count {
            let randomElement = state.dateAndTime.listDay.wrappedValue.randomElement()
            state.dateAndTime.listResult.wrappedValue.insert("\(randomElement ?? "")", at: 0)
            state.dateAndTime.result.wrappedValue = "\(randomElement ?? "")"
        }
    }
}


