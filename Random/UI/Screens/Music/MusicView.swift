//
//  MusicView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import StoreKit
import MediaPlayer
import SDWebImageSwiftUI

struct MusicView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    @State private var isPressedButton = false
    @State private var isPressedTouch = false
    
    @State var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                WebImage(url: URL(string: appBinding.music.resultMusic.wrappedValue.attributes?.artwork?.url ?? ""))
                    .resizable()
                    .renderingMode(.original)
                    .onSuccess { image, data, cacheType in }
                    .placeholder(Image("musicPH"))
                    .indicator(.activity)
                    .frame(width: 300, height: 300)
                    .transition(.fade(duration: 0.5))
                    .scaledToFill()
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(6)
                    .overlay(RoundedRectangle(cornerRadius: 6)
                                .stroke(Color(.systemGray4)))
                    .padding(.top, 24)
                
                Text("\(appBinding.music.resultMusic.wrappedValue.attributes?.name ?? "Название песни")")
                    .font(.robotoMedium18())
                    .foregroundColor(.black)
                    .lineLimit(2)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                
                Text("\(appBinding.music.resultMusic.wrappedValue.attributes?.artistName ?? "Имя артиста")")
                    .font(.robotoRegular18())
                    .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
                    .lineLimit(2)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                
                Text("\(appBinding.music.resultMusic.wrappedValue.attributes?.releaseDate ?? "2021")")
                    .font(.robotoBold13())
                    .foregroundColor(.gray)
                    .lineLimit(2)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 4)
    
                playAndPauseButton
                    .padding(.top, 24)
                Spacer()
                generateButton
            }
        }
        .dismissingKeyboard()
        
        
        .navigationBarTitle(Text(NSLocalizedString("Музыка", comment: "")), displayMode: .inline)
        .navigationBarItems(trailing: HStack(spacing: 16) {
            Spacer()
//            navigationButtonPlay
//            navigationButtonGear
        }
        .frame(width: 110)
        )
        
        .sheet(isPresented: appBinding.film.showSettings,
               onDismiss: {
//                cleanContentOnDismissSetting()
               }
               , content: {
//                FilmSettingsView(appBinding: appBinding)
               })

            .onAppear() {
                getMusicFile(state: appBinding)
                getCurrentMusicFile(state: appBinding)
            }
    }
}

private extension MusicView {
    var generateButton: some View {
        Button(action: {
            
            print("musicPlayList: \(appBinding.music.musicPlayList.wrappedValue.count)")
            
            print("listMusic (del): \(appBinding.music.listMusic.wrappedValue.count)")
            
            getMusicFile(state: appBinding)
            getCurrentMusicFile(state: appBinding)
            
            self.musicPlayer.setQueue(with: appBinding.music.musicPlayList.wrappedValue)
            self.musicPlayer.play()
            
            Feedback.shared.impactHeavy(.medium)
        }) {
            ButtonView(textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Сгенерировать", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .opacity(isPressedButton ? 0.8 : 1)
        .scaleEffect(isPressedButton ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.1))
        .pressAction {
            isPressedButton = true
        } onRelease: {
            isPressedButton = false
        }
        .padding(.horizontal ,16)
        .padding(.bottom, 16)
        .padding(.top, 2)
    }
}

private extension MusicView {
    var playAndPauseButton: some View {
        VStack(spacing: 0) {
            Button(action: {
                if self.musicPlayer.playbackState == .paused || self.musicPlayer.playbackState == .stopped {
                    self.musicPlayer.play()
                    appBinding.music.isPlaying.wrappedValue = true
                } else {
                    self.musicPlayer.pause()
                    appBinding.music.isPlaying.wrappedValue = false
                }
            }) {
                Image(appBinding.music.isPlaying.wrappedValue ? "pause" : "play")
            }
        }
    }
}

private extension MusicView {
    private func getMusicFile(state: Binding<AppState.AppData>) {
        injected.interactors.musicInteractor
            .getMusicFile(state: state)
    }
    
    private func getCurrentMusicFile(state: Binding<AppState.AppData>) {
        injected.interactors.musicInteractor
            .getCurrentMusicFile(state: state)
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView(appBinding: .constant(.init()))
    }
}
