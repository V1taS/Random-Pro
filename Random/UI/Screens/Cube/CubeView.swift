//
//  CubeView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CubeView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        VStack {
            VStack {
                Text("Количество кубиков")
                    .font(.robotoMedium20())
                    .foregroundColor(.primaryGray())
                
                Picker(selection: appBinding.cube.selectedCube,
                       label: Text("Picker")) {
                    ForEach(0..<appBinding.cube.countCube.wrappedValue.count) {
                        Text("\(appBinding.cube.countCube.wrappedValue[$0])")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 16)
                .padding(.horizontal, 16)
            }
            .padding(.top, 16)
            
            
            Spacer()
        }
        .navigationBarTitle(Text("Кубики"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            appBinding.cube.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
        })
        .sheet(isPresented: appBinding.cube.showSettings, content: {
            CubeSettingsView(appBinding: appBinding)
        })
    }
}

struct CubeView_Previews: PreviewProvider {
    static var previews: some View {
        CubeView(appBinding: .constant(.init()))
    }
}
