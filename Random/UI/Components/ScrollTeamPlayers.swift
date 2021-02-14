//
//  ScrollTeamPlayers.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct ScrollTeamPlayers: View {
    
    @Binding var listPlayers: [Player]
    let teamNumber: Int
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(NSLocalizedString("Команда номер", comment: "") + " \(teamNumber)")
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium28())
                Spacer()
            }
            .padding(.leading, 16)
            
            listResults
        }
    }
}

private extension ScrollTeamPlayers {
    var listResults: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            if listPlayers.isEmpty {
                HStack {
                    PlayerPlugView()
                        .padding(.leading, 16)
                }
            } else {
                HStack {
                    ForEach(listPlayers, id: \.name) { player in
                        PlayerView(name: player.name, image: player.photo)
                    }
                    .padding(.leading, 16)
                }
            }
        }
    }
}

struct ScrollTeamPlayers_Previews: PreviewProvider {
    static var previews: some View {
        ScrollTeamPlayers(listPlayers: .constant([Player(name: "Сосин Виталий", photo: "player1"), Player(name: "Трифонов Дмитрий", photo: "player2")]),
                          teamNumber: 1)
    }
}
