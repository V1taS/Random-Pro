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
}

struct FilmInteractorImpl: FilmInteractor {
    func getMovies(state: Binding<AppState.AppData>) {
        
        if state.film.filmsBest.wrappedValue.count == 0 || state.film.filmsBest.wrappedValue.count == 2 {
            let page = Int.random(in: 1...13)
            state.film.showActivityIndicator.wrappedValue = true
            Networking.share.getInfoKinopoiskBestFilms(page: page) { films in
                let films = films.films?.shuffled()
                state.film.filmsBest.wrappedValue.append(contentsOf: films ?? [])
                state.film.showActivityIndicator.wrappedValue = false
            }
        }
        
        if state.film.filmsPopular.wrappedValue.count == 0 || state.film.filmsPopular.wrappedValue.count == 2 {
            let page = Int.random(in: 1...5)
            state.film.showActivityIndicator.wrappedValue = true
            Networking.share.getInfoKinopoiskPopularFilms(page: page) { films in
                let films = films.films?.shuffled()
                state.film.filmsPopular.wrappedValue.append(contentsOf: films ?? [])
                state.film.showActivityIndicator.wrappedValue = false
            }
        }
        
        if state.film.films.wrappedValue.count == 0 || state.film.films.wrappedValue.count == 2 {
            let year = Int.random(in: 2010...2021)

            state.film.showActivityIndicator.wrappedValue = true
            Networking.share.getMovies(year: year, limit: 10) { films in
                let films = films.data.shuffled()
                state.film.films.wrappedValue.append(contentsOf: films)
                state.film.showActivityIndicator.wrappedValue = false
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
                
                Networking.share.getInfoKinopoisk(films: state.film.films.wrappedValue) { film in
                    state.film.filmInfo.wrappedValue = film
                    state.film.filmsHistory.wrappedValue.append(film)
                    state.film.filmsVideoHistory.wrappedValue.append(state.film.films.wrappedValue.first!)
                    state.film.films.wrappedValue.removeFirst()
                }
            }
        default: break
        }
    }
    
    func cleanFilms(state: Binding<AppState.AppData>) {
        state.film.films.wrappedValue = []
        state.film.filmsHistory.wrappedValue = []
        state.film.filmsVideoHistory.wrappedValue = []
        state.film.filmInfo.wrappedValue = FilmsInfo.plug
    }
    
    func saveFilmsToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
            saveFilms(state: state)
            saveFilmsVideoHistory(state: state)
            saveFilmsHistory(state: state)
            saveFilmInfo(state: state)
        }
    }
}

extension FilmInteractorImpl {
    private func encoder(films: [Datum], forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(films) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}

extension FilmInteractorImpl {
    private func encoder(filmInfo: [FilmsInfo], forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(filmInfo) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}

extension FilmInteractorImpl {
    private func encoder(filmInfo: FilmsInfo, forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(filmInfo) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}

// MARK - Films Save
extension FilmInteractorImpl {
    private func saveFilms(state: Binding<AppState.AppData>) {
        encoder(films: state.film.films.wrappedValue, forKey: "FilmsData")
    }
    
    private func saveFilmsVideoHistory(state: Binding<AppState.AppData>) {
        encoder(films: state.film.filmsVideoHistory.wrappedValue, forKey: "FilmsVideoHistory")
    }
    
    private func saveFilmsHistory(state: Binding<AppState.AppData>) {
        encoder(filmInfo: state.film.filmsHistory.wrappedValue, forKey: "FilmsHistory")
    }
    
    private func saveFilmInfo(state: Binding<AppState.AppData>) {
        encoder(filmInfo: state.film.filmInfo.wrappedValue, forKey: "FilmInfo")
    }
}
