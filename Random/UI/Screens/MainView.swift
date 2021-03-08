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
                GridStack(minCellWidth: 300, spacing: 16, numItems: 15) { index, cellWidth in
                
                Text("\(index)")
                    .foregroundColor(.red)
                    .frame(width: cellWidth, height: cellWidth * 0.66)
                    .background(Color.blue)
                
//                ScrollView(.vertical, showsIndicators: false) {
//
//
//
//                    if UIDevice.current.userInterfaceIdiom == .pad {
//                        //                        iPad
//                    }
//                    else {
//                        //                        iPhone
//                    }
//                }
                .onAppear {
                    userDefaultsGet(state: appBinding)
                }
                .navigationBarTitle(Text("Random"))
            }
            
        } .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: iPAD
private extension MainView {
    var iPad: some View {
        VStack(alignment: .center, spacing: 16) {
            
            HStack {
                NavigationLink(
                    destination: FilmView(appBinding: appBinding)) {
                    CellMainView(image: "film",
                                 title: NSLocalizedString("Фильмы", comment: ""))
                }
                
                Spacer()
                
                NavigationLink(
                    destination: TeamView(appBinding: appBinding)) {
                    CellMainView(image: "person.3",
                                 title: NSLocalizedString("Команды",
                                                          comment: ""))
                }
                
                Spacer()
                
                NavigationLink(
                    destination: NumberView(appBinding: appBinding)) {
                    CellMainView(image: "number",
                                 title: NSLocalizedString("Число", comment: ""))
                }
            }
            
            HStack {
                NavigationLink(
                    destination: YesOrNotView(appBinding: appBinding)) {
                    CellMainView(image: "questionmark.square",
                                 title: NSLocalizedString("Да или Нет", comment: ""))
                }
                
                Spacer()
                
                NavigationLink(
                    destination: CharactersView(appBinding: appBinding)) {
                    CellMainView(image: "textbox",
                                 title: NSLocalizedString("Буква", comment: ""))
                }
                
                Spacer()
                
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
                
                Spacer()
                
                NavigationLink(
                    destination: CubeView(appBinding: appBinding)) {
                    CellMainView(image: "cube",
                                 title: NSLocalizedString("Кубики", comment: ""))
                }
                
                Spacer()
                
                NavigationLink(
                    destination: DateAndTimeView(appBinding: appBinding)) {
                    CellMainView(image: "calendar",
                                 title: NSLocalizedString("Дата и время",
                                                          comment: ""))
                }
            }
            
            HStack {
                NavigationLink(
                    destination: LotteryView(appBinding: appBinding)) {
                    CellMainView(image: "tag",
                                 title: NSLocalizedString("Лотерея",
                                                          comment: ""))
                }
                
                Spacer()
                
                NavigationLink(
                    destination: ContactView(appBinding: appBinding)) {
                    CellMainView(image: "phone.circle",
                                 title: NSLocalizedString("Контакт",
                                                          comment: ""))
                }
                
                Spacer()
                
                NavigationLink(
                    destination: ContactView(appBinding: appBinding)) {
                    CellMainView(image: "phone.circle",
                                 title: NSLocalizedString("Контакт",
                                                          comment: ""))
                }.opacity(0)
            }
            
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}

// MARK: iPhone
//private extension MainView {
//    var iPhone: some View {
//        VStack(alignment: .center, spacing: 16) {
//
//            HStack {
//                NavigationLink(
//                    destination: FilmView(appBinding: appBinding)) {
//                    CellMainView(image: "film",
//                                 title: NSLocalizedString("Фильмы", comment: ""))
//                }
//
//                Spacer()
//
//                NavigationLink(
//                    destination: TeamView(appBinding: appBinding)) {
//                    CellMainView(image: "person.3",
//                                 title: NSLocalizedString("Команды",
//                                                          comment: ""))
//                }
//            }
//
//            HStack {
//                NavigationLink(
//                    destination: NumberView(appBinding: appBinding)) {
//                    CellMainView(image: "number",
//                                 title: NSLocalizedString("Число", comment: ""))
//                }
//
//                Spacer()
//
//                NavigationLink(
//                    destination: YesOrNotView(appBinding: appBinding)) {
//                    CellMainView(image: "questionmark.square",
//                                 title: NSLocalizedString("Да или Нет", comment: ""))
//                }
//            }
//
//            HStack {
//                NavigationLink(
//                    destination: CharactersView(appBinding: appBinding)) {
//                    CellMainView(image: "textbox",
//                                 title: NSLocalizedString("Буква", comment: ""))
//                }
//
//                Spacer()
//
//                NavigationLink(
//                    destination: ListWordsView(appBinding: appBinding)) {
//                    CellMainView(image: "list.bullet.below.rectangle",
//                                 title: NSLocalizedString("Список", comment: ""))
//                }
//            }
//
//            HStack {
//                NavigationLink(
//                    destination: CoinView(appBinding: appBinding)) {
//                    CellMainView(image: "bitcoinsign.circle",
//                                 title: NSLocalizedString("Монета", comment: ""))
//                }
//
//                Spacer()
//
//                NavigationLink(
//                    destination: CubeView(appBinding: appBinding)) {
//                    CellMainView(image: "cube",
//                                 title: NSLocalizedString("Кубики", comment: ""))
//                }
//            }
//
//            HStack {
//                NavigationLink(
//                    destination: DateAndTimeView(appBinding: appBinding)) {
//                    CellMainView(image: "calendar",
//                                 title: NSLocalizedString("Дата и время",
//                                                          comment: ""))
//                }
//
//                Spacer()
//
//                NavigationLink(
//                    destination: LotteryView(appBinding: appBinding)) {
//                    CellMainView(image: "tag",
//                                 title: NSLocalizedString("Лотерея",
//                                                          comment: ""))
//                }
//            }
//
//            HStack {
//                NavigationLink(
//                    destination: ContactView(appBinding: appBinding)) {
//                    CellMainView(image: "phone.circle",
//                                 title: NSLocalizedString("Контакт",
//                                                          comment: ""))
//                }
//
//                Spacer()
//
//                NavigationLink(
//                    destination: ContactView(appBinding: appBinding)) {
//                    CellMainView(image: "phone.circle",
//                                 title: NSLocalizedString("Контакт",
//                                                          comment: ""))
//                }.opacity(0)
//            }
//
//            Spacer()
//        }
//        .padding(.horizontal, 20)
//    }
//}

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
