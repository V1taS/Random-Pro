//
//  SettingsView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    var appBinding: Binding<AppState.AppData>
    
    @Environment(\.injected) private var injected: DIContainer
    @ObservedObject var storeManager: StoreManager
    @State private var showActionSheet = false
    @State private var isSharePresented = false
    
    @State private var isUpdateAppButton = false
    @State private var isTelegramButton = false
    private let currentAppVersionListService = CurrentAppVersionListService()
    @State private var cloudAppVersion = ""
    private let appVersion = Bundle.main.appBuild
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Form {
                        Section(header: Text(LocalizedStringKey("ОСНОВНЫЕ"))) {
                            //                        idea
//                            premium
                            if UIDevice.current.userInterfaceIdiom != .pad {
                                share
                            }
                            //                        tipTheDeveloper
                        }
                        
                        Section(header: Text(LocalizedStringKey("Внешний вид"))) {
                            categories
                        }
                        
                        Section(header: Text(LocalizedStringKey("Другие"))) {
                            clearAppButton
                        }
                    }
                }
                
                VStack(spacing: 16) {
                    Spacer()
                    
                    if cloudAppVersion.isEmpty {
                        HStack {
                            Text(NSLocalizedString("Версия приложения", comment: "") + ":")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            
                            Text("\(appVersion)")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                    } else {
                        if cloudAppVersion != appVersion {
                            Text(NSLocalizedString("Обновить приложение", comment: ""))
                                .foregroundColor(.primaryError())
                                .font(.robotoMedium18())
                                .opacity(isUpdateAppButton ? 0.95 : 1)
                                .scaleEffect(isUpdateAppButton ? 0.95 : 1)
                                .animation(.easeInOut(duration: 0.2), value: isUpdateAppButton)
                                .onTapGesture {
                                    Metrics.trackEvent(name: .updateApp)
                                    openLink(url: "https://apps.apple.com/\(NSLocalizedString("домен", comment: ""))/app/random-pro/id1552813956")
                                }
                                .opacity(isUpdateAppButton ? 0.95 : 1)
                                .scaleEffect(isUpdateAppButton ? 0.95 : 1)
                                .animation(.easeInOut(duration: 0.1))
                                .pressAction {
                                    isUpdateAppButton = true
                                } onRelease: {
                                    isUpdateAppButton = false
                                }
                        } else {
                            HStack {
                                Text(NSLocalizedString("Версия приложения", comment: "") + ":")
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                                
                                Text("\(appVersion)")
                                    .foregroundColor(.primaryGray())
                                    .font(.robotoMedium18())
                            }
                        }
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Обратная связь", comment: "") + ":")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        
                        
                        Text(NSLocalizedString("@telegram", comment: ""))
                            .foregroundColor(.blue)
                            .font(.robotoMedium18())
                            .opacity(isTelegramButton ? 0.95 : 1)
                            .scaleEffect(isTelegramButton ? 0.95 : 1)
                            .animation(.easeInOut(duration: 0.2), value: isTelegramButton)
                            .onTapGesture {
                                Metrics.trackEvent(name: .openTelegram)
                                openLink(url: "https://t.me/V1taS")
                            }
                            .opacity(isTelegramButton ? 0.95 : 1)
                            .scaleEffect(isTelegramButton ? 0.95 : 1)
                            .animation(.easeInOut(duration: 0.1))
                            .pressAction {
                                isTelegramButton = true
                            } onRelease: {
                                isTelegramButton = false
                            }
                    }
                    
                }
                .padding(.bottom, 24)
            }
            .navigationBarTitle(Text(LocalizedStringKey("Настройки")), displayMode: .automatic)
            .navigationBarItems(trailing: HStack(spacing: 24) {
                Button(action: {
                    appBinding.main.presenSettingsView.wrappedValue = false
                }) {
                    Image(systemName: "xmark.circle")
                        .renderingMode(.template)
                        .font(.system(size: 24))
                        .foregroundColor(.blue)
                }
            })
        }
        .onAppear(perform: {
            currentAppVersionListService.fetchList { listCloud in
                let list = listCloud.map { $0.element }
                if let appVersion = list.first {
                    self.cloudAppVersion = appVersion
                }
            }
        })
        .sheet(isPresented: appBinding.premium.presentingFromSettingsModal, onDismiss: {}) {
            PremiumSubscriptionView(storeManager: storeManager, appBinding: appBinding)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

private extension SettingsView {
    var categories: some View {
        HStack {
            NavigationLink(
                destination: CategoriesNewView(appBinding: appBinding)
                    .allowAutoDismiss { false }) {
                        HStack {
                            Image(systemName: "square.grid.2x2")
                                .font(.title)
                                .frame(width: 50, alignment: .leading)
                                .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
                            
                            Text(NSLocalizedString("Категории", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                    }
            Spacer()
        }
    }
}

private extension SettingsView {
    var premium: some View {
        HStack {
            Image(systemName: "star")
                .font(.title)
                .frame(width: 50, alignment: .leading)
                .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
            
            HStack {
                Button(action: {
                    appBinding.premium.presentingFromSettingsModal.wrappedValue = true
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    HStack {
                        Text("Premium")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        
                        Spacer()
                        
                        if appBinding.premium.premiumIsEnabled.wrappedValue {
                            Text(NSLocalizedString("Активна", comment: ""))
                                .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
                                .font(.robotoRegular16())
                        } else {
                            Text(NSLocalizedString("Не активна", comment: ""))
                                .foregroundColor(.gray)
                                .font(.robotoRegular16())
                        }
                    }
                }
            }
        }
    }
}

private extension SettingsView {
    var idea: some View {
        HStack {
            Image(systemName: "message")
                .font(.title)
                .frame(width: 50, alignment: .leading)
                .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
            
            HStack {
                Button(action: {
                    Metrics.trackEvent(name: .mailScreen)
                    EmailHelper.shared.sendEmail(subject: NSLocalizedString("Обратная связь Random Pro", comment: ""),
                                                 body: NSLocalizedString("Напишите здесь Ваш текст", comment: ""),
                                                 to: "375693@mail.ru")
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    Text(NSLocalizedString("Обратная связь", comment: ""))
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                }
                Spacer()
            }
        }
    }
}

private extension SettingsView {
    var share: some View {
        HStack {
            Image(systemName: "square.and.arrow.up")
                .font(.title)
                .frame(width: 50, alignment: .leading)
                .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
            
            HStack {
                Button(action: {
                    Metrics.trackEvent(name: .shareScreen)
                    isSharePresented.toggle()
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    Text(NSLocalizedString("Поделиться", comment: ""))
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                }
                Spacer()
            }
        }.sheet(isPresented: $isSharePresented, onDismiss: {
            print("Dismiss")
        }, content: {
            if let url = URL(string: "https://apps.apple.com/\(NSLocalizedString("домен", comment: ""))/app/random-pro/id1552813956") {
                ActivityViewController(activityItems: [url])
            }
        })
    }
}

private extension SettingsView {
    var tipTheDeveloper: some View {
        HStack {
            NavigationLink(
                destination: PurchasesView(storeManager: storeManager)
                    .allowAutoDismiss { false }) {
                        HStack {
                            Image(systemName: "bitcoinsign.circle.fill")
                                .font(.title)
                                .frame(width: 50, alignment: .leading)
                                .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
                            
                            Text(NSLocalizedString("Чаевые разработчику", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                    }
            Spacer()
        }
    }
}

private extension SettingsView {
    var clearAppButton: some View {
        HStack {
            Spacer()
            Button(action: {
                showActionSheet.toggle()
            }) {
                Text(NSLocalizedString("Очистить кэш", comment: ""))
                    .foregroundColor(.primaryError())
                    .font(.robotoRegular16())
            }
            Spacer()
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text(NSLocalizedString("Очистить кэш", comment: "") + "?"),
                        buttons: [
                            .default(Text(NSLocalizedString("Очистить", comment: "")), action: {
                                cleanApp(state: appBinding)
                                cleanAllUserDefualts(state: appBinding)
                                Feedback.shared.impactHeavy(.medium)
                            }),
                            .cancel()
                            
                        ])
        }
    }
}

// MARK: Actions
private extension SettingsView {
    private func cleanApp(state: Binding<AppState.AppData>) {
        injected.interactors.numberInteractor
            .cleanNumber(state: state)
        
        injected.interactors.yesOrNoInteractor
            .cleanNumber(state: state)
        
        injected.interactors.charactersInteractor
            .cleanCharacters(state: state)
        
        injected.interactors.listWordsInteractor
            .cleanWords(state: state)
        
        injected.interactors.coinInteractor
            .cleanCoins(state: state)
        
        injected.interactors.cubeInterator
            .cleanCube(state: state)
        
        injected.interactors.dateAndTimeInteractor
            .cleanDay(state: state)
        
        injected.interactors.dateAndTimeInteractor
            .cleanDate(state: state)
        
        injected.interactors.dateAndTimeInteractor
            .cleanMonth(state: state)
        
        injected.interactors.lotteryInteractor
            .cleanNumbers(state: state)
        
        injected.interactors.teamInteractor
            .cleanTeams(state: state)
        
        injected.interactors.contactInteractor
            .cleanContacts(state: state)
        
        injected.interactors.filmInteractor
            .cleanFilms(state: state)
        
        injected.interactors.musicInteractor
            .cleanMusic(state: state)
        
        injected.interactors.russianLottoInteractor
            .cleanKegs(state: state)
        
        state.music.resultMusic.wrappedValue = MusicITunesDatum(attributes: nil, href: nil, id: nil)
        state.listWords.listData.wrappedValue = []
        state.team.listPlayersData.wrappedValue = []
    }
}

private extension SettingsView {
    private func cleanAllUserDefualts(state: Binding<AppState.AppData>) {
        injected.interactors.mainInteractor
            .cleanAll(state: state)
        
    }
}

private extension SettingsView {
    func openLink(url: String) {
        guard let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let httpsUrl = URL(string: urlString) else { return }
        DispatchQueue.main.async {
            UIApplication.shared.open(httpsUrl, options: [:])
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(appBinding: .constant(.init()), storeManager: StoreManager())
    }
}
