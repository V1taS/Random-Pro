//
//  FilmInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol FilmInteractor {
    func getMovies(state: Binding<AppState.AppData>)
    func getCurrentFilmInfo(state: Binding<AppState.AppData>)
    func cleanFilms(state: Binding<AppState.AppData>)
    func saveFilmsToUserDefaults(state: Binding<AppState.AppData>)
    func getLinkOnPageAllVideo(filmHistoryData: [Datum]?, filmKinopoisk: FilmsInfo?)
    func validVideoplayerIcon(filmHistoryData: [Datum]?, filmKinopoisk: FilmsInfo?) -> Bool
}

struct FilmInteractorImpl: FilmInteractor {
    
    func validVideoplayerIcon(filmHistoryData: [Datum]?, filmKinopoisk: FilmsInfo?) -> Bool {
        guard let filmHistoryData = filmHistoryData else { return false }
        guard let filmKinopoisk = filmKinopoisk else { return false }
        
        if let kinopoiskIdStr = filmKinopoisk.data?.filmId {
            let filmWithId = filmHistoryData.filter { $0.kinopoiskID == "\(kinopoiskIdStr)" }
            guard filmWithId.first?.iframeSrc != nil else { return false }
            return true
        } else if let kinopoiskNameRu = filmKinopoisk.data?.nameRu {
            let filmWithNameRu = filmHistoryData.filter { $0.ruTitle == "\(kinopoiskNameRu)" }
            guard filmWithNameRu.first?.iframeSrc != nil else { return false }
            return true
        } else if let kinopoiskNameEn = filmKinopoisk.data?.nameEn {
            let filmWithNameEn = filmHistoryData.filter { $0.origTitle == "\(kinopoiskNameEn)" }
            guard filmWithNameEn.first?.iframeSrc != nil else { return false }
            return true
        }
        return false
    }
    
    
    func getLinkOnPageAllVideo(filmHistoryData: [Datum]?, filmKinopoisk: FilmsInfo?) {
        guard let filmHistoryData = filmHistoryData else { return }
        guard let filmKinopoisk = filmKinopoisk else { return }
        
        if let kinopoiskIdStr = filmKinopoisk.data?.filmId {
            let filmWithId = filmHistoryData.filter { $0.kinopoiskID == "\(kinopoiskIdStr)" }
            guard let iframeSrc = filmWithId.first?.iframeSrc else {return }
            getLinkFromStringURL(strURL: iframeSrc)
        } else if let kinopoiskNameRu = filmKinopoisk.data?.nameRu {
            let filmWithNameRu = filmHistoryData.filter { $0.ruTitle == "\(kinopoiskNameRu)" }
            guard let iframeSrc = filmWithNameRu.first?.iframeSrc else {return }
            getLinkFromStringURL(strURL: iframeSrc)
        } else if let kinopoiskNameEn = filmKinopoisk.data?.nameEn {
            let filmWithNameEn = filmHistoryData.filter { $0.origTitle == "\(kinopoiskNameEn)" }
            guard let iframeSrc = filmWithNameEn.first?.iframeSrc else {return }
            getLinkFromStringURL(strURL: iframeSrc)
        }
    }

    func getMovies(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
            if state.film.filmsBest.wrappedValue.count == 0 || state.film.filmsBest.wrappedValue.count == 1 {
                let page = Int.random(in: 1...13)
                state.film.showActivityIndicator.wrappedValue = true
                Networking.share.getInfoKinopoiskBestFilms(page: page) { films in
                    let films = films.films?.shuffled()
                    state.film.filmsBest.wrappedValue.append(contentsOf: films ?? [])
                    state.film.showActivityIndicator.wrappedValue = false
                }
            }
            
            if state.film.filmsPopular.wrappedValue.count == 0 || state.film.filmsPopular.wrappedValue.count == 1 {
                let page = Int.random(in: 1...5)
                state.film.showActivityIndicator.wrappedValue = true
                Networking.share.getInfoKinopoiskPopularFilms(page: page) { films in
                    let films = films.films?.shuffled()
                    state.film.filmsPopular.wrappedValue.append(contentsOf: films ?? [])
                    state.film.showActivityIndicator.wrappedValue = false
                }
            }
            
            if state.film.films.wrappedValue.count == 0 || state.film.films.wrappedValue.count == 1 {
                let year = Int.random(in: 2010...2021)
                
                state.film.showActivityIndicator.wrappedValue = true
                Networking.share.getMovies(year: year, limit: 20) { films in
                    var films = films
                    
                    for (index, film) in films.data.enumerated() {
                        if film.kinopoiskID == nil {
                            films.data.remove(at: index)
                        }
                    }
                    
                    let filmsShuffled = films.data.shuffled()
                    state.film.films.wrappedValue.append(contentsOf: filmsShuffled)
                    
                    Networking.share.getInfoKinopoisk(films: filmsShuffled, state: state)

                    state.film.showActivityIndicator.wrappedValue = false
                }
            }
        }
    }
    
    func getCurrentFilmInfo(state: Binding<AppState.AppData>) {
        
        switch state.film.selectedGenres.wrappedValue {
        case 0:
            if !state.film.filmsBest.wrappedValue.isEmpty {
                let film = state.film.filmsBest.wrappedValue.first
                state.film.filmsBestInfo.wrappedValue = film!
                state.film.filmsBestHistory.wrappedValue.append(film!)
                state.film.filmsBest.wrappedValue.removeFirst()
            }
        case 1:
            if !state.film.filmsPopular.wrappedValue.isEmpty {
                let film = state.film.filmsPopular.wrappedValue.first
                state.film.filmsPopularInfo.wrappedValue = film!
                state.film.filmsPopularHistory.wrappedValue.append(film!)
                state.film.filmsPopular.wrappedValue.removeFirst()
            }
        case 2:
            if !state.film.films.wrappedValue.isEmpty {
                if state.film.films.wrappedValue.first?.kinopoiskID == nil {
                    state.film.films.wrappedValue.removeFirst()
                }
                
                guard let filmsTemp = state.film.filmsTemp.wrappedValue.first else { return }
                guard let films = state.film.films.wrappedValue.first else { return }
                
                state.film.filmInfo.wrappedValue = filmsTemp
                state.film.filmsHistory.wrappedValue.append(filmsTemp)
                state.film.filmsVideoHistory.wrappedValue.append(films)
                state.film.films.wrappedValue.removeFirst()
                state.film.filmsTemp.wrappedValue.removeFirst()
                
            }
        default: break
        }
    }
    
    func cleanFilms(state: Binding<AppState.AppData>) {
        state.film.films.wrappedValue = []
        state.film.filmsHistory.wrappedValue = []
        state.film.filmsVideoHistory.wrappedValue = []
        state.film.filmsTemp.wrappedValue = []
        
        state.film.filmsBest.wrappedValue = []
        state.film.filmsBestHistory.wrappedValue = []
        
        state.film.filmsPopular.wrappedValue = []
        state.film.filmsPopularHistory.wrappedValue = []
    }
    
    func saveFilmsToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
            saveFilms(state: state)
            saveFilmsVideoHistory(state: state)
            saveFilmsHistory(state: state)
            saveFilmsBest(state: state)
            saveFilmsBestHistory(state: state)
            saveFilmsPopular(state: state)
            saveFilmsBestPopular(state: state)
            saveFilmsTemp(state: state)
        }
    }
}

extension FilmInteractorImpl {
    private func encoderArrDatum(films: [Datum], forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(films) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}

extension FilmInteractorImpl {
    private func encoderArrFilmsInfo(filmInfo: [FilmsInfo], forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(filmInfo) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}

extension FilmInteractorImpl {
    private func encoderArrBestFilm(films: [BestFilm], forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(films) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}

// MARK - Films Save
extension FilmInteractorImpl {
    private func saveFilms(state: Binding<AppState.AppData>) {
        encoderArrDatum(films: state.film.films.wrappedValue, forKey: "FilmsData")
    }
    
    private func saveFilmsVideoHistory(state: Binding<AppState.AppData>) {
        encoderArrDatum(films: state.film.filmsVideoHistory.wrappedValue, forKey: "FilmsVideoHistory")
    }
    
    private func saveFilmsHistory(state: Binding<AppState.AppData>) {
        encoderArrFilmsInfo(filmInfo: state.film.filmsHistory.wrappedValue, forKey: "FilmsHistory")
    }
    
    private func saveFilmsTemp(state: Binding<AppState.AppData>) {
        encoderArrFilmsInfo(filmInfo: state.film.filmsTemp.wrappedValue, forKey: "FilmsTemp")
    }
}

// MARK - FilmsBest Save
extension FilmInteractorImpl {
    private func saveFilmsBest(state: Binding<AppState.AppData>) {
        encoderArrBestFilm(films: state.film.filmsBest.wrappedValue, forKey: "FilmsBest")
    }
    
    private func saveFilmsBestHistory(state: Binding<AppState.AppData>) {
        encoderArrBestFilm(films: state.film.filmsBestHistory.wrappedValue, forKey: "FilmsBestHistory")
    }
}

// MARK - FilmsPopular Save
extension FilmInteractorImpl {
    private func saveFilmsPopular(state: Binding<AppState.AppData>) {
        encoderArrBestFilm(films: state.film.filmsPopular.wrappedValue, forKey: "FilmsPopular")
    }
    
    private func saveFilmsBestPopular(state: Binding<AppState.AppData>) {
        encoderArrBestFilm(films: state.film.filmsPopularHistory.wrappedValue, forKey: "FilmsPopularHistory")
    }
}
