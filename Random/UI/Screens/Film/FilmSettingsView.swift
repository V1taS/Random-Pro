//
//  FilmSettingsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 01.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import AVKit

struct FilmSettingsView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    
                    
                    HStack {
                        NavigationLink(
                            destination: filmInformation
                                .allowAutoDismiss { false }) {
                            Text(NSLocalizedString("Информация по фильму", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                        Spacer()
                    }
                    
                    HStack {
                        filmsHistory
                        Spacer()
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Последний фильм", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        lastFilmName
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Всего сгенерировано", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        filmsCountGenerate
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            cleanFilms(state: appBinding)
                            appBinding.film.showSettings.wrappedValue = false
                            getMovies(state: appBinding)
                            saveFilmsToUserDefaults(state: appBinding)
                            Feedback.shared.impactHeavy(.medium)
                        }) {
                            Text(NSLocalizedString("Очистить", comment: ""))
                                .font(.robotoRegular16())
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Настройки", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.film.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
            })
        }
    }
}

private extension FilmSettingsView {
    private var filmsHistory: AnyView {
        switch appBinding.film.selectedGenres.wrappedValue {
        case 0:
            return AnyView(NavigationLink(
                destination: FilmBestHistoryView(filmsBest: appBinding.film.filmsBestHistory.wrappedValue)
                    .allowAutoDismiss { false }) {
                Text(NSLocalizedString("История генерации", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
            })
        case 1:
            return AnyView(NavigationLink(
                destination: FilmBestHistoryView(filmsBest: appBinding.film.filmsPopularHistory.wrappedValue)
                    .allowAutoDismiss { false }) {
                Text(NSLocalizedString("История генерации", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
            })
        case 2:
            return AnyView(NavigationLink(
                destination: FilmHistoryView(appBinding: appBinding)
                    .allowAutoDismiss { false }) {
                Text(NSLocalizedString("История генерации", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium18())
            })
        default:
            return AnyView(Text("Error"))
        }
    }
}

private extension FilmSettingsView {
    private var filmsCountGenerate: AnyView {
        switch appBinding.film.selectedGenres.wrappedValue {
        case 0:
            return AnyView(Text("\(appBinding.film.filmsBestHistory.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16()))
        case 1:
            return AnyView(Text("\(appBinding.film.filmsPopularHistory.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16()))
        case 2:
            return AnyView(Text("\(appBinding.film.filmsHistory.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16()))
        default:
            return AnyView(Text("Error"))
        }
    }
}

private extension FilmSettingsView {
    private var lastFilmName: AnyView {
        switch appBinding.film.selectedGenres.wrappedValue {
        case 0:
            return AnyView(Text(NSLocalizedString("домен", comment: "") == "ru" ? "\(appBinding.film.filmsBestInfo.nameRu.wrappedValue ?? "нет")" : "\(appBinding.film.filmsBestInfo.nameEn.wrappedValue ?? "нет")")
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16()))
        case 1:
            return AnyView(Text(NSLocalizedString("домен", comment: "") == "ru" ? "\(appBinding.film.filmsPopularInfo.nameRu.wrappedValue ?? "нет")" : "\(appBinding.film.filmsPopularInfo.nameEn.wrappedValue ?? "нет")")
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16()))
        case 2:
            return AnyView(Text(NSLocalizedString("домен", comment: "") == "ru" ? "\(appBinding.film.filmInfo.data.wrappedValue?.nameRu ?? "нет")" : "\(appBinding.film.filmInfo.data.wrappedValue?.nameEn ?? "no")")
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16()))
        default:
            return AnyView(Text("Error"))
        }
    }
}

private extension FilmSettingsView {
    private var filmInformation: AnyView {
        switch appBinding.film.selectedGenres.wrappedValue {
        case 0:
            return AnyView(FilmInformationBestFilmView(
                            filmsInfo: appBinding.film.filmsBestInfo.wrappedValue,
                            iframeSrc: ""))
        case 1:
            return AnyView(FilmInformationBestFilmView(
                            filmsInfo: appBinding.film.filmsPopularInfo.wrappedValue,
                            iframeSrc: ""))
        case 2:
            return AnyView(FilmInformationAllFilmView(
                            filmsInfo: appBinding.film.filmInfo.wrappedValue,
                            iframeSrc: appBinding.film.filmsVideoHistory.wrappedValue.last?.iframeSrc ?? ""))
        default:
            return AnyView(Text("Error"))
        }
    }
}

// MARK: Actions
private extension FilmSettingsView {
    private func cleanFilms(state: Binding<AppState.AppData>) {
        injected.interactors.filmInteractor
            .cleanFilms(state: state)
    }
    
    private func getMovies(state: Binding<AppState.AppData>) {
        injected.interactors.filmInteractor
            .getMovies(state: state)
    }
}

private extension FilmSettingsView {
    private func saveFilmsToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.filmInteractor
            .saveFilmsToUserDefaults(state: state)
    }
}

struct FilmSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FilmSettingsView(appBinding: .constant(.init()))
    }
}
