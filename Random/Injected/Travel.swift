//
//  Travel.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.05.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Foundation

extension AppState.AppData {
    struct Travel: Equatable, Decodable {
        
        var travelRussiaInfo = HotTravelResult.plug
        var travelRussiaData: [HotTravelResult.Data] = []
        var travelRussiaHistory: [HotTravelResult.Data] = []
        
        var showActivityIndicator = false
        
        var selectedPlace = 0
        var selectedDeparture = 0 {
            didSet {
                travelRussiaData = []
                travelRussiaInfo = HotTravelResult.plug
            }
        }
        var selectedStars = 0
        var selectedPansions = 0
        
        var countOfNight = ""
        var countAdults = "2"
        
        var costFrom = "" {
            didSet {
                let costFrom = costFrom.removingWhiteSpaces()
                guard let costFrom = Double(costFrom) else { return}
                self.costFrom = String.formatted(with: .decimal, value: NSNumber(value: costFrom))
            }
        }
        var costUpTo = "" {
            didSet {
                let costFrom = costUpTo.removingWhiteSpaces()
                guard let costFrom = Double(costFrom) else { return}
                self.costUpTo = String.formatted(with: .decimal, value: NSNumber(value: costFrom))
            }
        }
        
        var priceNum: Double = 100000

        var showSettings = false
    }
}
