//
//  CoinView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CoinView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        VStack {
            Text("\(appBinding.coin.result.wrappedValue)")
                .font(.robotoBold70())
                .foregroundColor(.primaryGray())
                .padding(.top, 16)
                .onTapGesture {
                    generateCoins(state: appBinding)
                    saveCoinIToUserDefaults(state: appBinding)
                    Feedback.shared.impactHeavy(.medium)
                }
            
            Spacer()
            
            imageCoin
            
            Spacer()
            listResults
            generateButton
        }
        
        .navigationBarTitle(Text(NSLocalizedString("Орел или Решка", comment: "")), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            appBinding.coin.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
                .font(.system(size: 24))
        })
        .sheet(isPresented: appBinding.coin.showSettings, content: {
            CoinSettingsView(appBinding: appBinding)
        })
    }
}

private extension CoinView {
    var imageCoin: some View {
        VStack {
            if !appBinding.coin.resultImage.wrappedValue.isEmpty {
                Image("\(appBinding.coin.resultImage.wrappedValue)")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .shadow(radius: 10)
                    .transition(.move(edge: .bottom))
                    .animation(.easeOut(duration: 0.7))
                    .onTapGesture {
                        generateCoins(state: appBinding)
                        Feedback.shared.impactHeavy(.medium)
                    }
            }
        }
    }
}

private extension CoinView {
    var generateButton: some View {
        Button(action: {
            generateCoins(state: appBinding)
            saveCoinIToUserDefaults(state: appBinding)
            Feedback.shared.impactHeavy(.medium)
        }) {
            ButtonView(background: .primaryTertiary(),
                       textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Сгенерировать", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .padding(16)
    }
}

private extension CoinView {
    var listResults: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(appBinding.coin.listResult
                            .wrappedValue.enumerated()), id: \.0) { (index, word) in
                    
                    if index == 0 {
                        TextRoundView(name: "\(word)")
                    } else {
                        Text("\(word)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                }
            }
            .padding(.leading, 16)
            .padding(.vertical, 16)
        }
    }
}

// MARK: Actions
private extension CoinView {
    private func generateCoins(state: Binding<AppState.AppData>) {
        injected.interactors.coinInteractor
            .generateCoins(state: state)
    }
}

private extension CoinView {
    private func saveCoinIToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.coinInteractor
            .saveCoinIToUserDefaults(state: state)
    }
}

struct CoinView_Previews: PreviewProvider {
    static var previews: some View {
        CoinView(appBinding: .constant(.init()))
    }
}
