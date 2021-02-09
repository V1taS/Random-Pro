//
//  CoinResultsView.swift
//  Random
//
//  Created by Vitalii Sosin on 09.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CoinResultsView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    
    var body: some View {
        VStack {
            listResults
        }
        .navigationBarTitle(Text(NSLocalizedString("Список монет", comment: "")), displayMode: .inline)
    }
}

private extension CoinResultsView {
    var listResults: some View {
        List {
            ForEach(appBinding.coin.listResult.wrappedValue, id: \.self) { coin in
                
                HStack {
                    Spacer()
                    Text("\(coin)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    Spacer()
                }
            }
        }
    }
}

struct CoinResultsView_Previews: PreviewProvider {
    static var previews: some View {
        CoinResultsView(appBinding: .constant(.init()))
    }
}
