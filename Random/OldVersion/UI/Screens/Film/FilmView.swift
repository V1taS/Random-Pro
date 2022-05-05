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
    private var actionButton: (() -> Void)?
    
    init(appBinding: Binding<AppState.AppData>, actionButton: (() -> Void)?) {
        self.appBinding = appBinding
        self.actionButton = actionButton
    }
    @Environment(\.injected) private var injected: DIContainer
    @State private var isPressedButton = false
    @State var genres = [NSLocalizedString("250 Лучших", comment: ""),
                         NSLocalizedString("100 Популярных", comment: "")
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
            .navigationBarItems(trailing: HStack(spacing: 24) {
                Spacer()
                navigationButtonPlay
                navigationButtonGear
            })
            
            .sheet(isPresented: appBinding.film.showSettings,
                   onDismiss: {
                cleanContentOnDismissSetting()
            }
                   , content: {
                FilmSettingsView(appBinding: appBinding)
            })
        }
        .onAppear {
            AppMetrics.trackEvent(name: .filmScreen)
            getMovies(state: appBinding) {
                saveFilmsToUserDefaults(state: appBinding)
            }
            validVideoplayerIcon(state: appBinding)
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
            removeCurrentFilm(state: appBinding)
            saveFilmsToUserDefaults(state: appBinding)
            actionButton?()
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
            FilmCellView(ratingIsSwitch: ratingIsShow(appBinding.film.filmsBest.wrappedValue.first?.rating),
                         ratingCount: ratingCount(appBinding.film.filmsBest.wrappedValue.first?.rating),
                         imageStr: appBinding.film.filmsBest.wrappedValue.first?.posterUrlPreview ?? "")
                .padding(.top, 24)
            
            Text(configureText(ru: appBinding.film.filmsBest.wrappedValue.first?.nameRu, en: appBinding.film.filmsBest.wrappedValue.first?.nameEn))
                .font(UIScreen.screenHeight < 570 ? .robotoMedium14() : .robotoMedium20())
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
            FilmCellView(ratingIsSwitch: ratingIsShow(appBinding.film.filmsPopular.wrappedValue.first?.rating),
                         ratingCount: ratingCount(appBinding.film.filmsPopular.wrappedValue.first?.rating),
                         imageStr: appBinding.film.filmsPopular.wrappedValue.first?.posterUrlPreview ?? "")
                .padding(.top, 24)
            
            Text(configureText(ru: appBinding.film.filmsPopular.wrappedValue.first?.nameRu, en: appBinding.film.filmsPopular.wrappedValue.first?.nameEn))
                .font(UIScreen.screenHeight < 570 ? .robotoMedium14() : .robotoMedium20())
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
                         imageStr: appBinding.film.filmsPopular.wrappedValue.first?.posterUrlPreview ?? "")
                .padding(.top, 24)
            
            Text(appBinding.film.nameFilmAll.wrappedValue)
                .font(UIScreen.screenHeight < 570 ? .robotoMedium14() : .robotoMedium20())
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
    func ratingIsShow(_ rating: String?) -> Bool {
        guard let rating = rating else { return false }
            let ratingDouble = Double(rating)
            if ratingDouble != nil {
                return true
            } else {
                return false
            }
    }
    
    func ratingCount(_ rating: String?) -> Double {
        guard let rating = rating else { return .zero }
            let ratingDouble = Double(rating)
            if let ratingDouble = ratingDouble {
                return ratingDouble
            } else {
                return .zero
            }
    }
    
    func configureText(ru textRu: String?, en textEn: String?) -> String {
        return NSLocalizedString("домен", comment: "") == "ru" ? "\(textRu ?? NSLocalizedString("Название фильма отсутствует", comment: ""))" : "\(textEn ?? NSLocalizedString("Название фильма отсутствует", comment: ""))"
    }
}

private extension FilmView {
    private func removeCurrentFilm(state: Binding<AppState.AppData>) {
        injected.interactors.filmInteractor
            .removeCurrentFilm(state: state)
    }
    
    private func getMovies(state: Binding<AppState.AppData>, complition: (() -> Void)? = nil) {
        injected.interactors.filmInteractor
            .getMovies(state: state, complition: complition)
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
        FilmView(appBinding: .constant(.init()), actionButton: nil)
    }
}
