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
    @State var genres = [NSLocalizedString("250 Лучших", comment: ""),
                         NSLocalizedString("100 Популярных", comment: ""),
                         NSLocalizedString("Все", comment: "")
    ]
    
    var body: some View {
        LoadingView(isShowing: appBinding.film.showActivityIndicator) {
            ZStack {
                Color(.clear)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    pickerView
                    content
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    generateButton
                }
            }
            .dismissingKeyboard()
            
            
            .navigationBarTitle(Text(NSLocalizedString("Фильмы", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: HStack(spacing: 16) {
                Spacer()
                navigationButtonPlay
                navigationButtonGear
            }
            .frame(width: 110)
            )
            
            .sheet(isPresented: appBinding.film.showSettings,
                   onDismiss: {
                    cleanContentOnDismissSetting()
                   }
                   , content: {
                    FilmSettingsView(appBinding: appBinding)
                   })
        }
        .onAppear {
            getMovies(state: appBinding)
        }
    }
}

private extension FilmView {
    var pickerView: some View {
        VStack {
            Picker(selection: appBinding.film.selectedGenres,
                   label: Text("Picker")) {
                ForEach(0..<genres.count) {
                    Text("\(genres[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

private extension FilmView {
    var navigationButtonGear: some View {
        Button(action: {
            appBinding.film.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
                .font(.system(size: 24))
        }
    }
}

private extension FilmView {
    var navigationButtonPlay: some View {
        Button(action: {
            getLinkOnPageKinopoiskVideo(state: appBinding)
        }) {
            showVideoPlayerIcon
        }
    }
}

private extension FilmView {
    private var showVideoPlayerIcon: AnyView {
        switch appBinding.film.selectedGenres.wrappedValue {
        case 0:
            return AnyView(showVideoPlayerIconBestFilms)
        case 1:
            return AnyView(showVideoPlayerIconPopularFilms)
        case 2:
            return AnyView(showVideoPlayerIconAllFilms)
        default:
            return AnyView(showVideoPlayerIconAllFilms)
        }
    }
}

private extension FilmView {
    var showVideoPlayerIconBestFilms: some View {
        VStack(spacing: 0) {
            if appBinding.film.showVideoPlayerIconBest.wrappedValue {
                Image(systemName: "play.rectangle")
                    .font(.system(size: 24))
                    .gradientForeground(colors: [Color.primaryError(), Color.red]).opacity(0.5)
            }
        }
    }
}

private extension FilmView {
    var showVideoPlayerIconPopularFilms: some View {
        VStack(spacing: 0) {
            if appBinding.film.showVideoPlayerIconPopular.wrappedValue {
                Image(systemName: "play.rectangle")
                    .font(.system(size: 24))
                    .gradientForeground(colors: [Color.primaryError(), Color.red]).opacity(0.5)
            }
        }
    }
}

private extension FilmView {
    var showVideoPlayerIconAllFilms: some View {
        VStack(spacing: 0) {
            if appBinding.film.showVideoPlayerIconAll.wrappedValue {
                Image(systemName: "play.rectangle")
                    .font(.system(size: 24))
                    .gradientForeground(colors: [Color.primaryError(), Color.red]).opacity(0.5)
            }
        }
    }
}

private extension FilmView {
    var generateButton: some View {
        Button(action: {
            validVideoplayerIcon(state: appBinding)
            getMovies(state: appBinding)
            getCurrentFilmInfo(state: appBinding)
            saveFilmsToUserDefaults(state: appBinding)
            
            settingsScreen()
            
            
            
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

private extension FilmView {
    private var content: AnyView {
        switch appBinding.film.selectedGenres.wrappedValue {
        case 0:
            return AnyView(bestFilms)
        case 1:
            return AnyView(popularFilms)
        case 2:
            return AnyView(allFilms)
        default:
            return AnyView(bestFilms)
        }
    }
}

private extension FilmView {
    var bestFilms: some View {
        VStack(spacing: 0) {
            FilmCellView(ratingIsSwitch: appBinding.film.ratingIsShowBest.wrappedValue,
                         ratingCount: appBinding.film.ratingFilmBest.wrappedValue,
                         imageStr: appBinding.film.imageFilmBest.wrappedValue)
                .padding(.top, 24)
            
            Text(appBinding.film.nameFilmBest.wrappedValue)
                .font(.robotoMedium20())
                .lineLimit(2)
                .foregroundColor(.black)
                .opacity(isPressedButton ? 0.8 : 1)
                .scaleEffect(isPressedButton ? 0.8 : 1)
                .animation(.easeInOut(duration: 0.2), value: isPressedButton)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 8)
        }
    }
}

private extension FilmView {
    var allFilms: some View {
        VStack(spacing: 0) {
            FilmCellView(ratingIsSwitch: appBinding.film.ratingIsShowAll.wrappedValue,
                         ratingCount: appBinding.film.ratingFilmAll.wrappedValue,
                         imageStr: appBinding.film.imageFilmAll.wrappedValue)
                .padding(.top, 24)
            
            Text(appBinding.film.nameFilmAll.wrappedValue)
                .font(.robotoMedium20())
                .lineLimit(2)
                .foregroundColor(.black)
                .opacity(isPressedButton ? 0.8 : 1)
                .scaleEffect(isPressedButton ? 0.8 : 1)
                .animation(.easeInOut(duration: 0.2), value: isPressedButton)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 8)
        }
    }
}

private extension FilmView {
    var popularFilms: some View {
        VStack(spacing: 0) {
            FilmCellView(ratingIsSwitch: appBinding.film.ratingIsShowPopular.wrappedValue,
                         ratingCount: appBinding.film.ratingFilmPopular.wrappedValue,
                         imageStr: appBinding.film.imageFilmPopular.wrappedValue)
                .padding(.top, 24)
            
            Text(appBinding.film.nameFilmPopular.wrappedValue)
                .font(.robotoMedium20())
                .lineLimit(2)
                .foregroundColor(.black)
                .opacity(isPressedButton ? 0.8 : 1)
                .scaleEffect(isPressedButton ? 0.8 : 1)
                .animation(.easeInOut(duration: 0.2), value: isPressedButton)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.top, 8)
        }
    }
}

// MARK: Actions
private extension FilmView {
    private func settingsScreen() {
        switch appBinding.film.selectedGenres.wrappedValue {
        case 0:
            appBinding.film.nameFilmBest.wrappedValue = NSLocalizedString("домен", comment: "") == "ru" ? "\(appBinding.film.filmsBestInfo.nameRu.wrappedValue ?? NSLocalizedString("Название фильма отсутствует", comment: ""))" : "\(appBinding.film.filmsBestInfo.nameEn.wrappedValue ?? NSLocalizedString("Название фильма отсутствует", comment: ""))"
            appBinding.film.imageFilmBest.wrappedValue = appBinding.film.filmsBestInfo.posterUrlPreview.wrappedValue ?? ""
            
            if let rating = appBinding.film.filmsBestInfo.rating.wrappedValue {
                appBinding.film.ratingIsShowBest.wrappedValue = true
                let ratingDouble = Double(rating)
                if let ratingDouble = ratingDouble {
                    appBinding.film.ratingFilmBest.wrappedValue = ratingDouble
                } else {
                    appBinding.film.ratingIsShowBest.wrappedValue = false
                }
            } else {
                appBinding.film.ratingIsShowBest.wrappedValue = false
            }
            
        case 1:
            appBinding.film.nameFilmPopular.wrappedValue = NSLocalizedString("домен", comment: "") == "ru" ? "\(appBinding.film.filmsPopularInfo.nameRu.wrappedValue ?? NSLocalizedString("Название фильма отсутствует", comment: ""))" : "\(appBinding.film.filmsPopularInfo.nameEn.wrappedValue ?? NSLocalizedString("Название фильма отсутствует", comment: ""))"
            appBinding.film.imageFilmPopular.wrappedValue = appBinding.film.filmsPopularInfo.posterUrlPreview.wrappedValue ?? ""
            
            if let rating = appBinding.film.filmsPopularInfo.rating.wrappedValue {
                appBinding.film.ratingIsShowPopular.wrappedValue = true
                let ratingDouble = Double(rating)
                
                if let ratingDouble = ratingDouble {
                    appBinding.film.ratingFilmPopular.wrappedValue = ratingDouble
                } else {
                    appBinding.film.ratingIsShowPopular.wrappedValue = false
                }
                
            } else {
                appBinding.film.ratingIsShowPopular.wrappedValue = false
            }
        case 2:
            appBinding.film.nameFilmAll.wrappedValue = NSLocalizedString("домен", comment: "") == "ru" ? "\(appBinding.film.filmInfo.data.wrappedValue?.nameRu ?? NSLocalizedString("Название фильма отсутствует", comment: ""))" : "\(appBinding.film.filmInfo.data.wrappedValue?.nameEn ?? NSLocalizedString("Название фильма отсутствует", comment: ""))"
            appBinding.film.imageFilmAll.wrappedValue = appBinding.film.filmInfo.data.wrappedValue?.posterUrlPreview ?? ""
            
            if let rating = appBinding.film.filmInfo.rating.wrappedValue?.ratingImdb {
                appBinding.film.ratingIsShowAll.wrappedValue = true
                appBinding.film.ratingFilmAll.wrappedValue = rating
            } else {
                appBinding.film.ratingIsShowAll.wrappedValue = false
            }
        default: break
        }
    }
}

private extension FilmView {
    private func cleanContentOnDismissSetting() {
        if appBinding.film.filmsBest.wrappedValue.isEmpty && appBinding.film.filmsBestHistory.wrappedValue.isEmpty &&
            appBinding.film.filmsPopular.wrappedValue.isEmpty && appBinding.film.filmsPopularHistory.wrappedValue.isEmpty &&
            appBinding.film.films.wrappedValue.isEmpty && appBinding.film.filmsHistory.wrappedValue.isEmpty {
            
            appBinding.film.nameFilmBest.wrappedValue = ""
            appBinding.film.imageFilmBest.wrappedValue = ""
            appBinding.film.ratingFilmBest.wrappedValue = 0.0
            appBinding.film.ratingIsShowBest.wrappedValue = false
            
            appBinding.film.nameFilmPopular.wrappedValue = ""
            appBinding.film.imageFilmPopular.wrappedValue = ""
            appBinding.film.ratingFilmPopular.wrappedValue = 0.0
            appBinding.film.ratingIsShowPopular.wrappedValue = false
            
            appBinding.film.nameFilmAll.wrappedValue = ""
            appBinding.film.imageFilmAll.wrappedValue = ""
            appBinding.film.ratingFilmAll.wrappedValue = 0.0
            appBinding.film.ratingIsShowAll.wrappedValue = false
        }
    }
}


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

private extension FilmView {
    private func saveFilmsToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.filmInteractor
            .saveFilmsToUserDefaults(state: state)
    }
}

private extension FilmView {
    private func getLinkOnPageKinopoiskVideo(state: Binding<AppState.AppData>) {
        injected.interactors.filmInteractor
            .getLinkOnPageKinopoiskVideo(state: state)
    }
}

private extension FilmView {
    private func validVideoplayerIcon(state: Binding<AppState.AppData>) {
        injected.interactors.filmInteractor
            .validVideoplayerIcon(state: state)
    }
}

struct FilmView_Previews: PreviewProvider {
    static var previews: some View {
        FilmView(appBinding: .constant(.init()))
    }
}
