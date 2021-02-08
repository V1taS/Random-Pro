//
//  CellCubeView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CellCubeView: View {
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
                
                Spacer()
                
                HStack {

                    Spacer()

                }
                .padding(.bottom, 8)
                .padding(.horizontal, 16)
            }
        }
        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 100),
               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 100))
    }
}

struct CellCubeView_Previews: PreviewProvider {
    static var previews: some View {
        CellCubeView()
    }
}
