//
//  CategoriesView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CategoriesView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text(LocalizedStringKey("Активные"))) {
                    ForEach(Array(appBinding.main.storeCellMenu
                                    .wrappedValue.enumerated()), id: \.offset) { (index, view) in
                        
                        Text(view)
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular18())
                            .onTapGesture {
                                appBinding.main.storeCellMenu
                                    .wrappedValue.remove(at: index)
                            }
                    }
                }
                
                Section(header: Text(LocalizedStringKey("Скрытые"))) {
                    ForEach(Array(appBinding.main.storeCellMenuHidden
                                    .wrappedValue.enumerated()), id: \.0) { (index, view) in
                        

                    }
                }
            }
        }
        .navigationBarTitle(Text(LocalizedStringKey("Категории")), displayMode: .automatic)
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(appBinding: .constant(.init()))
    }
}
