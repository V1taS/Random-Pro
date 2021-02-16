//
//  MonthDateAndTimeInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

protocol MonthDateAndTimeInteractor {
    func generateMonth(state: Binding<AppState.AppData>)
    func cleanMonth(state: Binding<AppState.AppData>)
}

extension DateAndTimeInteractorImpl {
    func generateMonth(state: Binding<AppState.AppData>) {
        switch state.dateAndTime.noRepetitionsMonth.wrappedValue {
        case true:
            noRepetitionsMonth(state: state)
        case false:
            repetitionsMonth(state: state)
        }
    }
    
    func cleanMonth(state: Binding<AppState.AppData>) {
        state.dateAndTime.listMonth.wrappedValue = [
            NSLocalizedString("Январь", comment: ""),
            NSLocalizedString("Февраль", comment: ""),
            NSLocalizedString("Март", comment: ""),
            NSLocalizedString("Апрель", comment: ""),
            NSLocalizedString("Май", comment: ""),
            NSLocalizedString("Июнь", comment: ""),
            NSLocalizedString("Июль", comment: ""),
            NSLocalizedString("Август", comment: ""),
            NSLocalizedString("Сентябрь", comment: ""),
            NSLocalizedString("Октябрь", comment: ""),
            NSLocalizedString("Ноябрь", comment: ""),
            NSLocalizedString("Декабрь", comment: "")
        ]
    }
}

// MARK - No Repetitions Day
extension DateAndTimeInteractorImpl {
    private func noRepetitionsMonth(state: Binding<AppState.AppData>) {
        shuffledistRandomMonth(state: state)
        takeMonthFromList(state: state)
    }
    
    private func shuffledistRandomMonth(state: Binding<AppState.AppData>) {
        state.dateAndTime.listMonth.wrappedValue.shuffle()
    }
    
    private func takeMonthFromList(state: Binding<AppState.AppData>) {
        if state.dateAndTime.listMonth.wrappedValue.count != 0 {
            state.dateAndTime.result.wrappedValue = "\(state.dateAndTime.listMonth.wrappedValue.first!)"
            state.dateAndTime.listResult.wrappedValue.insert("\(state.dateAndTime.listMonth.wrappedValue.first!)", at: 0)
            state.dateAndTime.listMonth.wrappedValue.removeFirst()
        }
    }
}

// MARK - Repetitions Day
extension DateAndTimeInteractorImpl {
    private func repetitionsMonth(state: Binding<AppState.AppData>) {
        if state.dateAndTime.listResult.wrappedValue.count < state.dateAndTime.listMonth.wrappedValue.count {
            let randomElement = state.dateAndTime.listMonth.wrappedValue.randomElement()
            state.dateAndTime.listResult.wrappedValue.insert("\(randomElement ?? "")", at: 0)
            state.dateAndTime.result.wrappedValue = "\(randomElement ?? "")"
        }
    }
}
