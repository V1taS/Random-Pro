//
//  PasswordInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 18.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol PasswordInteractor {
    func generatePassword(state: Binding<AppState.AppData>) -> String
}

struct PasswordInteractorImpl: PasswordInteractor {
    func generatePassword(state: Binding<AppState.AppData>) -> String {
        
        // MARK: - BOOL
        let capitalLetters = state.password.capitalLetters.wrappedValue
        let numbers = state.password.numbers.wrappedValue
        let lowerCase = state.password.lowerCase.wrappedValue
        let symbols = state.password.symbols.wrappedValue
        
        // MARK: - INT
        let passwordLength = Int(state.password.passwordLength.wrappedValue) ?? .zero
        
        return generateRandomPass(capitalLetters: capitalLetters,
                           numbers: numbers,
                           lowerCase: lowerCase,
                           symbols: symbols,
                           passwordLength: passwordLength,
                           state: state)
    }
}

private extension PasswordInteractorImpl {
    func generateRandomPass(capitalLetters: Bool, numbers: Bool, lowerCase: Bool, symbols: Bool, passwordLength: Int, state: Binding<AppState.AppData>) -> String {
        guard passwordLength >= 4 else { return "" }
        
        var resultCharacters: [Character] = []
        
        var capitalLettersNew = capitalLetters
        var numbersNew = numbers
        var lowerCaseNew = lowerCase
        var symbolsNew = symbols
        
        let capitalLettersRaw = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let numbersRaw = "0123456789"
        let lowerCaseRaw = "abcdefghijklmnopqrstuvwxyz"
        let symbolsRaw = "!@#$%^&*()"
        let reservRaw = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789abcdefghijklmnopqrstuvwxyz!@#$%^&*()"
        
        for _ in 1...passwordLength {
            
            if capitalLettersNew == false &&
                numbersNew == false &&
                lowerCaseNew == false &&
                symbolsNew == false {
                
                capitalLettersNew = capitalLetters
                numbersNew = numbers
                lowerCaseNew = lowerCase
                symbolsNew = symbols
            }
            
            if capitalLettersNew {
                resultCharacters.append(capitalLettersRaw.randomElement() ?? "T")
                capitalLettersNew = false
                continue
            }
            
            if numbersNew {
                resultCharacters.append(numbersRaw.randomElement() ?? "0")
                numbersNew = false
                continue
            }
            
            if lowerCaseNew {
                resultCharacters.append(lowerCaseRaw.randomElement() ?? "t")
                lowerCaseNew = false
                continue
            }
            
            if symbolsNew {
                resultCharacters.append(symbolsRaw.randomElement() ?? "!")
                symbolsNew = false
                continue
            }
            resultCharacters.append(reservRaw.randomElement() ?? "#")
        }
        return String(resultCharacters.shuffled())
    }
}
