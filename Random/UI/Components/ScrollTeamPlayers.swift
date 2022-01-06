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
    @Binding var isPressedButton: Bool
    let teamNumber: Int
    
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(NSLocalizedString("Команда номер", comment: "") + " \(teamNumber)")
                    .foregroundColor(.primaryGray())
                    .font(.robotoMedium20())
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
                    ForEach(Array(listPlayers.enumerated()), id: \.0) { (index, player) in
                        if index == 0 {
                            PlayerView(name: player.name, image: player.photo)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.primaryTertiary(), Color.primaryGreen()]), startPoint: .top, endPoint: .bottom).opacity(0.1))
                                .cornerRadius(12)
                        } else {
                            PlayerView(name: player.name, image: player.photo)
                                .background(LinearGradient(gradient: Gradient(colors: [Color.gray, Color.gray]), startPoint: .top, endPoint: .bottom).opacity(0.1))
                                .cornerRadius(12)
                        }
                    }
                    .padding(.leading, 16)
                }
            }
        }
    }
}

struct ScrollTeamPlayers_Previews: PreviewProvider {
    static var previews: some View {
        ScrollTeamPlayers(listPlayers: .constant([Player(id: UUID().uuidString, name: "Сосин Виталий", photo: "player16"), Player(id: UUID().uuidString, name: "Трифонов Дмитрий", photo: "player24")]), isPressedButton: .constant(false),
                          teamNumber: 1)
    }
}
