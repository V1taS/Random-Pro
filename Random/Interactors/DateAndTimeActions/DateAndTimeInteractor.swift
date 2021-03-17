//
//  DateAndTimeInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol DateAndTimeInteractor: DayDateAndTimeInteractor, MonthDateAndTimeInteractor, TimeDateAndTimeInteractor {
    func saveDayToUserDefaults(state: Binding<AppState.AppData>)
    func generateDate(state: Binding<AppState.AppData>)
    func cleanDate(state: Binding<AppState.AppData>)
}

struct DateAndTimeInteractorImpl: DateAndTimeInteractor {
    
    func saveDayToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.global(qos: .background).async {
            saveResult(state: state)
            savelistResult(state: state)
            savelistDay(state: state)
            savelistDate(state: state)
            savelistMonth(state: state)
            
            saveNoRepetitionsDay(state: state)
            saveNoRepetitionsDate(state: state)
            saveNoRepetitionsMonth(state: state)
        }
    }
    
    func generateDate(state: Binding<AppState.AppData>) {
        switch state.dateAndTime.noRepetitionsDate.wrappedValue {
        case true:
            noRepetitionsDate(state: state)
        case false:
            repetitionsDate(state: state)
        }
    }
    
    func cleanDate(state: Binding<AppState.AppData>) {
        state.dateAndTime.result.wrappedValue = "?"
        state.dateAndTime.listResult.wrappedValue = []
        state.dateAndTime.listDate.wrappedValue = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    }
    
}

// MARK - No Repetitions Day
extension DateAndTimeInteractorImpl {
    private func noRepetitionsDate(state: Binding<AppState.AppData>) {
        shuffledListRandomDate(state: state)
        takeDateFromList(state: state)
    }
    
    private func shuffledListRandomDate(state: Binding<AppState.AppData>) {
        state.dateAndTime.listDate.wrappedValue.shuffle()
    }
    
    private func takeDateFromList(state: Binding<AppState.AppData>) {
        if state.dateAndTime.listDate.wrappedValue.count != 0 {
            state.dateAndTime.result.wrappedValue = "\(state.dateAndTime.listDate.wrappedValue.first!)"
            state.dateAndTime.listResult.wrappedValue.insert("\(state.dateAndTime.listDate.wrappedValue.first!)", at: 0)
            state.dateAndTime.listDate.wrappedValue.removeFirst()
        }
    }
}

// MARK - Repetitions Day
extension DateAndTimeInteractorImpl {
    private func repetitionsDate(state: Binding<AppState.AppData>) {
        if state.dateAndTime.listResult.wrappedValue.count < state.dateAndTime.listDate.wrappedValue.count {
            let randomElement = state.dateAndTime.listDate.wrappedValue.randomElement()
            state.dateAndTime.listResult.wrappedValue.insert("\(randomElement ?? "")", at: 0)
            state.dateAndTime.result.wrappedValue = "\(randomElement ?? "")"
        }
    }
}


extension DateAndTimeInteractorImpl {
    
    private func savelistResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.dateAndTime
                                    .listResult.wrappedValue,
                                  forKey: "DateAndTimelistResult")
    }
    
    private func savelistDate(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.dateAndTime
                                    .listDate.wrappedValue,
                                  forKey: "DateAndTimelistDate")
    }
    
    private func savelistDay(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.dateAndTime
                                    .listDay.wrappedValue,
                                  forKey: "DateAndTimelistDay")
    }
    
    private func savelistMonth(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.dateAndTime
                                    .listMonth.wrappedValue,
                                  forKey: "DateAndTimelistMonth")
    }
    
    private func saveNoRepetitionsDay(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.characters
                                    .noRepetitions.wrappedValue,
                                  forKey: "DateAndTimeNoRepetitionsDay")
    }
    
    private func saveNoRepetitionsDate(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.characters
                                    .noRepetitions.wrappedValue,
                                  forKey: "DateAndTimeNoRepetitionsDate")
    }
    
    private func saveNoRepetitionsMonth(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.characters
                                    .noRepetitions.wrappedValue,
                                  forKey: "DateAndTimeNoRepetitionsMonth")
    }
    
    private func saveResult(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.dateAndTime
                                    .result.wrappedValue,
                                  forKey: "DateAndTimResult")
    }
}
