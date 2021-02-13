//
//  SettingsView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text(NSLocalizedString("ОСНОВНЫЕ", comment: ""))) {
                        idea
                        rateOnAppStore
                        share
                        
                        
                    }
                    
                    Section(header: Text(NSLocalizedString("Другие", comment: ""))) {
                        clearAppButton
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Настройки", comment: "")), displayMode: .automatic)
        }
    }
}

private extension SettingsView {
    var idea: some View {
        HStack {
            Image(systemName: "message")
                .font(.title)
                .frame(width: 50, alignment: .leading)
                .foregroundColor(.primaryTertiary())
            
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
    var rateOnAppStore: some View {
        HStack {
            Image(systemName: "hand.thumbsup")
                .font(.title)
                .frame(width: 50, alignment: .leading)
                .foregroundColor(.primaryTertiary())
            
            
            HStack {
                Button(action: {
                    SKStoreReviewController.requestReview()
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    Text(NSLocalizedString("Оценить в App Store", comment: ""))
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
                .foregroundColor(.primaryTertiary())
            
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
        
        state.listWords.listData.wrappedValue = []
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
        let av = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(av, animated: true, completion: nil)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(appBinding: .constant(.init()))
    }
}
