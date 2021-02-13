//
//  NumberResultsView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct NumberResultsView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    
    var body: some View {
        VStack {
            listResults
        }
        .navigationBarTitle(Text(NSLocalizedString("Список чисел", comment: "")), displayMode: .inline)
//        .navigationBarItems(trailing: showShareSheetButton)
        
    }
}

private extension NumberResultsView {
    var listResults: some View {
        List {
                ForEach(appBinding.numberRandom.listResult.wrappedValue, id: \.self) { number in
                    
                    HStack {
                        Spacer()
                        Text("\(number)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                    }
                }
        }
    }
}

// MARK: UI
private extension NumberResultsView {
    private var showShareSheetButton: AnyView {
        AnyView(
            Button(action: {
                
            }) {
                Image(systemName: "arrowshape.turn.up.right.circle")
                    .font(.title)
            }
        )
    }
}

struct NumberResultsView_Previews: PreviewProvider {
    static var previews: some View {
        NumberResultsView(appBinding: .constant(.init()))
    }
}
