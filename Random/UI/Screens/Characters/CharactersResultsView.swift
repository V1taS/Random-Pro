//
//  CharactersResultsView.swift
//  Random
//
//  Created by Vitalii Sosin on 09.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CharactersResultsView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    
    var body: some View {
        VStack {
            listResults
        }
        .navigationBarTitle(Text(NSLocalizedString("Список букв", comment: "")), displayMode: .inline)
    }
}

private extension CharactersResultsView {
    var listResults: some View {
        List {
            ForEach(appBinding.characters.listResult.wrappedValue, id: \.self) { character in
                
                HStack {
                    Spacer()
                    Text("\(character)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    Spacer()
                }
            }
        }
    }
}

struct CharactersResultsView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersResultsView(appBinding: .constant(.init()))
    }
}
