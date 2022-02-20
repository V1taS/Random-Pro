//
//  RussianLottoView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 19.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct RussianLottoView: View {
    
    private var appBinding: Binding<AppState.AppData>
    private var actionButton: (() -> Void)?
    
    init(appBinding: Binding<AppState.AppData>, actionButton: (() -> Void)?) {
        self.appBinding = appBinding
        self.actionButton = actionButton
    }
    @Environment(\.injected) private var injected: DIContainer

    @State private var isPressedButton = false
    
    var body: some View {
        VStack {
            LotoView(appBinding: appBinding, actionButton: actionButton)
        }
        .navigationBarTitle(Text(NSLocalizedString("Русское Лото", comment: "")), displayMode: .inline)
    }
}

struct RussianLottoView_Previews: PreviewProvider {
    static var previews: some View {
        RussianLottoView(appBinding: .constant(.init()), actionButton: nil)
    }
}
