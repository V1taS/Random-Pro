//
//  DateAndTimeResultsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct DateAndTimeResultsView: View {
    
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

private extension DateAndTimeResultsView {
    var listResults: some View {
        List {
            ForEach(appBinding.dateAndTime.listResult.wrappedValue, id: \.self) { answer in
                
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

struct DateAndTimeResultsView_Previews: PreviewProvider {
    static var previews: some View {
        DateAndTimeResultsView(appBinding: .constant(.init()))
    }
}
