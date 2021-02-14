//
//  LotteryViewResultsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct LotteryResultsView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    
    var body: some View {
        VStack {
            listResults
        }
        .navigationBarTitle(Text(NSLocalizedString("Результат генерации", comment: "")), displayMode: .inline)
    }
}

private extension LotteryResultsView {
    var listResults: some View {
        List {
            ForEach(appBinding.lottery.listResult.wrappedValue, id: \.self) { nombers in
                
                HStack {
                    Spacer()
                    Text("\(nombers)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    Spacer()
                }
            }
        }
    }
}


struct LotteryViewResultsView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryResultsView(appBinding: .constant(.init()))
    }
}
