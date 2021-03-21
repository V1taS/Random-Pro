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
    private let sizePhone = UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 300)
    private let sizeIPad = UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 270)
    @Environment(\.presentationMode) var presentationMode
    
    @State var musicPlayer = MPMusicPlayerController.applicationMusicPlayer
    
    var body: some View {
        LoadingView(isShowing: appBinding.music.showActivityIndicator) {
            ZStack {
                VStack(spacing: 0) {
                    deviceImage
                    nameMusic
                    nameArtist
                    realiaseMusic
                    playAndPauseButton
                        .disabled(appBinding.music.playButtonIsDisabled.wrappedValue)
                        .padding(.top, 24)
                    Spacer()
                    generateButton
                }
            }
            .dismissingKeyboard()
            
            
            .navigationBarTitle(Text(NSLocalizedString("Музыка", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: HStack(spacing: 16) {
                Spacer()
                navigationButtonPlay
                Color.clear
                    .frame(width: 2)
                navigationButtonGear
            }
            .frame(width: 110)
            )
            
            .sheet(isPresented: appBinding.music.showSettings,
                   onDismiss: {
                    if appBinding.music.listMusic.wrappedValue.isEmpty {
                        getMusicFile(state: appBinding)
                        musicPlayer.pause()
                        appBinding.music.isPlaying.wrappedValue = false
                        appBinding.music.playButtonIsDisabled.wrappedValue = true
                    }
                   }
                   , content: {
                    MusicSettingsView(appBinding: appBinding)
                   })
            
            .onAppear {
                appBinding.music.showActivityIndicator.wrappedValue = true
                
                
                DispatchQueue.global(qos: .userInteractive).async {
                    if AppleMusicAPI.share.getUserToken() == nil {
                        noSubscription
                    } else {
                        subscription
                    }
                }
            }
        }
    }
}

// MARK: No subscription
private extension MusicView {
    var noSubscription: some View {
        print("Подписки Apple music - нет")
        
        DispatchQueue.main.async {
            UIApplication.shared.windows.first?.rootViewController?.showAlert(with: NSLocalizedString("Внимание", comment: ""), and: NSLocalizedString("Ваше устройство не имеет подписки Apple Music", comment: ""), style: .alert) {
                presentationMode.wrappedValue.dismiss()
                appBinding.music.showActivityIndicator.wrappedValue = false
            }
        }
    }
}

// MARK: Subscription
private extension MusicView {
    var subscription: some View {
        print("Подписка Apple music есть")
        
        if appBinding.music.listMusic.wrappedValue.isEmpty {
            musicPlayer.pause()
            appBinding.music.isPlaying.wrappedValue = false
            appBinding.music.playButtonIsDisabled.wrappedValue = true
        } else {
            musicPlayer.setQueue(with: [appBinding.music.resultMusic.wrappedValue.id ?? ""])
        }
        
        getMusicFile(state: appBinding)
        
        if self.musicPlayer.playbackState == .playing {
            appBinding.music.isPlaying.wrappedValue = true
        } else {
            appBinding.music.isPlaying.wrappedValue = false
        }
        
        appBinding.music.showActivityIndicator.wrappedValue = false
    }
}

// MARK: Name music
private extension MusicView {
    var nameMusic: some View {
        Text("\(appBinding.music.resultMusic.wrappedValue.attributes?.name ?? NSLocalizedString("Название песни", comment: ""))")
            .font(.robotoMedium32())
            .foregroundColor(.primaryGray())
            .lineLimit(2)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .padding(.top, 16)
    }
}

// MARK: Name music
private extension MusicView {
    var nameArtist: some View {
        Text("\(appBinding.music.resultMusic.wrappedValue.attributes?.artistName ?? NSLocalizedString("Имя артиста", comment: ""))")
            .font(.robotoRegular24())
            .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
            .lineLimit(2)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .padding(.top, 8)
    }
}

// MARK: Reliase music
private extension MusicView {
    var realiaseMusic: some View {
        Text("\(NSLocalizedString("Релиз:", comment: "")) \(appBinding.music.resultMusic.wrappedValue.attributes?.releaseDate ?? "")")
            .font(.robotoMedium18())
            .foregroundColor(.gray)
            .lineLimit(2)
            .foregroundColor(.black)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 20)
            .padding(.top, 4)
    }
}

// MARK: Device
private extension MusicView {
    private var deviceImage: AnyView {
        switch UIDevice.current.userInterfaceIdiom == .phone {
        case true:
            return AnyView(imageForIPhone)
        case false:
            return AnyView(imageForIPad)
        }
    }
}

// MARK: Device Phone
private extension MusicView {
    var imageForIPhone: some View {
        WebImage(url: URL(string: appBinding.music.resultMusic.wrappedValue.attributes?.artwork?.url?.replacingOccurrences(of: "{w}", with: "300").replacingOccurrences(of: "{h}", with: "300") ?? ""))
            .resizable()
            .renderingMode(.original)
            .onSuccess { image, data, cacheType in }
            .placeholder(Image("musicPH"))
            .indicator(.activity)
            .frame(width: sizePhone, height: sizePhone)
            .transition(.fade(duration: 0.5))
            .scaledToFill()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(6)
            .overlay(RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(.systemGray4)))
            .padding(.top, 24)
    }
}

// MARK: Device IPad
private extension MusicView {
    var imageForIPad: some View {
        WebImage(url: URL(string: appBinding.music.resultMusic.wrappedValue.attributes?.artwork?.url?.replacingOccurrences(of: "{w}", with: "300").replacingOccurrences(of: "{h}", with: "300") ?? ""))
            .resizable()
            .renderingMode(.original)
            .onSuccess { image, data, cacheType in }
            .placeholder(Image("musicPH"))
            .indicator(.activity)
            .frame(width: sizeIPad, height: sizeIPad)
            .transition(.fade(duration: 0.5))
            .scaledToFill()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(6)
            .overlay(RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(.systemGray4)))
            .padding(.top, 24)
    }
}

private extension MusicView {
    var navigationButtonPlay: some View {
        Button(action: {
            guard let urlStr = appBinding.music.resultMusic.wrappedValue.attributes?.url else { return }
            if let url = URL(string: urlStr) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                }
            }
            
        }) {
            Image("musicAdd")
                .resizable()
                .renderingMode(.original)
                .frame(width: 24, height: 24)
                .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
        }
    }
}

private extension MusicView {
    var navigationButtonGear: some View {
        Button(action: {
            appBinding.music.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
                .font(.system(size: 24))
        }
    }
}

private extension MusicView {
    var generateButton: some View {
        Button(action: {
            
            // Пропустить трек
            //            self.musicPlayer.skipToNextItem()
            
            DispatchQueue.global(qos: .userInteractive).async {
                getMusicFile(state: appBinding)
                getCurrentMusicFile(state: appBinding)
                musicPlayer.setQueue(with: [appBinding.music.resultMusic.wrappedValue.id ?? ""])
                musicPlayer.play()
            }
            
            appBinding.music.isPlaying.wrappedValue = true
            
            if appBinding.music.playButtonIsDisabled.wrappedValue {
                appBinding.music.playButtonIsDisabled.wrappedValue = false
            }
            saveFilmsToUserDefaults(state: appBinding)
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
                    .resizable()
                    .renderingMode(.original)
                    .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))]).opacity(appBinding.music.playButtonIsDisabled.wrappedValue ? 0.044 : 1)
                    .frame(width: 70, height: 70)
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
    
    private func saveFilmsToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.musicInteractor
            .saveFilmsToUserDefaults(state: state)
    }
}

struct MusicView_Previews: PreviewProvider {
    static var previews: some View {
        MusicView(appBinding: .constant(.init()))
    }
}
