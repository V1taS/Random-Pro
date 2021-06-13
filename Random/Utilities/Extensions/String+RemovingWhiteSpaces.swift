//
//  String+RemovingWhiteSpaces.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension String {
    func removingWhiteSpaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
