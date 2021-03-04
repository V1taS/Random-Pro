//
//  CharactersView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CharactersView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    @State var lang = [NSLocalizedString("Русские буквы", comment: ""),
                       NSLocalizedString("Английские буквы", comment: "")]
    @State var selectedLang = 0
    
    @State private var isPressedButton = false
    @State private var isPressedTouch = false
    
    var body: some View {
        VStack {
            Picker(selection: $selectedLang,
                   label: Text("Picker")) {
                ForEach(0..<lang.count) {
                    Text("\(lang[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top, 16)
            
            Spacer()
            Text("\(appBinding.characters.result.wrappedValue)")
                .font(.robotoBold70())
                .foregroundColor(.primaryGray())
                .opacity(isPressedButton || isPressedTouch ? 0.8 : 1)
                .scaleEffect(isPressedButton || isPressedTouch ? 0.8 : 1)
                .animation(.easeInOut(duration: 0.2), value: isPressedButton || isPressedTouch)
                
                .gesture(DragGesture(minimumDistance: 0.0, coordinateSpace: .global)
                            .onChanged { _ in
                                isPressedTouch = true
                                appBinding.characters.selectedLang.wrappedValue = selectedLang
                                generateYesOrNo(state: appBinding)
                                saveCharactersToUserDefaults(state: appBinding)
                                Feedback.shared.impactHeavy(.medium)
                            }
                            .onEnded { _ in
                                isPressedTouch = false
                            }
                )
            
            Spacer()
            
            listResults
            generateButton
        }
        .padding(.horizontal, 16)
        
        .navigationBarTitle(Text(NSLocalizedString("Буква", comment: "")), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            appBinding.characters.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
                .font(.system(size: 24))
        })
        .sheet(isPresented: appBinding.characters.showSettings, content: {
            CharactersSettingsView(appBinding: appBinding)
        })
    }
}

private extension CharactersView {
    var generateButton: some View {
        Button(action: {
            appBinding.characters.selectedLang.wrappedValue = selectedLang
            generateYesOrNo(state: appBinding)
            saveCharactersToUserDefaults(state: appBinding)
            Feedback.shared.impactHeavy(.medium)
        }) {
            ButtonView(textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Сгенерировать букву", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .opacity(isPressedButton ? 0.8 : 1)
        .scaleEffect(isPressedButton ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.1))
        .pressAction {
            isPressedButton = true
        } onRelease: {
            isPressedButton = false
        }
        .padding(.vertical, 16)
    }
}

private extension CharactersView {
    var listResults: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(appBinding.characters.listResult
                                .wrappedValue.enumerated()), id: \.0) { (index, character) in
                    if index == 0 {
                        TextRoundView(name: "\(character)")
                            .opacity(isPressedButton || isPressedTouch ? 0.8 : 1)
                            .scaleEffect(isPressedButton || isPressedTouch ? 0.9 : 1)
                            .animation(.easeInOut(duration: 0.1), value: isPressedButton || isPressedTouch)
                    } else {
                        Text("\(character)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                }
            }
            .padding(.leading, 8)
        }
    }
}

// MARK: Actions
private extension CharactersView {
    private func generateYesOrNo(state: Binding<AppState.AppData>) {
        injected.interactors.charactersInteractor.generateCharacters(state: state)
    }
}

private extension CharactersView {
    private func saveCharactersToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.charactersInteractor
            .saveCharactersToUserDefaults(state: state)
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView(appBinding: .constant(.init()))
    }
}

