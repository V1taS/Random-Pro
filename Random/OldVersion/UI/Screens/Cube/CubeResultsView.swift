//
//  CubeResultsView.swift
//  Random
//
//  Created by Vitalii Sosin on 09.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CubeResultsView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    
    var body: some View {
        VStack {
            listResults
        }
        .navigationBarTitle(Text(NSLocalizedString("Список кубиков", comment: "")), displayMode: .inline)
    }
}

private extension CubeResultsView {
    var listResults: some View {
        List {
            ForEach(appBinding.cube.listResult.wrappedValue, id: \.self) { cube in
                
                HStack {
                    Spacer()
                    Text("\(cube)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    Spacer()
                }
            }
        }
    }
}

struct CubeResultsView_Previews: PreviewProvider {
    static var previews: some View {
        CubeResultsView(appBinding: .constant(.init()))
    }
}
