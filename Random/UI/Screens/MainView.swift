//
//  MainView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct MainView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                
                VStack(alignment: .center, spacing: 16) {
                    HStack {
                        NavigationLink(
                            destination: NumberView(appBinding: appBinding)) {
                            CellMainView(image: "number",
                                         title: NSLocalizedString("Число", comment: ""))
                        }
                        
                        NavigationLink(
                            destination: YesOrNotView(appBinding: appBinding)) {
                            CellMainView(image: "questionmark.square",
                                         title: NSLocalizedString("Да или Нет", comment: ""))
                        }
                    }
                    
                    HStack {
                        NavigationLink(
                            destination: CharactersView(appBinding: appBinding)) {
                            CellMainView(image: "textbox",
                                         title: NSLocalizedString("Буква", comment: ""))
                        }
                        
                        NavigationLink(
                            destination: ListWordsView(appBinding: appBinding)) {
                            CellMainView(image: "list.bullet.below.rectangle",
                                         title: NSLocalizedString("Список", comment: ""))
                        }
                    }
                    
                    HStack {
                        NavigationLink(
                            destination: CoinView(appBinding: appBinding)) {
                            CellMainView(image: "bitcoinsign.circle",
                                         title: NSLocalizedString("Монета", comment: ""))
                        }
                        
                        NavigationLink(
                            destination: CubeView(appBinding: appBinding)) {
                            CellMainView(image: "cube",
                                         title: NSLocalizedString("Кубики", comment: ""))
                        }
                    }
                    
                    HStack {
                        NavigationLink(
                            destination: DateAndTimeView(appBinding: appBinding)) {
                            CellMainView(image: "calendar",
                                         title: NSLocalizedString("Дата и время",
                                                                  comment: ""))
                        }
                        
                        NavigationLink(
                            destination: LotteryView(appBinding: appBinding)) {
                            CellMainView(image: "tag",
                                         title: NSLocalizedString("Лотерея",
                                                                  comment: ""))
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                
            }
            .onAppear {
                userDefaultsGet(state: appBinding)
            }
            .navigationBarTitle(Text("Random"))
        }
    }
}

// MARK: Actions
private extension MainView {
    private func userDefaultsGet(state: Binding<AppState.AppData>) {
        injected.interactors.mainInteractor.userDefaultsGet(state: state)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(appBinding: .constant(.init()))
    }
}
