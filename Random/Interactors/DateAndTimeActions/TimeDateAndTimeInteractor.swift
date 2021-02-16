//
//  TimeDateAndTimeInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

protocol TimeDateAndTimeInteractor {
    func generateTime(state: Binding<AppState.AppData>)
}

extension DateAndTimeInteractorImpl {
    func generateTime(state: Binding<AppState.AppData>) {
        if NSLocalizedString("домен", comment: "") == "ru" {
            let minutes = generateRUMinutes()
            let hours = generateRUHours()
            let result = "\(hours):\(minutes)"
            state.dateAndTime.result.wrappedValue = result
            state.dateAndTime.listResult.wrappedValue.insert(result, at: 0)
        } else if NSLocalizedString("домен", comment: "") == "us" {
            let hours = generateUSHours()
            let minutes = generateUSMinutes()
            let halfDay = ["AM", "PM"].randomElement()
            let result = "\(hours):\(minutes) \(halfDay ?? "")"
            state.dateAndTime.result.wrappedValue = result
            state.dateAndTime.listResult.wrappedValue.insert(result, at: 0)
        }
    }
}

extension DateAndTimeInteractorImpl {
    func generateUSHours() -> String {
        let hours = Int.random(in: 0...12)
        if hours < 10 {
            return "0\(hours)"
        } else {
            return "\(hours)"
        }
    }
    
    func generateUSMinutes() -> String {
        let minutes = Int.random(in: 0...59)
        if minutes < 10 {
            return "0\(minutes)"
        } else {
            return "\(minutes)"
        }
    }
}

extension DateAndTimeInteractorImpl {
    func generateRUHours() -> String {
        let hours = Int.random(in: 0...23)
        if hours < 10 {
            return "0\(hours)"
        } else {
            return "\(hours)"
        }
    }
    
    func generateRUMinutes() -> String {
        let minutes = Int.random(in: 0...59)
        if minutes < 10 {
            return "0\(minutes)"
        } else {
            return "\(minutes)"
        }
    }
}
