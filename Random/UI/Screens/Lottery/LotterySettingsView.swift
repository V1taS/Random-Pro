//
//  LotterySettingsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct LotterySettingsView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    HStack {
                        Text(NSLocalizedString("Чисел Сгенерировано:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.lottery.listResult.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        NavigationLink(
                            destination: LotteryViewResultsView(appBinding: appBinding)
                                .allowAutoDismiss { false }) {
                            Text(NSLocalizedString("Результат генерации", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {

                            cleanNumbers(state: appBinding)
                            saveLotteryToUserDefaults(state: appBinding)
                            Feedback.shared.impactHeavy(.medium)
                        }) {
                            Text(NSLocalizedString("Очистить", comment: ""))
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Настройки", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.lottery.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
            })
        }
    }
}

// MARK: Actions clean Numbers
private extension LotterySettingsView {
    private func cleanNumbers(state: Binding<AppState.AppData>) {
        injected.interactors.lotteryInteractor
            .cleanNumbers(state: state)
    }
}

private extension LotterySettingsView {
    private func saveLotteryToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.lotteryInteractor
            .saveLotteryToUserDefaults(state: state)
    }
}

struct LotterySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        LotterySettingsView(appBinding: .constant(.init()))
    }
}
