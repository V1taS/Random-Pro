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
            VStack(alignment: .center, spacing: 4) {
                Text("?")
                    .lineLimit(2)
                    .font(.robotoBold70())
                    .foregroundColor(.primaryGray())
                    .frame(width: 100)
            }
        }
        .frame(width: 100, height: 160)
    }
}

struct PlayerPlugView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerPlugView()
    }
}
