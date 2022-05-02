//
//  EncryptPassword.swift
//  Create Password
//
//  Created by Vitalii Sosin on 19.12.2021.
//

import UIKit

final class EncryptPassword {
    
    static func encrypt(text: String) -> String {
        let textLowercased = text.lowercased().components(separatedBy:.whitespacesAndNewlines).filter { $0.count > .zero }.joined(separator: " ")
        var encryptText = ""
        
        for character in textLowercased {
            encryptText += define(character)
        }
        return encryptText
    }
    
    private static func define(_ character: Character) -> String {
        var pass = ""
        
        switch character {
            
            // MARK: - Кириллица
        case "а":
            pass = "cZ9="
        case "б":
            pass = "5&lR"
        case "в":
            pass = ".1Rk"
        case "г":
            pass = "&x1K"
        case "д":
            pass = "Mz*7"
        case "е", "ё":
            pass = "Q;5n"
        case "ж":
            pass = "mQ9["
        case "з":
            pass = "5Qm."
        case "и":
            pass = "(uE8"
        case "й":
            pass = "9Op{"
        case "к":
            pass = "4Yp)"
        case "л":
            pass = "^P1z"
        case "м":
            pass = "4aC%"
        case "н":
            pass = "^h1D"
        case "о":
            pass = "z;N8"
        case "п":
            pass = "5^qJ"
        case "р":
            pass = "~7Mz"
        case "с":
            pass = "0f`N"
        case "т":
            pass = "7+Xy"
        case "у":
            pass = ">0Jh"
        case "ф":
            pass = "E{8h"
        case "х":
            pass = "I4m{"
        case "ц":
            pass = "|w4C"
        case "ч":
            pass = "8d.B"
        case "ш":
            pass = "1Uq)"
        case "щ":
            pass = "@7Gj"
        case "ъ":
            pass = "uR*8"
        case "ы":
            pass = "l'O4"
        case "ь":
            pass = "R4?n"
        case "э":
            pass = "5N>o"
        case "ю":
            pass = "b:L2"
        case "я":
            pass = "W|1q"
            
            // MARK: - Латиница
        case "a":
            pass = "Vj4;"
        case "b":
            pass = "4Ik{"
        case "c":
            pass = "9b]X"
        case "d":
            pass = "{C0p"
        case "e":
            pass = "+4Ca"
        case "f":
            pass = "T2r*"
        case "g":
            pass = "m%T5"
        case "h":
            pass = "!Ks7"
        case "i":
            pass = "}Eo1"
        case "j":
            pass = "}2gE"
        case "k":
            pass = "Bj8^"
        case "l":
            pass = "5o!E"
        case "m":
            pass = "$1Ho"
        case "n":
            pass = "0g}H"
        case "o":
            pass = ".W8r"
        case "p":
            pass = ">kV5"
        case "q":
            pass = "F`l5"
        case "r":
            pass = "b5T:"
        case "s":
            pass = "7d{A"
        case "t":
            pass = "y2E#"
        case "u":
            pass = "a!7E"
        case "v":
            pass = "Yz&0"
        case "w":
            pass = "$tW8"
        case "x":
            pass = "0f]Z"
        case "y":
            pass = "|Z0x"
        case "z":
            pass = "%qE3"
            
            // MARK: - Цифры
        case "0":
            pass = "l4$J"
        case "1":
            pass = "4]xX"
        case "2":
            pass = "1Fw#"
        case "3":
            pass = "8gP{"
        case "4":
            pass = "y!1I"
        case "5":
            pass = "Go8!"
        case "6":
            pass = "G9l="
        case "7":
            pass = "Fj4("
        case "8":
            pass = "l2%S"
        case "9":
            pass = "(g5L"
            
            // MARK: - Цифры
        case ".":
            pass = "Ol5)"
        case ",":
            pass = "aA8+"
        case "?":
            pass = "pN6#"
        case "'":
            pass = "B.3x"
        case "!":
            pass = "x]4X"
        case "/":
            pass = "+B6u"
        case "(":
            pass = "W2:w"
        case ")":
            pass = "&Oe4"
        case "&":
            pass = "Eo5="
        case ":":
            pass = "3i(F"
        case ";":
            pass = "7rO@"
        case "=":
            pass = "?r2J"
        case "+":
            pass = "[0fS"
        case "-":
            pass = "|2Ga"
        case "_":
            pass = "Q:6y"
        case "\"":
            pass = "'c9P"
        case "$":
            pass = "6qJ$"
        case "@":
            pass = "Rh8^"
        case "¿":
            pass = "5+mY"
        case "¡":
            pass = "E;k8"
            
            // MARK: - default
        default:
            pass = ""
        }
        return pass
    }
}
