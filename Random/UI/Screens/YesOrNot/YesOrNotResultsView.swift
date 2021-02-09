//
//  YesOrNotResultsView.swift
//  Random
//
//  Created by Vitalii Sosin on 09.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct YesOrNotResultsView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    
    var body: some View {
        VStack {
            listResults
        }
        .navigationBarTitle(Text("Список ответов"), displayMode: .inline)
    }
}

private extension YesOrNotResultsView {
    var listResults: some View {
        List {
            ForEach(appBinding.yesOrNo.listResult.wrappedValue, id: \.self) { answer in
                
                HStack {
                    Spacer()
                    Text("\(answer)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    Spacer()
                }
            }
        }
    }
}

struct YesOrNotResultsView_Previews: PreviewProvider {
    static var previews: some View {
        YesOrNotResultsView(appBinding: .constant(.init()))
    }
}
