//
//  CubeSettingsView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CubeSettingsView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    HStack {
                        Text(NSLocalizedString("Cгенерировано:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.cube.listResult.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Последняя сумма:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.cube.listResult.wrappedValue.last ?? NSLocalizedString("нет", comment: ""))")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        NavigationLink(
                            destination: CubeResultsView(appBinding: appBinding)
                                .allowAutoDismiss { false }) {
                            Text(NSLocalizedString("Список кубиков", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            cleanCube(state: appBinding)
                            saveCubeToUserDefaults(state: appBinding)
                            Feedback.shared.impactHeavy(.medium)
                        }) {
                            Text(NSLocalizedString("Очистить", comment: ""))
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Настройки", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.cube.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
            })
        }
    }
}

// MARK: Actions
private extension CubeSettingsView {
    private func cleanCube(state: Binding<AppState.AppData>) {
        injected.interactors.cubeInterator
            .cleanCube(state: state)
    }
}

private extension CubeSettingsView {
    private func saveCubeToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.cubeInterator
            .saveCubeToUserDefaults(state: state)
    }
}

struct CubeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        CubeSettingsView(appBinding: .constant(.init()))
    }
}
