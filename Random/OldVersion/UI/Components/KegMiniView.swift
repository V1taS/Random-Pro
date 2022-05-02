//
//  KegMiniView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 20.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct KegMiniView: View {
    
    let number: String
    let id = UUID().uuidString
    @Binding var rotation: Double
    
    var body: some View {
        
        ZStack {
            Image("keg")
                .resizable()
                .frame(width: 35, height: 50, alignment: .center)
            
            Text(number)
                .gradientForeground(colors: [Color.black, Color.black]).opacity(0.45)
                .lineLimit(1)
                .font(.robotoBold13())
                .offset(x: -1, y: -14)
            
            
        }
        .rotationEffect(.degrees(rotation))
    }
}

struct KegMiniView_Previews: PreviewProvider {
    static var previews: some View {
        KegMiniView(number: "22", rotation: .constant(1))
    }
}
