//
//  AppleMusicAPI.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation
import StoreKit

class AppleMusicAPI {
    
    private let developerToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJFUzI1NiIsImtpZCI6IlBBV0hYV1k2NDYifQ.eyJpc3MiOiIzNFZEU1BaWVU5IiwiZXhwIjoxNjMxNzAwOTA5LCJpYXQiOjE2MTU5MzI5MDl9.k0Pc48z7qdIbS0Bd7XNb08PPbGMdDG3wdSZzh9rbd-gi69RksTn9WDP9jognJ1-vi7F16g2geSMNQAO1ZW2_0w"
    
    static let share = AppleMusicAPI()
    private init() {}
    
    func cheakUserToken(completion: @escaping (Bool) -> Void) {
        SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { (_, error) in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func getUserToken() -> String? {
        var userToken: String? = nil
        // Остановка потока до тех пор, пока не будет передано конкретное сообщение
        let lock = DispatchSemaphore(value: 0)
        // Аутентифицируем пользователя в персонализированных запросах Apple Music API.
        SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken) { (receivedToken, error) in
            guard error == nil else { return }
            if let token = receivedToken {
                userToken = token
                lock.signal()
            }
        }
        
        // Говорит коду, чтобы он прекратил выполнение любого дальнейшего кода, пока не будет дан сигнал
        lock.wait()
        return userToken
    }
    
    func fetchStorefrontID() -> String {
        // Семафор отправки, вызываемый, lockчтобы гарантировать, что функция возвращает a storefrontIDтолько после того, как данные были получены из нашего URL-запроса.
        let lock = DispatchSemaphore(value: 0)
        var storefrontID = String()
        let musicURL = URL(string: "https://api.music.apple.com/v1/me/storefront")!
        var musicRequest = URLRequest(url: musicURL)
        musicRequest.httpMethod = "GET"
        musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        
        musicRequest.addValue(getUserToken() ?? "", forHTTPHeaderField: "Music-User-Token")

//        URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
//            guard error == nil else { return }
//            if let json = try? JSON(data: data!) {
//                guard let result = (json["data"]).array else {
////                    print("Подписки Apple music - нет")
//                    return
//                }
//                guard let id = (result[0].dictionaryValue)["id"] else {
////                    print("Подписки Apple music - нет")
//                    return
//                }
//                storefrontID = id.stringValue
//                lock.signal()
//            }
//        }.resume()
        
        // Просим семафор отправки подождать перед возвратом идентификатора.
        lock.wait()
        return storefrontID
    }
    
    func getChartsAppleMusic(limit: Int, offset: Int, completion: @escaping (MusicITunes) -> Void) {
        let musicURL = URL(string: "https://api.music.apple.com/v1/catalog/\(fetchStorefrontID())/charts?types=songs&limit=\(limit)&offset=\(offset)")!
        var musicRequest = URLRequest(url: musicURL)
        musicRequest.httpMethod = "GET"
        musicRequest.addValue("Bearer \(developerToken)", forHTTPHeaderField: "Authorization")
        
        musicRequest.addValue(getUserToken() ?? "", forHTTPHeaderField: "Music-User-Token")
        
        URLSession.shared.dataTask(with: musicRequest) { (data, response, error) in
            guard error == nil else { return }
            
            guard let data = data else { return }
            do {
                let music = try JSONDecoder().decode(MusicITunes.self, from: data)
                DispatchQueue.global(qos: .userInitiated).async {
                    completion(music)
                }
            } catch {
                print("error: ", error)
            }
        } .resume()
    }
}
