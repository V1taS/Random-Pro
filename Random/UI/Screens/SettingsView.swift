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
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text(LocalizedStringKey("ОСНОВНЫЕ"))) {
                        idea
                        if UIDevice.current.userInterfaceIdiom != .pad {
                            share
                        }
                        tipTheDeveloper
                    }
                    
                    Section(header: Text(LocalizedStringKey("Другие"))) {
                        clearAppButton
                    }
                }
            }
            .navigationBarTitle(Text(LocalizedStringKey("Настройки")), displayMode: .automatic)
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
                    EmailHelper.shared.sendEmail(subject: NSLocalizedString("Идея для Random Pro", comment: ""),
                                                 body: NSLocalizedString("Напишите здесь Вашу идею или предложение", comment: ""),
                                                 to: "375693@mail.ru")
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    Text(NSLocalizedString("Предложить свою идею", comment: ""))
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
                    actionSheet()
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    Text(NSLocalizedString("Поделиться", comment: ""))
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                }
                Spacer()
            }
        }
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
                cleanApp(state: appBinding)
                cleanAllUserDefualts(state: appBinding)
                Feedback.shared.impactHeavy(.medium)
            }) {
                Text(NSLocalizedString("Очистить кэш", comment: ""))
                    .foregroundColor(.primaryError())
                    .font(.robotoRegular16())
            }
            Spacer()
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
    private func actionSheet() {
        guard let data = URL(string: "https://apps.apple.com/\(NSLocalizedString("домен", comment: ""))/app/random-pro/id1552813956") else { return }
        let av = UIActivityViewController(activityItems: [data], applicationActivities: [UIActivity()])
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(appBinding: .constant(.init()), storeManager: StoreManager())
    }
}
