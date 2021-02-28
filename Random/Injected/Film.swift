//
//  Film.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct Film: Equatable {
        
        var dataTemp: FramesFilms = FramesFilms(frames: [])
        
        var listResults: [String] = []
        var resultFullName = ""
        var resultPhone = ""
        
        var showSettings = false
    }
}
