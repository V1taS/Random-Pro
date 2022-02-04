//
//  TeamView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct TeamView: View {
    
    private var appBinding: Binding<AppState.AppData>
    private var actionButton: (() -> Void)?
    private let playersService = PlayersService()
    
    init(appBinding: Binding<AppState.AppData>, actionButton: (() -> Void)?) {
        self.appBinding = appBinding
        self.actionButton = actionButton
    }
    @Environment(\.injected) private var injected: DIContainer
    @State var countTeam = ["1", "2", "3", "4", "5", "6"]
    @State var selectedTeam = 1
    @State private var isPressedButton = false
    @State private var isPressedButtonWhat = false
    
    var body: some View {
        VStack {
            header
            if appBinding.team.listResult1.wrappedValue.isEmpty {
                what
            } else {
                content
            }
            generateButton
        }
        
        .navigationBarTitle(Text(NSLocalizedString("Команды", comment: "")), displayMode: .inline)
        .navigationBarItems(trailing: HStack(spacing: 24) {
            Button(action: {
                appBinding.team.showAddPlayer.wrappedValue.toggle()
                generationImage(state: appBinding)
                appBinding.team.selectedTeam.wrappedValue = selectedTeam
            }) {
                Image(systemName: "person.badge.plus")
                    .font(.system(size: 24))
            }
            
            Button(action: {
                appBinding.team.showSettings.wrappedValue.toggle()
                appBinding.team.selectedTeam.wrappedValue = selectedTeam
            }) {
                Image(systemName: "gear")
                    .font(.system(size: 24))
            }
            .sheet(isPresented: appBinding.team.showSettings, content: {
                TeamSettingsView(appBinding: appBinding)
            })
        })
        .onAppear {
            selectedTeam = appBinding.team.selectedTeam.wrappedValue
            
            if appBinding.team.listPlayersData.wrappedValue.isEmpty {
                playersService.fetchPlayers { playersCloud in
                    let players = playersCloud.map {
                        Player(
                            id: $0.id,
                            name: $0.name,
                            photo: $0.photo,
                            team: $0.team
                        )
                    }
                    appBinding.team.listPlayersData.wrappedValue = players
                }
            }
        }
    }
}

private extension TeamView {
    var header: some View {
        VStack {
            Picker(selection: $selectedTeam,
                   label: Text("Picker")) {
                ForEach(0..<countTeam.count) {
                    Text("\(countTeam[$0])")
                }
            }
                   .disabled(appBinding.team.disabledPickerView.wrappedValue)
                   .pickerStyle(SegmentedPickerStyle())
                   .padding(.horizontal, 16)
        }
        .padding(.top, 16)
    }
}

private extension TeamView {
    var what: some View {
        VStack {
            Spacer()
            
            Button(action: {
                if !appBinding.team.listTempPlayers.wrappedValue.isEmpty {
                    generateListTeams(state: appBinding)
                    appBinding.team.disabledPickerView.wrappedValue = true
                    Feedback.shared.impactHeavy(.medium)
                }
                appBinding.team.selectedTeam.wrappedValue = selectedTeam
            }) {
                Text("?")
                    .font(.robotoBold70())
                    .foregroundColor(.primaryGray())
                    .opacity(isPressedButtonWhat ? 0.8 : 1)
                    .scaleEffect(isPressedButtonWhat ? 0.8 : 1)
                    .animation(.easeInOut(duration: 0.2), value: isPressedButtonWhat)
            }
            .opacity(isPressedButtonWhat ? 0.8 : 1)
            .scaleEffect(isPressedButtonWhat ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.1))
            .pressAction {
                isPressedButtonWhat = true
            } onRelease: {
                isPressedButtonWhat = false
            }
            
            Spacer()
        }
    }
}

private extension TeamView {
    private var content: AnyView {
        switch appBinding.team.selectedTeam.wrappedValue + 1 {
        case 1:
            return AnyView(teamOne)
        case 2:
            return AnyView(teamTwo)
        case 3:
            return AnyView(teamThree)
        case 4:
            return AnyView(teamFour)
        case 5:
            return AnyView(teamFive)
        case 6:
            return AnyView(teamSix)
        default:
            return AnyView(what)
        }
    }
}

private extension TeamView {
    var teamOne: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult1,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 1)
                Spacer()
            }
            .padding(.top)
        }
    }
}

private extension TeamView {
    var teamTwo: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult1,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 1)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult2,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 2)
                Spacer()
            }
            .padding(.top)
        }
    }
}

private extension TeamView {
    var teamThree: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult1,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 1)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult2,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 2)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult3,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 3)
                Spacer()
            }
            .padding(.top)
        }
    }
}

private extension TeamView {
    var teamFour: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult1,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 1)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult2,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 2)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult3,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 3)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult4,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 4)
                Spacer()
            }
            .padding(.top)
        }
    }
}

private extension TeamView {
    var teamFive: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult1,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 1)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult2,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 2)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult3,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 3)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult4,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 4)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult5,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 5)
                Spacer()
            }
            .padding(.top)
        }
    }
}

private extension TeamView {
    var teamSix: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack {
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult1,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 1)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult2,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 2)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult3,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 3)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult4,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 4)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult5,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 5)
                ScrollTeamPlayers(listPlayers: appBinding.team.listResult6,
                                  isPressedButton: $isPressedButton,
                                  teamNumber: 6)
                Spacer()
            }
            .padding(.top)
        }
    }
}

private extension TeamView {
    var generateButton: some View {
        Button(action: {
            if !appBinding.team.listTempPlayers.wrappedValue.isEmpty {
                appBinding.team.selectedTeam.wrappedValue = selectedTeam
                generateListTeams(state: appBinding)
                saveTeamToUserDefaults(state: appBinding)
                appBinding.team.disabledPickerView.wrappedValue = true
                Feedback.shared.impactHeavy(.medium)
                recordClick(state: appBinding)
            }
            actionButton?()
        }) {
            ButtonView(textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Сгенерировать", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .opacity(isPressedButton ? 0.8 : 1)
        .scaleEffect(isPressedButton ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.1))
        .pressAction {
            isPressedButton = true
        } onRelease: {
            isPressedButton = false
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
}

// MARK: Actions
private extension TeamView {
    private func generateListTeams(state: Binding<AppState.AppData>) {
        injected.interactors.teamInteractor
            .generateListTeams(state: state)
    }
}

private extension TeamView {
    private func saveTeamToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.teamInteractor
            .saveTeamToUserDefaults(state: state)
    }
}

private extension TeamView {
    func generationImage(state: Binding<AppState.AppData>) {
        appBinding.team
            .playerImageTemp.wrappedValue = injected.interactors
            .teamInteractor.generationImageRandom()
    }
}

// MARK: Record Click
private extension TeamView {
    private func recordClick(state: Binding<AppState.AppData>) {
        injected.interactors.mainInteractor.recordClick(state: state)
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView(appBinding: .constant(.init()), actionButton: nil)
    }
}
