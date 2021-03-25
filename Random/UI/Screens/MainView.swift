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
    private let columns = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 3
    
    var body: some View {
        NavigationView {
            makeGrid()
                .onAppear {
                    userDefaultsGet(state: appBinding)
                }
                .navigationBarTitle(Text("Random"))
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: Cell menu
private extension MainView {
    private func arrView() -> [String: AnyView] {
        return ["Фильмы": AnyView(film),
                "Команды": AnyView(team),
                "Число": AnyView(number),
                "Да или Нет": AnyView(yesOrNot),
                "Буква": AnyView(characters),
                "Список": AnyView(listWords),
                "Монета": AnyView(coin),
                "Кубики": AnyView(cube),
                "Дата и время": AnyView(dateAndTime),
                "Лотерея": AnyView(lottery),
                "Контакт": AnyView(contact),
                "Музыка": AnyView(music)
        ]
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
                         title: NSLocalizedString("Путешествие",
                                                  comment: ""))
        }
    }
}

// MARK: Music
private extension MainView {
    var music: some View {
        NavigationLink(
            destination: MusicView(appBinding: appBinding)) {
            CellMainView(image: "tv.music.note",
                         title: NSLocalizedString("Музыка",
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

private extension MainView {
    private func makeGrid() -> some View {
        let count = appBinding.main.storeCellMenu.wrappedValue.count
        let rows = count / columns + (count % columns == 0 ? 0 : 1)
        
        return ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(0..<rows) { row in
                    HStack(alignment: .center, spacing: 16) {
                        ForEach(0..<self.columns) { column -> AnyView in
                            let index = row * self.columns + column
                            if index < count {
                                let arrAnyViewCell = arrView()
                                let elementStore = appBinding.main.storeCellMenu.wrappedValue[index]
                                let view = arrAnyViewCell[elementStore]
                                return AnyView(view)
                            } else {
                                return AnyView(EmptyView())
                            }
                        }
                    }
                }
            } .frame(maxWidth: .infinity)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(appBinding: .constant(.init()))
    }
}
