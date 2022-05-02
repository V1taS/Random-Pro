//
//  String+OffsetBy.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 18.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

extension String {
    subscript(idx: Int) -> String {
        String(self[index(startIndex, offsetBy: idx)])
    }
}

extension String {
    public var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

extension String {
    public var isSymbols: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.symbols.inverted) == nil
    }
}

extension String {
    public var isCapitalizedLetters: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.capitalizedLetters.inverted) == nil
    }
}

extension String {
    public var isLowercaseLetters: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.lowercaseLetters.inverted) == nil
    }
}

extension String {
    public var isLetters: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.letters.inverted) == nil
    }
}
