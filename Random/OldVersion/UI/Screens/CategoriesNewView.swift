//
//  CategoriesNewView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 07.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CategoriesNewView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    @State var storeCellMenu: [String] = []
    
    var body: some View {
            List {
                ForEach(Array(storeCellMenu.enumerated()), id: \.0) { (index, element) in
                    HStack {
                        Spacer()
                        Text(NSLocalizedString("\(element)", comment: ""))
                            .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
                            .font(.robotoRegular16())
                        Spacer()
                    }
                    .background(Color(#colorLiteral(red: 0.99598068, green: 0.9961469769, blue: 0.9959587455, alpha: 1)))
                }
                .onMove(perform: { indices, newOffset in
                    move(from: indices, to: newOffset)
                    DispatchQueue.global(qos: .userInitiated).async {
                        appBinding.main.storeCellMenu.wrappedValue = storeCellMenu
                        saveMainMenuToUserDefaults(state: appBinding)
                    }
                })
            }
            .navigationBarTitle(Text(LocalizedStringKey("Категории")), displayMode: .inline)
            .navigationBarItems(trailing:
                                    EditButton()
                                    .foregroundColor(Color.blue)
                                    .font(Font.robotoMedium18())
            )
            
            .onAppear {
                AppMetrics.trackEvent(name: .categoriesScreen)
                storeCellMenu = appBinding.main.storeCellMenu.wrappedValue
            }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        storeCellMenu.move(fromOffsets: source, toOffset: destination)
    }
}

// MARK: Actions
private extension CategoriesNewView {
    private func saveMainMenuToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.mainInteractor
            .saveMainMenuToUserDefaults(state: state)
    }
}

struct CategoriesNewView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesNewView(appBinding: .constant(.init()))
    }
}
