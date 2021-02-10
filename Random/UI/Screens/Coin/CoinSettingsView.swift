//
//  CoinSettingsView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CoinSettingsView: View {
    
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
                        Text(NSLocalizedString("Cгенерировано:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.coin.listResult.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Последняя монета:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.coin.listResult.wrappedValue.last ?? NSLocalizedString("нет", comment: ""))")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        NavigationLink(
                            destination: CoinResultsView(appBinding: appBinding)
                                .allowAutoDismiss { false }) {
                            Text(NSLocalizedString("Список монет", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            cleanCoins(state: appBinding)
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
                appBinding.coin.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
            })
        }
    }
}

// MARK: Actions
private extension CoinSettingsView {
    private func cleanCoins(state: Binding<AppState.AppData>) {
        injected.interactors.coinInteractor
            .cleanCoins(state: state)
    }
}

struct CoinSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CoinSettingsView(appBinding: .constant(.init()))
    }
}
