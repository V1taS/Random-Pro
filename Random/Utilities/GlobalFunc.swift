//
//  GlobalFunc.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 01.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

func getLinkFromStringURL(strURL: String?) {
    guard let url = strURL?.dropFirst(2) else { return }
    let httpsUrl = "https://\(String(describing: url))"
    if let url = URL(string: httpsUrl) {
        DispatchQueue.main.async {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
}
