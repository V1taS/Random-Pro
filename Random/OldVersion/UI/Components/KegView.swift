//
//  KegView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct KegView: View {
    
    let number: String
    let id = UUID().uuidString
    @Binding var rotation: Double
    
    var body: some View {
        
        ZStack {
            Image("keg")
                .resizable()
                .frame(width: 70, height: 100, alignment: .center)
            
            Text(number)
                .gradientForeground(colors: [Color.black, Color.black]).opacity(0.45)
                .lineLimit(1)
                .font(.robotoBold25())
                .offset(x: -2, y: -25)
            
            
        }
        .rotationEffect(.degrees(rotation))
    }
}

struct KegView_Previews: PreviewProvider {
    static var previews: some View {
        KegView(number: "66.", rotation: .constant(1))
    }
}
