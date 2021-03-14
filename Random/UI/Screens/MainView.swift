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
                device
            }
            .onAppear {
                userDefaultsGet(state: appBinding)
            }
            .navigationBarTitle(Text("Random"))
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: Device
private extension MainView {
    private var device: AnyView {
        switch UIDevice.current.userInterfaceIdiom == .phone {
        case true:
            return AnyView(listIPhone)
        case false:
            return AnyView(listIPad)
        }
    }
}

// MARK: List iPad
private extension MainView {
    var listIPad: some View {
        VStack(spacing: 16) {
            HStack {
                film
                Spacer()
                team
                Spacer()
                number
            }
            
            HStack {
                yesOrNot
                Spacer()
                characters
                Spacer()
                listWords
            }
            
            HStack {
                coin
                Spacer()
                cube
                Spacer()
                dateAndTime
            }
            
            HStack {
                lottery
                Spacer()
                contact
                Spacer()
                lottery.opacity(0)
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: List iPhone
private extension MainView {
    var listIPhone: some View {
        VStack(spacing: 12) {
            HStack {
                film
                Spacer()
                team
            }
            
            HStack {
                number
                Spacer()
                yesOrNot
            }
            
            HStack {
                characters
                Spacer()
                listWords
            }
            
            HStack {
                coin
                Spacer()
                cube
            }
            
            HStack {
                dateAndTime
                Spacer()
                lottery
            }
            
            HStack {
                contact
                Spacer()
                travel
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: Film
private extension MainView {
    var film: some View {
        NavigationLink(
            destination: FilmView(appBinding: appBinding)) {
            CellMainView(image: "film",
                         title: NSLocalizedString("Фильмы", comment: ""))
        }
    }
}

// MARK: Team
private extension MainView {
    var team: some View {
        NavigationLink(
            destination: TeamView(appBinding: appBinding)) {
            CellMainView(image: "person.3",
                         title: NSLocalizedString("Команды",
                                                  comment: ""))
        }
    }
}

// MARK: Number
private extension MainView {
    var number: some View {
        NavigationLink(
            destination: NumberView(appBinding: appBinding)) {
            CellMainView(image: "number",
                         title: NSLocalizedString("Число", comment: ""))
        }
    }
}

// MARK: YesOrNot
private extension MainView {
    var yesOrNot: some View {
        NavigationLink(
            destination: YesOrNotView(appBinding: appBinding)) {
            CellMainView(image: "questionmark.square",
                         title: NSLocalizedString("Да или Нет", comment: ""))
        }
    }
}

// MARK: Characters
private extension MainView {
    var characters: some View {
        NavigationLink(
            destination: CharactersView(appBinding: appBinding)) {
            CellMainView(image: "textbox",
                         title: NSLocalizedString("Буква", comment: ""))
        }
    }
}

// MARK: ListWords
private extension MainView {
    var listWords: some View {
        NavigationLink(
            destination: ListWordsView(appBinding: appBinding)) {
            CellMainView(image: "list.bullet.below.rectangle",
                         title: NSLocalizedString("Список", comment: ""))
        }
    }
}

// MARK: Coin
private extension MainView {
    var coin: some View {
        NavigationLink(
            destination: CoinView(appBinding: appBinding)) {
            CellMainView(image: "bitcoinsign.circle",
                         title: NSLocalizedString("Монета", comment: ""))
        }
    }
}

// MARK: Cube
private extension MainView {
    var cube: some View {
        NavigationLink(
            destination: CubeView(appBinding: appBinding)) {
            CellMainView(image: "cube",
                         title: NSLocalizedString("Кубики", comment: ""))
        }
    }
}

// MARK: DateAndTime
private extension MainView {
    var dateAndTime: some View {
        NavigationLink(
            destination: DateAndTimeView(appBinding: appBinding)) {
            CellMainView(image: "calendar",
                         title: NSLocalizedString("Дата и время",
                                                  comment: ""))
        }
    }
}

// MARK: Lottery
private extension MainView {
    var lottery: some View {
        NavigationLink(
            destination: LotteryView(appBinding: appBinding)) {
            CellMainView(image: "tag",
                         title: NSLocalizedString("Лотерея",
                                                  comment: ""))
        }
    }
}

// MARK: Travel
private extension MainView {
    var travel: some View {
        NavigationLink(
            destination: TravelView()) {
            CellMainView(image: "airplane",
                         title: NSLocalizedString("Travel",
                                                  comment: ""))
        }
    }
}

// MARK: Contact
private extension MainView {
    var contact: some View {
        NavigationLink(
            destination: ContactView(appBinding: appBinding)) {
            CellMainView(image: "phone.circle",
                         title: NSLocalizedString("Контакт",
                                                  comment: ""))
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
