//
//  TravelInformationViewCell.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct TravelInformationViewCell: View {
    
    let leftText: String
    let rightText: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text(leftText)
                .foregroundColor(.primaryGray())
                .font(.robotoMedium18())
            
            Spacer()
            
            Text(rightText)
                .foregroundColor(.primaryGray())
                .font(.robotoRegular16())
        }
    }
}

struct TravelInformationViewCell_Previews: PreviewProvider {
    static var previews: some View {
        TravelInformationViewCell(leftText: "Страна", rightText: "Россия")
    }
}
