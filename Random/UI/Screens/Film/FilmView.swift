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
    
    @State var genres = [NSLocalizedString("250 Лучших", comment: ""),
                       NSLocalizedString("100 Популярных", comment: ""),
                       NSLocalizedString("Все", comment: "")
    ]
    
    @State private var nameFilm = ""
    @State private var imageFilm = ""
    @State private var ratingFilm: Double = 0.0
    @State private var ratingIsShow = false
    
    var body: some View {
        LoadingView(isShowing: appBinding.film.showActivityIndicator) {
            ZStack {
                Color(.clear)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 16) {
                    pickerView
                    filmImage
                    filmText
                    Spacer()
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
                navigationButtonPlay
                navigationButtonGear
            })
            .sheet(isPresented: appBinding.film.showSettings, content: {
                FilmSettingsView(appBinding: appBinding)
            })
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
            .padding(.top, 16)
        }
    }
}

private extension FilmView {
    var filmImage: some View {
        VStack {
            FilmCellView(ratingIsSwitch: ratingIsShow,
                         ratingCount: ratingFilm,
                         imageStr: imageFilm)
        }
        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 330),
               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 450))
    }
}

private extension FilmView {
    var filmText: some View {
        Text(nameFilm)
            .font(.robotoMedium20())
            .lineLimit(2)
            .foregroundColor(.black)
            .opacity(isPressedButton || isPressedTouch ? 0.8 : 1)
            .scaleEffect(isPressedButton || isPressedTouch ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.2), value: isPressedButton || isPressedTouch)
            .multilineTextAlignment(.center)
            .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 330))
    }
}

private extension FilmView {
    var navigationButtonGear: some View {
        Button(action: {
            appBinding.film.showSettings.wrappedValue.toggle()
        }) {
            if !appBinding.film.filmsVideoHistory.wrappedValue.isEmpty {
                Image(systemName: "gear")
                    .font(.system(size: 24))
            }
        }
    }
}

private extension FilmView {
    var navigationButtonPlay: some View {
        Button(action: {
            getLinkFromStringURL(strURL: appBinding.film.filmsVideoHistory.wrappedValue.last?.iframeSrc)
        }) {
            if appBinding.film.selectedGenres.wrappedValue == 2 {
                if !appBinding.film.filmsVideoHistory.wrappedValue.isEmpty {
                    Image(systemName: "play.rectangle")
                        .font(.system(size: 24))
                        .gradientForeground(colors: [Color.primaryError(), Color.red]).opacity(0.5)
                }
            }
        }
    }
}

private extension FilmView {
    var generateButton: some View {
        Button(action: {
            
//            appBinding.film.selectedGenres.wrappedValue = selectedGenres
//            print("\(selectedGenres)")
            getMovies(state: appBinding)
            getCurrentFilmInfo(state: appBinding)
            saveFilmsToUserDefaults(state: appBinding)
            
            
            
            switch appBinding.film.selectedGenres.wrappedValue {
            case 0:
                nameFilm = NSLocalizedString("домен", comment: "") == "ru" ? "\(appBinding.film.filmsBestInfo.nameRu.wrappedValue ?? "")" : "\(appBinding.film.filmsBestInfo.nameEn.wrappedValue ?? "")"
                imageFilm = appBinding.film.filmsBestInfo.posterUrlPreview.wrappedValue ?? ""
                
                if let rating = appBinding.film.filmsBestInfo.rating.wrappedValue {
                    ratingIsShow = true
                    let ratingDouble = Double(rating)
                    ratingFilm = ratingDouble ?? 0.0
                } else {
                    ratingIsShow = false
                }

            case 1:
                print("")
            case 2:
                nameFilm = NSLocalizedString("домен", comment: "") == "ru" ? "\(appBinding.film.filmInfo.data.wrappedValue?.nameRu ?? "")" : "\(appBinding.film.filmInfo.data.wrappedValue?.nameEn ?? "")"
                imageFilm = appBinding.film.filmInfo.data.wrappedValue?.posterUrlPreview ?? ""
                
                if let rating = appBinding.film.filmInfo.rating.wrappedValue?.ratingImdb {
                    ratingIsShow = true
                    ratingFilm = rating
                } else {
                    ratingIsShow = false
                }
                
            default: break
            }
            
            
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

private extension FilmView {
    private func saveFilmsToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.filmInteractor
            .saveFilmsToUserDefaults(state: state)
    }
}

struct FilmView_Previews: PreviewProvider {
    static var previews: some View {
        FilmView(appBinding: .constant(.init()))
    }
}
