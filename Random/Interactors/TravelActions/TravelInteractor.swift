//
//  TravelInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.05.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI

protocol TravelInteractor {
    func getTravel(state: Binding<AppState.AppData>)
    func getCurrentTravel(state: Binding<AppState.AppData>)
    func cleanTravel(state: Binding<AppState.AppData>)
    func saveTravelToUserDefaults(state: Binding<AppState.AppData>)
}

struct TravelInteractorImpl: TravelInteractor {
    
    func getTravel(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
            getTravelRussia(state: state)
        }
    }
    
    func getCurrentTravel(state: Binding<AppState.AppData>) {
        switch state.travel.selectedPlace.wrappedValue {
        case 0:
            if !state.travel.travelRussiaData.wrappedValue.isEmpty {
                let tour = state.travel.travelRussiaData.wrappedValue.first
                state.travel.travelRussiaInfo.wrappedValue = tour!
                state.travel.travelRussiaHistory.wrappedValue.append(tour!)
                state.travel.travelRussiaData.wrappedValue.removeFirst()
            }
        case 1: print("2")
        case 2: print("3")
        case 3: print("4")
        default: print("5")
        }
    }
    
    func cleanTravel(state: Binding<AppState.AppData>) {
        state.travel.travelRussiaData.wrappedValue = []
        state.travel.travelRussiaHistory.wrappedValue = []
        state.travel.travelRussiaInfo.wrappedValue = HotTravelResult.plug
    }
    
    func saveTravelToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.global(qos: .background).async {
            
        }
    }
}

//MARK: - Get Travel Russia
extension TravelInteractorImpl {
    private func getTravelRussia(state: Binding<AppState.AppData>) {
        
        if state.travel.travelRussiaData.wrappedValue.count == 0 || state.travel.travelRussiaData.wrappedValue.count == 1 {
            
            state.travel.showActivityIndicator.wrappedValue = true
            
            Networking.share.getHotTravel(startDate: "14.06.2021", endDate: "20.06.2021") { tours in
                
                guard let tours = tours.hot_tours else { return }
                let toursShuffled = tours.shuffled()

                state.travel.travelRussiaData.wrappedValue = toursShuffled
                state.travel.showActivityIndicator.wrappedValue = false
            }
        }
    }
}
