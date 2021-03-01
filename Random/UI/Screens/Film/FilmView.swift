//
//  FilmView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct FilmView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    @State private var isPressedButton = false
    @State private var isPressedTouch = false
    
    @State private var rating: Double = 0.0
    
    var body: some View {
        LoadingView(isShowing: appBinding.film.showActivityIndicator) {
            ZStack {
                Color(.clear)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            
                            Text(NSLocalizedString("домен", comment: "") == "ru" ? "\(appBinding.film.filmInfo.data.wrappedValue?.nameRu ?? "")" : "\(appBinding.film.filmInfo.data.wrappedValue?.nameEn ?? "")")
                                .font(.robotoBold40())
                                .lineLimit(2)
                                .gradientForeground(colors: [Color.primaryGreen(), Color.primaryTertiary()])
                                .opacity(isPressedButton || isPressedTouch ? 0.8 : 1)
                                .scaleEffect(isPressedButton || isPressedTouch ? 0.8 : 1)
                                .animation(.easeInOut(duration: 0.2), value: isPressedButton || isPressedTouch)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 16)
                                .padding(.top, 16)
                        }
                        
                        
                        WebImage(url: URL(string: (appBinding.film.filmInfo.data.wrappedValue?.posterUrlPreview ?? "")))
                            .resizable()
                            .renderingMode(.original)
                            .onSuccess { image, data, cacheType in }
                            .placeholder(Image("no_image"))
                            .indicator(.activity)
                            .transition(.fade(duration: 0.5))
                            .scaledToFill()
                            .aspectRatio(contentMode: .fit)
                        //                        .cornerRadius(8)
                        Spacer()
                    }
                }
                
                VStack {
                    Spacer()
                    generateButton
                }
                
            }
            .dismissingKeyboard()
            .onAppear {
                getMovies(state: appBinding)
            }
            
            .navigationBarTitle(Text(NSLocalizedString("Фильмы", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: HStack(spacing: 24) {
                
                Button(action: {
                    getLinkFromStringURL(strURL: appBinding.film.filmsVideoHistory.wrappedValue.last?.iframeSrc)
                }) {
                    if !appBinding.film.filmsVideoHistory.wrappedValue.isEmpty {
                        Image(systemName: "play.rectangle")
                            .font(.system(size: 24))
                            .gradientForeground(colors: [Color.primaryError(), Color.red]).opacity(0.5)
                    }
                }
                
                Button(action: {
                    appBinding.film.showSettings.wrappedValue.toggle()
                }) {
                    if !appBinding.film.filmsVideoHistory.wrappedValue.isEmpty {
                        Image(systemName: "gear")
                            .font(.system(size: 24))
                    }
                }
            })
            .sheet(isPresented: appBinding.film.showSettings, content: {
                FilmSettingsView(appBinding: appBinding)
            })
        }
    }
}

private extension FilmView {
    var generateButton: some View {
        Button(action: {
            
            //            Networking.share.getInfoKinopoisk(films: appBinding.film.films.wrappedValue) { film in
            //                rating = film.rating?.ratingImdb ?? 1
            //                print("\(film)")
            //            }
            
            
            getMovies(state: appBinding)
            getCurrentFilmInfo(state: appBinding)
            
            
            //            print("films: \(appBinding.film.filmInfo.wrappedValue)")
            
            
            
            //            saveContactToUserDefaults(state: appBinding)
            Feedback.shared.impactHeavy(.medium)
        }) {
            ButtonView(background: .primaryTertiary(),
                       textColor: .primaryPale(),
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

// MARK: Actions
private extension FilmView {
    private func getCurrentFilmInfo(state: Binding<AppState.AppData>) {
        injected.interactors.filmInteractor
            .getCurrentFilmInfo(state: state)
    }
    
    private func getMovies(state: Binding<AppState.AppData>) {
        injected.interactors.filmInteractor
            .getMovies(state: state)
    }
}

//private extension FilmView {
//    private func saveContactToUserDefaults(state: Binding<AppState.AppData>) {
//        injected.interactors.contactInteractor
//            .saveContactToUserDefaults(state: state)
//    }
//}

struct FilmView_Previews: PreviewProvider {
    static var previews: some View {
        FilmView(appBinding: .constant(.init()))
    }
}
