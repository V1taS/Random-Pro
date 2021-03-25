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
    @State var storeCellMenu: [String] = []
    @State var storeCellMenuHidden: [String] = []
    
    var body: some View {
        VStack {
            Form {
                
                
                Section(header: Text(NSLocalizedString("Активные", comment: "") + " - \(storeCellMenu.count)")) {
                    
                    ForEach(Array(storeCellMenu.enumerated()), id: \.0) { (index, element) in
                        
                        HStack {
                            Spacer()
                            Text(NSLocalizedString("\(element)", comment: ""))
                                .foregroundColor(.primaryBlue())
                                .font(.robotoRegular16())
                            Spacer()
                        }
                        .frame(width: .infinity, height: 30)
                        .onTapGesture {
                            storeCellMenu.remove(at: index)
                            storeCellMenuHidden.append(element)
                            
                            DispatchQueue.global(qos: .userInitiated).async {
                                appBinding.main.storeCellMenu.wrappedValue = storeCellMenu
                                appBinding.main.storeCellMenuHidden.wrappedValue = storeCellMenuHidden
                                saveMainMenuToUserDefaults(state: appBinding)
                            }
                        }
                    }
                    .onMove(perform: { indices, newOffset in
                        move(from: indices, to: newOffset)
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            appBinding.main.storeCellMenu.wrappedValue = storeCellMenu
                            saveMainMenuToUserDefaults(state: appBinding)
                        }
                    })
                }
                
                Section(header: Text(NSLocalizedString("Скрытые", comment: "") + " - \(storeCellMenuHidden.count)")) {
                    ForEach(Array(storeCellMenuHidden.enumerated()), id: \.0) { (index, element) in
                        
                        HStack {
                            Spacer()
                            Text(NSLocalizedString("\(element)", comment: ""))
                                .foregroundColor(.primaryBlue())
                                .font(.robotoRegular16())
                            Spacer()
                        }
                        .onTapGesture {
                            storeCellMenuHidden.remove(at: index)
                            storeCellMenu.append(element)
                            
                            DispatchQueue.global(qos: .userInitiated).async {
                                appBinding.main.storeCellMenu.wrappedValue = storeCellMenu
                                appBinding.main.storeCellMenuHidden.wrappedValue = storeCellMenuHidden
                                saveMainMenuToUserDefaults(state: appBinding)
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            storeCellMenu = appBinding.main.storeCellMenu.wrappedValue
            storeCellMenuHidden = appBinding.main.storeCellMenuHidden.wrappedValue
        }
        .navigationBarTitle(Text(LocalizedStringKey("Категории")), displayMode: .automatic)
        .navigationBarItems(trailing: EditButton())
    }
    
    func move(from source: IndexSet, to destination: Int) {
        storeCellMenu.move(fromOffsets: source, toOffset: destination)
    }
}

// MARK: Actions
private extension CategoriesView {
    private func saveMainMenuToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.mainInteractor
            .saveMainMenuToUserDefaults(state: state)
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(appBinding: .constant(.init()))
    }
}
