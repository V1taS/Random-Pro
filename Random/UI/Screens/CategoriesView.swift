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
                                .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
                                .font(.robotoRegular16())
                            Spacer()
                        }
                        .background(Color(#colorLiteral(red: 0.99598068, green: 0.9961469769, blue: 0.9959587455, alpha: 1)))
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
                                .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
                                .font(.robotoRegular16())
                            Spacer()
                        }
                        .background(Color(#colorLiteral(red: 0.99598068, green: 0.9961469769, blue: 0.9959587455, alpha: 1)))
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
            
            if !UserDefaults.standard.bool(forKey: "CategoriesViewMessage") {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    UIApplication.shared.windows.first?.rootViewController?.showAlert(with: NSLocalizedString("Внимание", comment: ""), and: NSLocalizedString("Чтобы скрыть или показать раздел, просто нажми на него", comment: ""), style: .actionSheet) {
                        UserDefaults.standard.set(true, forKey: "CategoriesViewMessage")
                    }
                } else {
                    UIApplication.shared.windows.first?.rootViewController?.showAlert(with: NSLocalizedString("Внимание", comment: ""), and: NSLocalizedString("Чтобы скрыть или показать раздел, просто нажми на него", comment: ""), style: .alert) {
                        UserDefaults.standard.set(true, forKey: "CategoriesViewMessage")
                    }
                }
            }
        }
        .navigationBarTitle(Text(LocalizedStringKey("Категории")), displayMode: .automatic)
        .navigationBarItems(trailing:
                                HStack {
            Spacer()
            EditButton()
                .foregroundColor(.primaryBlue())
                .font(.robotoRegular16())
        })
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
