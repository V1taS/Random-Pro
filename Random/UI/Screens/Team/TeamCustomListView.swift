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
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    @State var listResult: [Player] = []
    
    var body: some View {
        VStack {
            listResults
        }
        .onAppear {
            listResult = appBinding.team.listPlayersData.wrappedValue
        }
        .keyboardAware()
        .dismissingKeyboard()
        .navigationBarTitle(Text(NSLocalizedString("Список", comment: "")), displayMode: .inline)
    }
}

private extension TeamCustomListView {
    var listResults: some View {
        List {
            ForEach(listResult, id: \.name) { player in
                
                HStack(spacing: 16) {
                    Image("\(player.photo)")
                        .resizable()
                        .frame(width: 60, height: 60)
                    
                    Text("\(player.name)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    Spacer()
                }
            } .onDelete(perform: { indexSet in
                listResult.remove(atOffsets: indexSet)
                appBinding.team.listPlayersData.wrappedValue.remove(atOffsets: indexSet)
            })
            
        }
    }
}


private extension TeamCustomListView {
    private func saveListWordsToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.listWordsInteractor
            .saveListWordsToUserDefaults(state: state)
    }
}

struct TeamCustomListView_Previews: PreviewProvider {
    static var previews: some View {
        TeamCustomListView(appBinding: .constant(.init()))
    }
}
