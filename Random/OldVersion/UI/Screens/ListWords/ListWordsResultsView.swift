//
//  ListWordsResultsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 10.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct ListWordsResultsView: View {
    
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

private extension ListWordsResultsView {
    var listResults: some View {
        List {
            ForEach(appBinding.listWords.listResult.wrappedValue, id: \.self) { word in
                
                HStack {
                    Spacer()
                    Text("\(word)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    Spacer()
                }
            }
        }
    }
}

struct ListWordsResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ListWordsResultsView(appBinding: .constant(.init()))
    }
}
