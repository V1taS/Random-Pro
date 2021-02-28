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
}

struct FilmInteractorImpl: FilmInteractor {
    func getMovies(state: Binding<AppState.AppData>) {
        
        Networking.share.getMovies { films in
            let indexDataFilms = Int.random(in: 0...films.data.count - 1)
            
            if let framesFilms = getFramesFilms(indexDataFilms, films: films) {
                state.film.dataTemp.wrappedValue = framesFilms
            }
            
            
        }
    }
    
    func getCurrentFilm(indexData: Int, films: Films) {
        
    }
    
    
    
    
    
}

extension FilmInteractorImpl {
    private func getFramesFilms(_ indexDataFilms: Int, films: Films) -> FramesFilms? {
        let urlKinopoisk = URL(string: "https://kinopoiskapiunofficial.tech/api/v2.1/films/\(String(describing: films.data[indexDataFilms].kinopoiskID))/frames")!
        var request = URLRequest(url: urlKinopoisk)
        var framesFilms: FramesFilms?
        
        request.httpMethod = "GET"
        request.setValue("f835989c-b489-4624-9209-6d93bfead535", forHTTPHeaderField: "X-API-KEY")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request as URLRequest) { (data, _, _) in
            do {
                let filmImage = try JSONDecoder().decode(FramesFilms.self, from: data!)
                framesFilms = filmImage
            } catch {
                print("error: ", error)
            }
        }.resume()
        return framesFilms
    }
}
