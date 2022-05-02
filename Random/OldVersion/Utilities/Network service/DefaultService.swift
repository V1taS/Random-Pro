//
//  DefaultService.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

protocol Service: AnyObject {
    func videoCDN(year: Int, limit: Int, _ completion: ((RemoteServiceResult<VideoCDNResult>) -> Void)?)
    func getInfoKinopoisk(kinopoiskID: String, _ completion: ((RemoteServiceResult<KinopoiskInfoResult>) -> Void)?)
    func getKinopoiskBestFilms(page: Int, _ completion: ((RemoteServiceResult<KinopoiskBestFilmsResult>) -> Void)?)
    func getKinopoiskPopularFilms(page: Int, _ completion: ((RemoteServiceResult<KinopoiskBestFilmsResult>) -> Void)?)
    func searchMovies(kinopoiskId: String, _ completion: ((RemoteServiceResult<VideoCDNResult>) -> Void)?)
    func getHotTravel(startDate: String, endDate: String, _ completion: ((RemoteServiceResult<HotTravelResult>) -> Void)?)
}

final class DefaultService {
    
    private let requestPerformer: NetworkRequestPerformer
    private var requestResultMapper = CodableResultMapper()
    
    init(_ requestPerformer: NetworkRequestPerformer) {
        self.requestPerformer = requestPerformer
    }
}

extension DefaultService: Service {
    
    func getHotTravel(startDate: String, endDate: String, _ completion: ((RemoteServiceResult<HotTravelResult>) -> Void)?) {
        let apiCall = DefaultAPICall(requestPerformer)
        apiCall.perform(HotTravelRequest(startDate: startDate, endDate: endDate)) { result in
            let mappedResult: RemoteServiceResult<HotTravelResult> = self.requestResultMapper.map(result)
            completion?(mappedResult)
        }
    }
    
    
    func searchMovies(kinopoiskId: String, _ completion: ((RemoteServiceResult<VideoCDNResult>) -> Void)?) {
        let apiCall = DefaultAPICall(requestPerformer)
        apiCall.perform(SearchMoviesRequest(kinopoiskId: kinopoiskId)) { result in
            let mappedResult: RemoteServiceResult<VideoCDNResult> = self.requestResultMapper.map(result)
            completion?(mappedResult)
        }
    }
    
    
    func getKinopoiskPopularFilms(page: Int, _ completion: ((RemoteServiceResult<KinopoiskBestFilmsResult>) -> Void)?) {
        let apiCall = DefaultAPICall(requestPerformer)
        apiCall.perform(KinopoiskPopularFilmsRequest(page: page)) { result in
            let mappedResult: RemoteServiceResult<KinopoiskBestFilmsResult> = self.requestResultMapper.map(result)
            completion?(mappedResult)
        }
    }
    
    func getKinopoiskBestFilms(page: Int, _ completion: ((RemoteServiceResult<KinopoiskBestFilmsResult>) -> Void)?) {
        let apiCall = DefaultAPICall(requestPerformer)
        apiCall.perform(KinopoiskBestFilmsRequest(page: page)) { result in
            let mappedResult: RemoteServiceResult<KinopoiskBestFilmsResult> = self.requestResultMapper.map(result)
            completion?(mappedResult)
        }
    }
    
    func getInfoKinopoisk(kinopoiskID: String, _ completion: ((RemoteServiceResult<KinopoiskInfoResult>) -> Void)?) {
        let apiCall = DefaultAPICall(requestPerformer)
        apiCall.perform(KinopoiskInfoRequest(kinopoiskID: kinopoiskID)) { result in
            let mappedResult: RemoteServiceResult<KinopoiskInfoResult> = self.requestResultMapper.map(result)
            completion?(mappedResult)
        }
    }
    
    func videoCDN(year: Int, limit: Int, _ completion: ((RemoteServiceResult<VideoCDNResult>) -> Void)?) {
        let apiCall = DefaultAPICall(requestPerformer)
        apiCall.perform(VideoCDNRequest(year: year, limit: limit)) { result in
            let mappedResult: RemoteServiceResult<VideoCDNResult> = self.requestResultMapper.map(result)
            completion?(mappedResult)
        }
    }
}
