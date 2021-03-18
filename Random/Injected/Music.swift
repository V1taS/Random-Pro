//
//  Music.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct Music: Equatable, Decodable {
        
        var listMusic: [MusicITunesDatum] = []
        var listMusicHistory: [MusicITunesDatum] = []
        var resultMusic: MusicITunesDatum = MusicITunesDatum(attributes: nil, href: nil, id: nil)
        
//        var musicPlayList: [String] = []
        
        var showSettings = false
        var isPlaying = false
        var showActivityIndicator = false
        var playButtonIsDisabled = true
    }
}
