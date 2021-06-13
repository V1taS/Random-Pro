//
//  TravelMiddleContentCellView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct TravelMiddleContentCellView: View {
    
    let leftTitle: String
    let leftValue: String
    
    let rightTitle: String
    let rightValue: String

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 4){
                    Text(leftTitle)
                        .font(UIScreen.screenHeight < 700 ? .robotoMedium10() : .robotoMedium14())
                        .lineLimit(1)
                        .foregroundColor(.primaryInactive())
                    
                    Text(leftValue)
                        .font(UIScreen.screenHeight < 700 ? .robotoMedium14() : .robotoMedium20())
                        .lineLimit(1)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4){
                    Text(rightTitle)
                        .font(UIScreen.screenHeight < 700 ? .robotoMedium10() : .robotoMedium14())
                        .lineLimit(1)
                        .foregroundColor(.primaryInactive())
                    
                    Text(rightValue)
                        .font(UIScreen.screenHeight < 700 ? .robotoMedium14() : .robotoMedium20())
                        .lineLimit(1)
                        .foregroundColor(.black)
                }
            }
            .padding(.horizontal, 24)
            
            Divider()
                .padding(.horizontal, 24)
                .padding(.top, 4)
        }
    }
}

struct TravelMiddleContentCellView_Previews: PreviewProvider {
    static var previews: some View {
        TravelMiddleContentCellView(leftTitle: "СТРАНА",
                                    leftValue: "Россия",
                                    rightTitle: "ДЛИТЕЛЬНОСТЬ",
                                    rightValue: "7 ночей")
    }
}
