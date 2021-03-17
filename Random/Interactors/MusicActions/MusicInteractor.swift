//
//  MusicInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

import Combine
import SwiftUI
import StoreKit

protocol MusicInteractor {
    func getMusicFile(state: Binding<AppState.AppData>)
    func getCurrentMusicFile(state: Binding<AppState.AppData>)
    func cleanMusic(state: Binding<AppState.AppData>)
}

struct MusicInteractorImpl: MusicInteractor {
    
    func getMusicFile(state: Binding<AppState.AppData>) {
        
        if state.music.listMusic.wrappedValue.count == 0 || state.music.listMusic.wrappedValue.count == 1 {
            SKCloudServiceController.requestAuthorization { (status) in
                if status == .authorized {
                    let offset = Int.random(in: 1...50)
                    DispatchQueue.global(qos: .userInitiated).async {
                        AppleMusicAPI.share.getChartsAppleMusic(limit: 50, offset: offset) { music in
                            state.music.listMusic.wrappedValue = music.results?.songs?.first?.data ?? []
                        }
                    }
                } else {
                    UIApplication.shared.windows.first?.rootViewController?.showAlert(with: NSLocalizedString("Внимание", comment: ""),
                                                                                      and: "Необходимо разрешить доступ к Apple Music в настройках",
                                                                    style: .alert)
                }
            }
        }
    }
    
    func getCurrentMusicFile(state: Binding<AppState.AppData>) {
        guard let music = state.music.listMusic.wrappedValue.first else { return }
        
        if state.music.listMusic.wrappedValue.count == 1 {
            state.music.musicPlayList.wrappedValue = []
        }
        
        if state.music.musicPlayList.wrappedValue.count == 0 || state.music.musicPlayList.wrappedValue.count == 1 {
            for music in state.music.listMusic.wrappedValue {
                state.music.musicPlayList.wrappedValue.append(music.id ?? "")
            }
        }
        
        state.music.resultMusic.wrappedValue = music
        state.music.listMusicHistory.wrappedValue.append(music)
        state.music.listMusic.wrappedValue.removeFirst()
    }
    
    func cleanMusic(state: Binding<AppState.AppData>) {
        state.music.listMusic.wrappedValue = []
        state.music.listMusicHistory.wrappedValue = []
        state.music.resultMusic.wrappedValue = MusicITunesDatum(attributes: nil, href: nil, id: nil)
    }
}
