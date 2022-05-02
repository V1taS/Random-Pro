//
//  ContactResultsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 22.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct ContactResultsView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    
    var body: some View {
        VStack {
            listResults
        }
        .navigationBarTitle(Text(NSLocalizedString("Список контактов", comment: "")), displayMode: .inline)
    }
}

private extension ContactResultsView {
    var listResults: some View {
        List {
            ForEach(appBinding.contact.listResults.wrappedValue, id: \.firstName) { contact in
                HStack(spacing: 16) {
                    Text("\(contact.lastName) \(contact.firstName):")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    
                    Spacer()
                    
                    Text("\(contact.telephone)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                }
            }
        }
    }
}

struct ContactResultsView_Previews: PreviewProvider {
    static var previews: some View {
        ContactResultsView(appBinding: .constant(.init()))
    }
}
