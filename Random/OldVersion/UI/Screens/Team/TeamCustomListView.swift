//
//  TeamCustomListView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct TeamCustomListView: View {
    private var appBinding: Binding<AppState.AppData>
    private let playersService = PlayersService()
    @State
    private var isSentDataToCloud = false
    @State private var isPressedButton = false
    
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    @State
    var listResult: [Player] = []
    
    var body: some View {
        VStack {
            listResults
            deleteAllPlayers
        }
        .onDisappear(perform: {
            if isSentDataToCloud {
                DispatchQueue.global(qos: .background).async {
                    playersService.deleteAllPlayers {
                        listResult.forEach {
                            playersService.addPlayer(
                                id: $0.id,
                                name: $0.name,
                                photo: $0.photo,
                                team: $0.team
                            )
                        }
                    }
                }
            }
        })
        .onAppear {
            listResult = appBinding.team.listPlayersData.wrappedValue
        }
        .navigationBarTitle(Text(NSLocalizedString("Список", comment: "")), displayMode: .inline)
    }
}

private extension TeamCustomListView {
    var deleteAllPlayers: some View {
        VStack {
            if !listResult.isEmpty {
                HStack {
                    Spacer()
                    Text(NSLocalizedString("Удалить добавленных игроков", comment: ""))
                        .font(.robotoRegular16())
                        .foregroundColor(.primaryError())
                        .opacity(isPressedButton ? 0.8 : 1)
                        .scaleEffect(isPressedButton ? 0.8 : 1)
                        .animation(.easeInOut(duration: 0.2), value: isPressedButton)
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.bottom, 16)
                .background(Color.white)
                .onTapGesture {
                    appBinding.team.listPlayersData.wrappedValue = []
                    saveTeamToUserDefaults(state: appBinding)
                    listResult = []
                    Feedback.shared.impactHeavy(.medium)
                    DispatchQueue.global(qos: .background).async {
                        playersService.deleteAllPlayers {
                            print("Deleted")
                        }
                    }
                }.pressAction {
                    isPressedButton = true
                } onRelease: {
                    isPressedButton = false
                }
            }
        }
    }
}

private extension TeamCustomListView {
    var listResults: some View {
        List {
            ForEach(listResult, id: \.id) { player in
                
                HStack(spacing: 16) {
                    Image("\(player.photo)")
                        .resizable()
                        .frame(width: 60, height: 60)
                    
                    Text("\(player.name)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    Spacer()
                    
                    if player.team == "DNP" {
                        Text(NSLocalizedString("Не играет", comment: ""))
                            .foregroundColor(.blue)
                            .font(.robotoMedium18())
                    } else if player.team != "" {
                        VStack(alignment: .center, spacing: 8) {
                            Text(NSLocalizedString("Команда", comment: ""))
                                .foregroundColor(.blue)
                                .font(.robotoMedium14())
                            
                            Text("\(player.team)")
                                .foregroundColor(.blue)
                                .font(.robotoMedium18())
                        }
                    }
                }
                .contextMenu(ContextMenu {
                    Button("Random") {
                        let players = clearTeamForPlayer(playerId: player.id)
                        appBinding.team.listPlayersData.wrappedValue = players
                        appBinding.team.listTempPlayers.wrappedValue = players
                        listResult = players
                        isSentDataToCloud = true
                    }
                    
                    ForEach(.zero..<appBinding.team.selectedTeam.wrappedValue + 1) { selectedTeamIndex in
                        let selectedTeam = selectedTeamIndex + 1
                        
                        Button("\(NSLocalizedString("Команда", comment: "")) - \(selectedTeam)") {
                            let players = setTeamForPlayer(playerId: player.id, team: "\(selectedTeam)")
                            appBinding.team.listPlayersData.wrappedValue = players
                            appBinding.team.listTempPlayers.wrappedValue = players
                            listResult = players
                            isSentDataToCloud = true
                        }
                        
                    }
                    
                    Button(NSLocalizedString("Не играет", comment: "")) {
                        let players = setTeamForPlayer(playerId: player.id, team: "DNP")
                        appBinding.team.listPlayersData.wrappedValue = players
                        appBinding.team.listTempPlayers.wrappedValue = players
                        listResult = players
                        isSentDataToCloud = true
                    }
                })
            } .onDelete(perform: { indexSet in
                listResult.remove(atOffsets: indexSet)
                appBinding.team.listPlayersData.wrappedValue.remove(atOffsets: indexSet)
                appBinding.team.listTempPlayers.wrappedValue = listResult
                saveTeamToUserDefaults(state: appBinding)
                isSentDataToCloud = true
            })
            
        }
    }
}


private extension TeamCustomListView {
    private func saveTeamToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.teamInteractor
            .saveTeamToUserDefaults(state: state)
    }
}

private extension TeamCustomListView {
    func setTeamForPlayer(playerId: String, team: String) -> [Player] {
        let players = appBinding.team.listPlayersData.wrappedValue
        var newPlayers: [Player] = []
        
        players.forEach { player in
            var player = player
            if player.id == playerId {
                player.team = team
            }
            newPlayers.append(player)
        }
        return newPlayers
    }
    
    func clearTeamForPlayer(playerId: String) -> [Player] {
        let players = appBinding.team.listPlayersData.wrappedValue
        var newPlayers: [Player] = []
        
        players.forEach { player in
            var player = player
            if player.id == playerId {
                player.team = ""
            }
            newPlayers.append(player)
        }
        return newPlayers
    }
}

struct TeamCustomListView_Previews: PreviewProvider {
    static var previews: some View {
        TeamCustomListView(appBinding: .constant(.init()))
    }
}
