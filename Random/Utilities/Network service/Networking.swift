//
//  Networking.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import UIKit

class Networking {
    private let urlStringVideocdn: String = "https://videocdn.tv/api/"
    private let urlStringKinopoisk: String = "https://kinopoiskapiunofficial.tech/api/v2.1/films/"
    private let tokenVideocdn: String = "?api_token=VGstdXXDwaGDIM4Ec8ofDLcZnAaTsU0X"
    private let tokenKinopoisk: String = "f835989c-b489-4624-9209-6d93bfead535"

    static let share = Networking()
    
    private init() {}
    
    func getMovies(page: Int, limit: Int, completion: @escaping (Films) -> Void) {
        
        var request = URLRequest(url: URL(string: urlStringVideocdn + "movies" + tokenVideocdn + "&limit=\(limit)&page=\(page)")!)
        request.httpMethod = "GET"
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data else { return }
            do {
                let films = try JSONDecoder().decode(Films.self, from: data)
                completion(films)
            } catch {
                print("error: ", error)
            }
        }.resume()
    }
    
    func getInfoKinopoisk(films: [Datum], completion: @escaping (FilmsInfo) -> Void) {
        
        guard let film = films.first else { return }
        guard let kinopoiskID = film.kinopoiskID else { return }
        guard let url = URL(string: "\(urlStringKinopoisk)\(String(describing: kinopoiskID))") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("\(tokenKinopoisk)", forHTTPHeaderField: "X-API-KEY")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            do {
                let filmsInfo = try JSONDecoder().decode(FilmsInfo.self, from: data!)
                completion(filmsInfo)
            } catch {
                print("Decoding error:", error)
            }
        }.resume()
        
        
    }
}
