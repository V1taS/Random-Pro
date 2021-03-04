//
//  PlayerPlugView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct PlayerPlugView: View {
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Text("?")
                    .lineLimit(1)
                    .font(.robotoBold70())
                    .foregroundColor(.primaryGray())
                    .frame(width: 100)
            }
        }
        .frame(width: 100, height: 120)
    }
}

struct PlayerPlugView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerPlugView()
    }
}
