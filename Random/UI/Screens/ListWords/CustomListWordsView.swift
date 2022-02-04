//
//  CustomListWordsView.swift
//  Random
//
//  Created by Vitalii Sosin on 09.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CustomListWordsView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    private let listService = ListService()
    
    @State private var isSentDataToCloud = false
    @State private var isPressedButton = false
    @State private var isPressedButtonRemove = false
    
    @Environment(\.injected) private var injected: DIContainer
    
    @State var listResult: [String] = []
    @State var textField = ""
    
    var body: some View {
        listResults
            .onDisappear(perform: {
                appBinding.listWords.listData.wrappedValue = listResult
                saveListWordsToUserDefaults(state: appBinding)
                if isSentDataToCloud {
                    DispatchQueue.global(qos: .background).async {
                        listService.deleteAllElements {
                            listResult.forEach { element in
                                listService.add(element: element)
                            }
                        }
                    }
                }
            })
            .onAppear {
                listResult = appBinding.listWords.listData.wrappedValue
            }
            .keyboardAware()
            .dismissingKeyboard()
            .navigationBarTitle(Text(NSLocalizedString("Список", comment: "")), displayMode: .inline)
    }
}

private extension CustomListWordsView {
    var deleteAllElements: some View {
        VStack {
            if !listResult.isEmpty {
                HStack {
                    Spacer()
                    Text(NSLocalizedString("Удалить элементы из списка", comment: ""))
                        .font(.robotoRegular16())
                        .foregroundColor(.primaryError())
                        .opacity(isPressedButtonRemove ? 0.8 : 1)
                        .scaleEffect(isPressedButtonRemove ? 0.8 : 1)
                        .animation(.easeInOut(duration: 0.2), value: isPressedButtonRemove)
                    Spacer()
                }
                .padding(.vertical, 16)
                .background(Color.white)
                .onTapGesture {
                    appBinding.team.listPlayersData.wrappedValue = []
                    saveListWordsToUserDefaults(state: appBinding)
                    listResult = []
                    Feedback.shared.impactHeavy(.medium)
                    DispatchQueue.global(qos: .background).async {
                        listService.deleteAllElements {
                            print("Deleted")
                        }
                    }
                }.pressAction {
                    isPressedButtonRemove = true
                } onRelease: {
                    isPressedButtonRemove = false
                }
            }
        }
    }
}

private extension CustomListWordsView {
    var listResults: some View {
        List {
            ForEach(Array(zip(listResult.indices, listResult)), id: \.0) { index, element in
                
                HStack {
                    Spacer()
                    Text("\(element)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    Spacer()
                }
                
            }.onDelete(perform: { indexSet in
                listResult.remove(atOffsets: indexSet)
                appBinding.listWords.listData.wrappedValue.remove(atOffsets: indexSet)
                appBinding.listWords.listTemp.wrappedValue = appBinding.listWords.listData.wrappedValue
                saveListWordsToUserDefaults(state: appBinding)
            })
            TextField
            generateButton
            if !appBinding.listWords.listData.wrappedValue.isEmpty {
                deleteAllElements
            }
            
        }
    }
}

private extension CustomListWordsView {
    var TextField: some View {
        HStack {
            TextFieldUIKit(placeholder: NSLocalizedString("Напишите слово или фразу", comment: ""),
                           text: $textField,
                           font: UIFont.robotoMedium16()!,
                           foregroundColor: UIColor.primaryGray(),
                           keyType: .default,
                           isSecureText: false,
                           textAlignment: .center,
                           limitLength: 40)
                .frame(height: 40)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.primaryGray())))
                .foregroundColor(.clear)
        }
    }
}

private extension CustomListWordsView {
    var generateButton: some View {
        VStack {
            ButtonView(textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Добавить", comment: ""),
                       switchImage: false,
                       image: "")
                .opacity(isPressedButton ? 0.8 : 1)
                .scaleEffect(isPressedButton ? 0.8 : 1)
                .animation(.easeInOut(duration: 0.2), value: isPressedButton)
                .onTapGesture {
                    if !textField.isEmpty {
                        isSentDataToCloud = true
                        appendWord(state: appBinding)
                        clearTF(state: appBinding)
                        saveListWordsToUserDefaults(state: appBinding)
                        Feedback.shared.impactHeavy(.medium)
                    }
                }
                .opacity(isPressedButton ? 0.8 : 1)
                .scaleEffect(isPressedButton ? 0.9 : 1)
                .animation(.easeInOut(duration: 0.1))
                .pressAction {
                    isPressedButton = true
                } onRelease: {
                    isPressedButton = false
                }
        }
    }
}

private extension CustomListWordsView {
    private func appendWord(state: Binding<AppState.AppData>) {
        appBinding.listWords.listData.wrappedValue
            .append(textField)
        appBinding.listWords.listTemp.wrappedValue
            .append(textField)
        listResult.append(textField)
    }
}

private extension CustomListWordsView {
    private func clearTF(state: Binding<AppState.AppData>) {
        textField = ""
    }
}

private extension CustomListWordsView {
    private func saveListWordsToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.listWordsInteractor
            .saveListWordsToUserDefaults(state: state)
    }
}

struct CustomListWordsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomListWordsView(appBinding: .constant(.init()))
    }
}
