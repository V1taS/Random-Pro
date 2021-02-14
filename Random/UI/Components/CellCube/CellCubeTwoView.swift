//
//  CellCubeTwoView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CellCubeTwoView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 100),
                       height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 100))
                .background(LinearGradient(gradient: Gradient(colors: [Color.primaryTertiary(), Color.primaryGreen()]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.clear)))
                .foregroundColor(.clear)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Circle()
                        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 20),
                               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 20))
                    Spacer()
                }
                .padding(.top, 14)
                .padding(.leading, 14)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Circle()
                        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 20),
                               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 20))
                }
                .padding(.bottom, 14)
                .padding(.trailing, 14)

            }
        }
        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 100),
               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 100))
    }
}

struct CellCubeTwoView_Previews: PreviewProvider {
    static var previews: some View {
        CellCubeTwoView()
    }
}
