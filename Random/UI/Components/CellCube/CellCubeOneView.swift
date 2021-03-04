//
//  CellCubeOneView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CellCubeOneView: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 100),
                       height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 100))
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))]), startPoint: .trailing, endPoint: .leading))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.clear)))
                .foregroundColor(.clear)
            
            VStack(alignment: .leading, spacing: 0) {
                    Circle()
                        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 20),
                               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 20))

            }
        }
        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 100),
               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 100))
    }
}

struct CellCubeView_Previews: PreviewProvider {
    static var previews: some View {
        CellCubeOneView()
    }
}
