//
//  TeamResultsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct TeamResultsView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    
    var body: some View {
        VStack {
            listResults
        }
        .navigationBarTitle(Text(NSLocalizedString("Результат генерации", comment: "")), displayMode: .inline)
    }
}

private extension TeamResultsView {
    var listResults: some View {
        List {
            
            if !appBinding.team.listResult1.wrappedValue.isEmpty {
                Section(header: Text(NSLocalizedString("Команда номер", comment: "") + " 1")) {
                    ForEach(appBinding.team.listResult1.wrappedValue, id: \.name) { player in
                        HStack(spacing: 16) {
                            Image("\(player.photo)")
                                .resizable()
                                .frame(width: 60, height: 60)
                            
                            Text("\(player.name)")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            Spacer()
                        }
                    }
                }
            }
            
            if !appBinding.team.listResult2.wrappedValue.isEmpty {
                Section(header: Text(NSLocalizedString("Команда номер", comment: "") + " 2")) {
                    ForEach(appBinding.team.listResult2.wrappedValue, id: \.name) { player in
                        HStack(spacing: 16) {
                            Image("\(player.photo)")
                                .resizable()
                                .frame(width: 60, height: 60)
                            
                            Text("\(player.name)")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            Spacer()
                        }
                    }
                }
            }
            
            if !appBinding.team.listResult3.wrappedValue.isEmpty {
                Section(header: Text(NSLocalizedString("Команда номер", comment: "") + " 3")) {
                    ForEach(appBinding.team.listResult3.wrappedValue, id: \.name) { player in
                        HStack(spacing: 16) {
                            Image("\(player.photo)")
                                .resizable()
                                .frame(width: 60, height: 60)
                            
                            Text("\(player.name)")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            Spacer()
                        }
                    }
                }
            }
            
            
            if !appBinding.team.listResult4.wrappedValue.isEmpty {
                Section(header: Text(NSLocalizedString("Команда номер", comment: "") + " 4")) {
                    ForEach(appBinding.team.listResult4.wrappedValue, id: \.name) { player in
                        HStack(spacing: 16) {
                            Image("\(player.photo)")
                                .resizable()
                                .frame(width: 60, height: 60)
                            
                            Text("\(player.name)")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            Spacer()
                        }
                    }
                }
            }
            
            if !appBinding.team.listResult5.wrappedValue.isEmpty {
                Section(header: Text(NSLocalizedString("Команда номер", comment: "") + " 5")) {
                    ForEach(appBinding.team.listResult5.wrappedValue, id: \.name) { player in
                        HStack(spacing: 16) {
                            Image("\(player.photo)")
                                .resizable()
                                .frame(width: 60, height: 60)
                            
                            Text("\(player.name)")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            Spacer()
                        }
                    }
                }
            }
            
            if !appBinding.team.listResult6.wrappedValue.isEmpty {
                Section(header: Text(NSLocalizedString("Команда номер", comment: "") + " 6")) {
                    ForEach(appBinding.team.listResult6.wrappedValue, id: \.name) { player in
                        HStack(spacing: 16) {
                            Image("\(player.photo)")
                                .resizable()
                                .frame(width: 60, height: 60)
                            
                            Text("\(player.name)")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            Spacer()
                        }
                    }
                }
            }
            
            
        }
    }
}

struct TeamResultsView_Previews: PreviewProvider {
    static var previews: some View {
        TeamResultsView(appBinding: .constant(.init()))
    }
}
