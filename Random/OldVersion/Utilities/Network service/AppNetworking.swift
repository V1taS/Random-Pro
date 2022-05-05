//
//  Networking.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

final class AppNetworking {
    
    let networkRequestPerformer = AppURLSessionRequestPerformer()
    let service: DefaultService
    static let share = AppNetworking()
    
    init() {
        self.service = DefaultService(networkRequestPerformer)
    }
    
    func getVideoCDN(year: Int, limit: Int, completion: @escaping (VideoCDNResult) -> Void) {
        service.videoCDN(year: year, limit: limit) { result in
            switch result {
            case .success(let films):
                DispatchQueue.main.async {
                    completion(films)
                }
            case .failure(let error): print(error)
            }
        }
    }
    
    func getInfoKinopoisk(films: [VideoCDNResult.Data], state: Binding<AppState.AppData>) {
        for film in films {
            guard let kinopoiskID = film.kinopoiskID else { continue }
            
            service.getInfoKinopoisk(kinopoiskID: kinopoiskID) { result in
                switch result {
                case .success(let film):
                    DispatchQueue.main.async {
                        state.film.filmsTemp.wrappedValue.append(film)
                    }
                case .failure(let error): print("getInfoKinopoisk \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    func getKinopoiskBestFilms(page: Int, completion: @escaping (KinopoiskBestFilmsResult) -> Void) {
        
        service.getKinopoiskBestFilms(page: page) { result in
            switch result {
            case .success(let bestFilms):
                DispatchQueue.main.async {
                    completion(bestFilms)
                }
            case .failure(let error): print("getKinopoiskBestFilms \(error.localizedDescription)")
            }
        }
    }
    
    func getKinopoiskPopularFilms(page: Int, completion: @escaping (KinopoiskBestFilmsResult) -> Void) {
        
        service.getKinopoiskPopularFilms(page: page) { result in
            switch result {
            case .success(let popularFilms):
                DispatchQueue.main.async {
                    completion(popularFilms)
                }
            case .failure(let error): print("getKinopoiskPopularFilms \(error.localizedDescription)")
            }
        }
    }
    
    func searchMoviesFor(idKinopoisk: String, completion: @escaping (VideoCDNResult) -> Void) {
        
        service.searchMovies(kinopoiskId: idKinopoisk) { result in
            switch result {
            case .success(let film):
                DispatchQueue.main.async {
                    completion(film)
                }
            case .failure(let error): print("searchMovies \(error)")
            }
        }
    }
    
    func getHotTravel(startDate: String, endDate: String, completion: @escaping (HotTravelResult) -> Void) {
        
        service.getHotTravel(startDate: startDate, endDate: endDate) { result in
            switch result {
            case .success(let trip):
                DispatchQueue.main.async {
                    completion(trip)
                }
            case .failure(let error): print(error)
            }
        }
    }
}
