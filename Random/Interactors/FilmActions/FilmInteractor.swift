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
}

struct FilmInteractorImpl: FilmInteractor {
    func getMovies(state: Binding<AppState.AppData>) {
        
        if state.film.steps.wrappedValue == .firstStart {
            let page = Int.random(in: 1...2968)
            
            state.film.showActivityIndicator.wrappedValue = true
            Networking.share.getMovies(page: page, limit: 10) { films in
                let films = films.data.shuffled()
                state.film.films.wrappedValue = films
                state.film.showActivityIndicator.wrappedValue = false
                state.film.steps.wrappedValue = .non
            }
        }
        
        if state.film.films.wrappedValue.count == 2 && !state.film.filmsHistory.wrappedValue.isEmpty {
            let page = Int.random(in: 1...2968)

            state.film.showActivityIndicator.wrappedValue = true
            Networking.share.getMovies(page: page, limit: 10) { films in
                let films = films.data.shuffled()
                state.film.films.wrappedValue.append(contentsOf: films)
                state.film.showActivityIndicator.wrappedValue = false
            }
        }
    }
    
    func getCurrentFilmInfo(state: Binding<AppState.AppData>) {
        if state.film.films.wrappedValue.first?.kinopoiskID == nil {
            state.film.films.wrappedValue.removeFirst()
        }
        
        Networking.share.getInfoKinopoisk(films: state.film.films.wrappedValue) { film in
            state.film.filmInfo.wrappedValue = film
            state.film.filmsHistory.wrappedValue.append(film)
            state.film.filmsVideoHistory.wrappedValue.append(state.film.films.wrappedValue.first!)
            if !state.film.films.wrappedValue.isEmpty {
                state.film.films.wrappedValue.removeFirst()
            }
        }
    }
}
