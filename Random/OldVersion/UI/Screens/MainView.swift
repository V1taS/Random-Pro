//
//  MainView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

/// MainView
struct MainView: View {
    
    private var appBinding: Binding<AppState.AppData>
    private let nameMenu = AppActions.MainActions.MenuName.self
    private let storeManager: StoreManager
    private var actionButton: (() -> Void)?
    
    private let currentAppVersionListService = CurrentAppVersionListService()
    @State private var cloudAppVersion = ""
    private let appVersion = Bundle.main.appBuild
    
    init(appBinding: Binding<AppState.AppData>,
         actionButton: (() -> Void)?,
         storeManager: StoreManager) {
        self.appBinding = appBinding
        self.actionButton = actionButton
        self.storeManager = storeManager
    }
    @Environment(\.injected) private var injected: DIContainer
    private let columns = UIDevice.current.userInterfaceIdiom == .phone ? 2 : 3
    
    var body: some View {
        NavigationView {
            makeGrid()
                .onAppear {
                    userDefaultsGet(state: appBinding)
                    checkNewMenu()
                    currentAppVersionListService.fetchList { listCloud in
                        let list = listCloud.map { $0.element }
                        if let appVersion = list.first {
                            self.cloudAppVersion = appVersion
                        }
                    }
                }
                .navigationBarTitle(Text("Random"))
            
                .navigationBarItems(leading: Button(action: {
                    appBinding.main.presenSettingsView.wrappedValue = true
                }) {
                    Image(systemName: "gear")
                        .renderingMode(.template)
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                },
                                    trailing: HStack {
                    if !cloudAppVersion.isEmpty {
                        if cloudAppVersion != appVersion {
                            Button(action: {
                                Metrics.trackEvent(name: .updateApp)
                                openLink(url: "https://apps.apple.com/\(NSLocalizedString("домен", comment: ""))/app/random-pro/id1552813956")
                            }) {
                                Image(systemName: "arrow.clockwise.icloud")
                                    .renderingMode(.template)
                                    .font(.system(size: 24))
                                    .gradientForeground(colors: [.red, .primaryGray()])
                            }
                        }
                    }
                    
                    Button(action: {
                        if appBinding.premium.premiumIsEnabled.wrappedValue {
                            alertCrown()
                        } else {
                            appBinding.premium.presentingModal.wrappedValue = true
                        }
                    }) {
                        Image(systemName: "crown.fill")
                            .renderingMode(.template)
                            .font(.system(size: 24))
                            .gradientForeground(colors: setColorForCrown())
                    }
                })
        }
        .sheet(isPresented: appBinding.main.presenSettingsView, onDismiss: {}) {
            SettingsView(appBinding: appBinding, storeManager: storeManager)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: Cell menu
private extension MainView {
    private func setColorForCrown() -> [Color] {
        return appBinding.premium.premiumIsEnabled
            .wrappedValue ? [Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)), Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))] : [Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1))]
    }
}

// MARK: Cell menu
private extension MainView {
    private func arrView() -> [String: AnyView] {
        return [nameMenu.films.rawValue: AnyView(film),
                nameMenu.teams.rawValue: AnyView(team),
                nameMenu.number.rawValue: AnyView(number),
                nameMenu.yesOrNo.rawValue: AnyView(yesOrNot),
                nameMenu.character.rawValue: AnyView(characters),
                nameMenu.list.rawValue: AnyView(listWords),
                nameMenu.coin.rawValue: AnyView(coin),
                nameMenu.cube.rawValue: AnyView(cube),
                nameMenu.dateAndTime.rawValue: AnyView(dateAndTime),
                nameMenu.lottery.rawValue: AnyView(lottery),
                nameMenu.contact.rawValue: AnyView(contact),
                nameMenu.music.rawValue: AnyView(music),
                nameMenu.travel.rawValue: AnyView(travel),
                nameMenu.password.rawValue: AnyView(password),
                nameMenu.russianLotto.rawValue: AnyView(russianLotto)
        ]
    }
}

// MARK: Russian Lotto View
private extension MainView {
    var russianLotto: some View {
        NavigationLink(
            destination: RussianLottoView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "square.grid.4x3.fill",
                             title: NSLocalizedString("Русское Лото", comment: ""),
                             isLabelDisabled: false,
                             textLabel: NSLocalizedString("НОВОЕ", comment: ""))
            }
    }
}

// MARK: Password
private extension MainView {
    var password: some View {
        NavigationLink(
            destination: PasswordView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "wand.and.stars",
                             title: NSLocalizedString("Пароли", comment: ""),
                             isLabelDisabled: false,
                             textLabel: NSLocalizedString("НОВОЕ", comment: ""))
            }
    }
}

// MARK: Film
private extension MainView {
    var film: some View {
        NavigationLink(
            destination: FilmView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "film",
                             title: NSLocalizedString("Фильмы", comment: ""),
                             isLabelDisabled: false,
                             textLabel: NSLocalizedString("ХИТ", comment: ""))
            }
        //        VStack {
        //            if appBinding.premium.premiumIsEnabled.wrappedValue {
        //                NavigationLink(
        //                    destination: FilmView(appBinding: appBinding, actionButton: actionButton)) {
        //                        CellMainView(image: "film",
        //                                     title: NSLocalizedString("Фильмы", comment: ""),
        //                                     isLabelDisabled: false,
        //                                     textLabel: "PREMIUM")
        //                    }
        //            } else {
        //                CellMainLockView(image: "film",
        //                                 title: NSLocalizedString("Фильмы", comment: ""))
        //                    .onTapGesture {
        //                        alertLockCell(NSLocalizedString("Фильмы", comment: ""))
        //                    }
        //            }
        //        }
    }
}

// MARK: Team
private extension MainView {
    var team: some View {
        NavigationLink(
            destination: TeamView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "person.3",
                             title: NSLocalizedString("Команды",
                                                      comment: ""),
                             isLabelDisabled: false,
                             textLabel: NSLocalizedString("ХИТ", comment: ""))
            }
        //        VStack {
        //            if appBinding.premium.premiumIsEnabled.wrappedValue {
        //                NavigationLink(
        //                    destination: TeamView(appBinding: appBinding, actionButton: actionButton)) {
        //                        CellMainView(image: "person.3",
        //                                     title: NSLocalizedString("Команды",
        //                                                              comment: ""),
        //                                     isLabelDisabled: false,
        //                                     textLabel: "PREMIUM")
        //                    }
        //            } else {
        //                CellMainLockView(image: "person.3",
        //                                 title: NSLocalizedString("Команды", comment: ""))
        //                    .onTapGesture {
        //                        alertLockCell(NSLocalizedString("Команды", comment: ""))
        //                    }
        //            }
        //        }
        
    }
}

// MARK: Number
private extension MainView {
    var number: some View {
        NavigationLink(
            destination: NumberView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "number",
                             title: NSLocalizedString("Число", comment: ""),
                             isLabelDisabled: false,
                             textLabel: NSLocalizedString("ХИТ", comment: ""))
            }
    }
}

// MARK: YesOrNot
private extension MainView {
    var yesOrNot: some View {
        NavigationLink(
            destination: YesOrNotView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "questionmark.square",
                             title: NSLocalizedString("Да или Нет", comment: ""),
                             isLabelDisabled: true,
                             textLabel: "")
            }
    }
}

// MARK: Characters
private extension MainView {
    var characters: some View {
        NavigationLink(
            destination: CharactersView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "textbox",
                             title: NSLocalizedString("Буква", comment: ""),
                             isLabelDisabled: true,
                             textLabel: "")
            }
    }
}

// MARK: ListWords
private extension MainView {
    var listWords: some View {
        NavigationLink(
            destination: ListWordsView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "list.bullet.below.rectangle",
                             title: NSLocalizedString("Список", comment: ""),
                             isLabelDisabled: false,
                             textLabel: NSLocalizedString("ХИТ", comment: ""))
            }
    }
}

// MARK: Coin
private extension MainView {
    var coin: some View {
        NavigationLink(
            destination: CoinView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "bitcoinsign.circle",
                             title: NSLocalizedString("Монета", comment: ""),
                             isLabelDisabled: true,
                             textLabel: "")
            }
    }
}

// MARK: Cube
private extension MainView {
    var cube: some View {
        NavigationLink(
            destination: CubeView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "cube",
                             title: NSLocalizedString("Кубики", comment: ""),
                             isLabelDisabled: true,
                             textLabel: "")
            }
    }
}

// MARK: DateAndTime
private extension MainView {
    var dateAndTime: some View {
        NavigationLink(
            destination: DateAndTimeView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "calendar",
                             title: NSLocalizedString("Дата и время",
                                                      comment: ""),
                             isLabelDisabled: true,
                             textLabel: "")
            }
    }
}

// MARK: Lottery
private extension MainView {
    var lottery: some View {
        NavigationLink(
            destination: LotteryView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "tag",
                             title: NSLocalizedString("Лотерея",
                                                      comment: ""),
                             isLabelDisabled: true,
                             textLabel: "")
            }
    }
}

// MARK: Travel
private extension MainView {
    var travel: some View {
        NavigationLink(
            destination: TravelView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "airplane",
                             title: NSLocalizedString("Путешествие",
                                                      comment: ""),
                             isLabelDisabled: true,
                             textLabel: "PREMIUM")
            }
        //        VStack {
        //            if appBinding.premium.premiumIsEnabled.wrappedValue {
        //                NavigationLink(
        //                    destination: TravelView(appBinding: appBinding, actionButton: actionButton)) {
        //                        CellMainView(image: "airplane",
        //                                     title: NSLocalizedString("Путешествие",
        //                                                              comment: ""),
        //                                     isLabelDisabled: false,
        //                                     textLabel: "PREMIUM")
        //                    }
        //            } else {
        //                CellMainLockView(image: "airplane",
        //                                 title: NSLocalizedString("Путешествие", comment: ""))
        //                    .onTapGesture {
        //                        alertLockCell(NSLocalizedString("Путешествие", comment: ""))
        //                    }
        //            }
        //        }
        
    }
}

// MARK: Music
private extension MainView {
    var music: some View {
        NavigationLink(
            destination: MusicView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "tv.music.note",
                             title: NSLocalizedString("Музыка",
                                                      comment: ""),
                             isLabelDisabled: UserDefaults.standard.bool(forKey: "ManuMusicNew"),
                             textLabel: NSLocalizedString("НОВОЕ",
                                                          comment: ""))
            }
    }
}

// MARK: Contact
private extension MainView {
    var contact: some View {
        NavigationLink(
            destination: ContactView(appBinding: appBinding, actionButton: actionButton)) {
                CellMainView(image: "phone.circle",
                             title: NSLocalizedString("Контакт",
                                                      comment: ""),
                             isLabelDisabled: true,
                             textLabel: "")
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
    private func checkNewMenu() {
        let countOldCellMenu = appBinding.main.storeCellMenu.wrappedValue.count + appBinding.main.storeCellMenuHidden.wrappedValue.count
        
        let countNewCellMenu = AppActions.MainActions.MenuName.allCases.count
        if countOldCellMenu < countNewCellMenu {
            appBinding.main.storeCellMenu.wrappedValue = AppActions.MainActions.MenuName.allCases.compactMap {
                $0.rawValue
            }
            appBinding.main.storeCellMenuHidden.wrappedValue = []
            injected.interactors.mainInteractor.saveMainMenuToUserDefaults(state: appBinding)
        }
    }
}

private extension MainView {
    private func makeGrid() -> some View {
        let count = appBinding.main.storeCellMenu.wrappedValue.count
        let rows = count / columns + (count % columns == 0 ? 0 : 1)
        
        return ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                ForEach(0..<rows, id: \.self) { row in
                    HStack(alignment: .center, spacing: 16) {
                        ForEach(0..<self.columns, id: \.self) { column -> AnyView in
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
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 16)
        }
    }
}

private extension MainView {
    func alertLockCell(_ name: String) {
        UIApplication.shared.windows.first?.rootViewController?
            .showAlert(
                with: NSLocalizedString("Заблокировано", comment: ""),
                and: "\"\(name)\" \(NSLocalizedString("является частью преимуществ Random Premium", comment: ""))",
                titleOk: NSLocalizedString("Подробнее", comment: ""),
                titleCancel: NSLocalizedString("Отмена", comment: ""),
                completionOk: {
                    appBinding.premium.presentingModal.wrappedValue = true
                }
            )
    }
    
    
    func alertCrown() {
        UIApplication.shared.windows.first?.rootViewController?
            .showAlert(with: NSLocalizedString("Внимание", comment: ""),
                       and: NSLocalizedString("Премиум доступ активирован", comment: ""),
                       style: .alert
            )
    }
}

private extension MainView {
    func openLink(url: String) {
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let httpsUrl = URL(string: urlString) else { return }
        DispatchQueue.main.async {
            UIApplication.shared.open(httpsUrl, options: [:])
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(appBinding: .constant(.init()), actionButton: nil, storeManager: .init())
    }
}
