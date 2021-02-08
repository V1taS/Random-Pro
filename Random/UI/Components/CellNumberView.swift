//
//  CellNumberView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CellNumberView: View {
    
    private let value: String
    private let backgroundStart: Color
    private let backgroundFinish: Color
    private let borderColor: Color
    private let radius: CGFloat
    
    init(value: String,
         backgroundStart: Color,
         backgroundFinish: Color,
         borderColor: Color,
         radius: CGFloat) {
        self.value = value
        self.backgroundStart = backgroundStart
        self.backgroundFinish = backgroundFinish
        self.borderColor = borderColor
        self.radius = radius
    }
        
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 75, height: 75)
                .background(LinearGradient(gradient: Gradient(colors: [backgroundStart, backgroundFinish]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(radius)
                .overlay(RoundedRectangle(cornerRadius: radius)
                            .stroke(borderColor))
                .foregroundColor(.clear)
            
            VStack {
                Text(value)
                    .font(.robotoMedium28())
                    .foregroundColor(.primaryPale())
                    .frame(width: 67, height: 67)
            }
        }
        .frame(width: 75, height: 75)
    }
}

struct CellNumberView_Previews: PreviewProvider {
    static var previews: some View {
        CellNumberView(value: "10", backgroundStart: Color.primarySky(), backgroundFinish: Color.primaryBlue(), borderColor: Color.primaryDefault(), radius: 8)
    }
}
