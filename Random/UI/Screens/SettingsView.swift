//
//  SettingsView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("ОСНОВНЫЕ")) {
                        HStack {
                            Text("Монет сгенерировано:")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            Spacer()
                            
                            Text("\(appBinding.cube.listResult.wrappedValue.count)")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                    }
                    
                    Section(header: Text("ДРУГИЕ")) {
                        HStack {
                            Text("Последняя монета:")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                            Spacer()
                            
                            Text("\(appBinding.cube.listResult.wrappedValue.last ?? "нет")")
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                    }
                    
                    Section(header: Text("МОИ ПРИЛОЖЕНИЯ")) {
                        HStack {
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Text("Очистить")
                            }
                            Spacer()
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Настройки"), displayMode: .automatic)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(appBinding: .constant(.init()))
    }
}
