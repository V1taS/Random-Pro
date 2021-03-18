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
    func saveFilmsToUserDefaults(state: Binding<AppState.AppData>)
}

struct MusicInteractorImpl: MusicInteractor {
    
    func getMusicFile(state: Binding<AppState.AppData>) {
        
        if state.music.listMusic.wrappedValue.count == 0 || state.music.listMusic.wrappedValue.count == 1 {
            SKCloudServiceController.requestAuthorization { (status) in
                if status == .authorized {
                    state.music.showActivityIndicator.wrappedValue = true
                    
                    var musics: [MusicITunesDatum] = []
                    
                    DispatchQueue.global(qos: .userInteractive).async {
                        AppleMusicAPI.share.getChartsAppleMusic(limit: 50, offset: state.music.countLoopDowload.wrappedValue) { music in
                            guard let music = music.results?.songs?.first?.data else { return }
                            
                            for item in music {
                                if item.attributes != nil {
                                    musics.append(item)
                                }
                            }
                            state.music.listMusic.wrappedValue = musics.shuffled()
                        }
                        state.music.countLoopDowload.wrappedValue += 50
                        state.music.showActivityIndicator.wrappedValue = false
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
        state.music.resultMusic.wrappedValue = music
        state.music.listMusicHistory.wrappedValue.append(music)
        
        state.music.listMusic.wrappedValue.removeFirst()
    }
    
    func cleanMusic(state: Binding<AppState.AppData>) {
        state.music.listMusic.wrappedValue = []
        state.music.listMusicHistory.wrappedValue = []
        state.music.countLoopDowload.wrappedValue = 0
        state.music.resultMusic.wrappedValue = MusicITunesDatum(attributes: nil, href: nil, id: nil)
    }
    
    func saveFilmsToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.global(qos: .background).async {
            saveListMusic(state: state)
            saveListMusicHistory(state: state)
            saveResultMusic(state: state)
            savePlayButtonIsDisabled(state: state)
            saveCountLoopDowload(state: state)
        }
    }
}

extension MusicInteractorImpl {
    private func encoderArrMusicsITunesDatum(music: [MusicITunesDatum], forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(music) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}

extension MusicInteractorImpl {
    private func encoderMusicITunesDatum(music: MusicITunesDatum, forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(music) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}

// MARK - Music Save
extension MusicInteractorImpl {
    private func saveListMusic(state: Binding<AppState.AppData>) {
        encoderArrMusicsITunesDatum(music: state.music.listMusic.wrappedValue,
                                    forKey: "listMusic")
    }
    
    private func saveListMusicHistory(state: Binding<AppState.AppData>) {
        encoderArrMusicsITunesDatum(music: state.music.listMusicHistory.wrappedValue,
                                    forKey: "listMusicHistory")
    }
    
    private func saveResultMusic(state: Binding<AppState.AppData>) {
        encoderMusicITunesDatum(music: state.music.resultMusic.wrappedValue,
                                    forKey: "resultMusic")
    }
    
    private func savePlayButtonIsDisabled(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.music
                                    .playButtonIsDisabled.wrappedValue,
                                  forKey: "MusicPlayButtonIsDisabled")
    }
    
    private func saveCountLoopDowload(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.music
                                    .countLoopDowload.wrappedValue,
                                  forKey: "MusicCountLoopDowload")
    }
}
