//
//  Networking.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 28.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import UIKit

class Networking {
    
    static let share = Networking()
    
    private init() {}
    
    func getMovies(completion: @escaping (Films) -> Void) {
        var request = URLRequest(url: URL(string: GlobalVars.urlString + "movies" + GlobalVars.token)!)
        request.httpMethod = "GET"
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let data = data else { return }
            do {
                let films = try JSONDecoder().decode(Films.self, from: data)
                DispatchQueue.main.async {
                    completion(films)
                }
                
            } catch {
                print("error: ", error)
            }
        }.resume()
    }
    
    func downloadedImageFilm(from url: URL, completion: @escaping (UIImage) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
}

