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
    @Environment(\.injected) private var injected: DIContainer
    
    @State var listResult: [String] = []
    
    var body: some View {
        VStack {
            listResults
            VStack(spacing: 16) {
                TextField
                generateButton
            }
        }
        .onAppear {
            listResult = appBinding.listWords.listData.wrappedValue
        }
        .keyboardAware()
        .dismissingKeyboard()
        .navigationBarTitle(Text("Список"), displayMode: .inline)
    }
}

private extension CustomListWordsView {
    var listResults: some View {
        List {
            ForEach(listResult, id: \.self) { element in
                
                HStack {
                    Spacer()
                    Text("\(element)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    Spacer()
                }
            } .onDelete(perform: { indexSet in
                listResult.remove(atOffsets: indexSet)
                appBinding.listWords.listData.wrappedValue.remove(atOffsets: indexSet)
            })
            
        }
    }
}

private extension CustomListWordsView {
    var TextField: some View {
        HStack {
            TextFieldUIKit(placeholder: "Напишите слово или фразу",
                           text: appBinding.listWords.textField,
                           font: UIFont.robotoMedium16()!,
                           foregroundColor: UIColor.primaryGray(),
                           keyType: .default,
                           isSecureText: false,
                           textAlignment: .center,
                           limitLength: 40)
                .frame(height: 50, alignment: .center)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.primaryGray())))
                .foregroundColor(.clear)
        }
        .padding(.horizontal, 16)
    }
}

private extension CustomListWordsView {
    var generateButton: some View {
        Button(action: {
            appBinding.listWords.listData.wrappedValue.append(appBinding.listWords.textField.wrappedValue)
            listResult.append(appBinding.listWords.textField.wrappedValue)
            appBinding.listWords.textField.wrappedValue = ""
        }) {
            ButtonView(background: .primaryTertiary(),
                       textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: "Добавить",
                       switchImage: false,
                       image: "")
        }
        .padding(.horizontal, 16)
    }
}

struct CustomListWordsView_Previews: PreviewProvider {
    static var previews: some View {
        CustomListWordsView(appBinding: .constant(.init()))
    }
}
