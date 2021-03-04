//
//  PlayerView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct PlayerView: View {
    
    let name: String
    let image: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .center, spacing: 4) {
                Image(image)
                    .resizable()
                    .frame(width: 70, height: 70, alignment: .center)
                
                Text(name)
                    .lineLimit(2)
                    .font(.robotoMedium16())
                    .foregroundColor(.primaryGray())
                    .multilineTextAlignment(.center)
                    .frame(width: 100)
            }
        }
        .frame(width: 100, height: 120)
//        .background(Color.blue)
    }
}

struct Player_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView(name: "Кожевников Евгений", image: "player2")
    }
}
