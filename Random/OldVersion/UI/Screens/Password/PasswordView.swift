//
//  PasswordView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 18.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct PasswordView: View {
    
    private var appBinding: Binding<AppState.AppData>
    private var actionButton: (() -> Void)?
    
    init(appBinding: Binding<AppState.AppData>, actionButton: (() -> Void)?) {
        self.appBinding = appBinding
        self.actionButton = actionButton
    }
    @Environment(\.injected) private var injected: DIContainer
    @State var lang = [NSLocalizedString("Генератор паролей", comment: ""),
                       NSLocalizedString("Фраза пароль", comment: "")]
    @State var selectedPass = 0
    
    @State private var isPressedButton = false
    @State private var isPressedResultButton = false
    @State private var result = ""
    @State private var showActionSheet = false
    @State private var resultActionSheet = ""
    @State private var wordPass = ""
    //    @State private var tabBar: UITabBar?
    
    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                pickerWordPass
                content
            }
            
            if selectedPass == 0 {
                VStack {
                    Spacer()
                    generateButton
                    
                }
            }
        }
        .padding(.horizontal, 16)
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(title: Text("\(resultActionSheet)"),
                        buttons: [
                            .default(Text(NSLocalizedString("Скопировать", comment: "")), action: {
                                UIPasteboard.general.string = resultActionSheet
                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                            }),
                            .cancel()
                            
                        ])
        }
        .onAppear(perform: {
            AppMetrics.trackEvent(name: .passwordScreen)
        })
        .navigationBarTitle(Text(NSLocalizedString("Пароли", comment: "")), displayMode: .inline)
        .navigationBarItems(trailing: HStack(spacing: 24) {
            Spacer()
            navigationButtonCopy
            navigationButtonTrash
        })
    }
}

private extension PasswordView {
    private var pickerWordPass: some View {
        Picker(selection: $selectedPass,
               label: Text("")) {
            ForEach(0..<lang.count) {
                Text("\(lang[$0])")
            }
        }
               .pickerStyle(SegmentedPickerStyle())
               .padding(.top, 16)
    }
}

private extension PasswordView {
    private var content: AnyView {
        switch selectedPass {
        case 0:
            return AnyView(generatePass)
        case 1:
            return AnyView(generateWordPass)
        default:
            return AnyView(EmptyView())
        }
    }
}

private extension PasswordView {
    private var generateWordPass: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(NSLocalizedString("Фраза", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoBold25())
                    .padding(.top, 16)
                
                
                VStack {
                    HStack(alignment: .center, spacing: 16) {
                        TextField(NSLocalizedString("Введите фразу", comment: ""), text: $wordPass)
                            .textFieldStyle(.roundedBorder)
                        Text("\(wordPass.count)")
                            .frame(width: 30)
                    }
                    .padding(.top, 16)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.primaryDefault())))
                
                Text(NSLocalizedString("Получите пароль", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoBold25())
                    .padding(.top, 16)
            }
            .padding(.bottom, 24)
            
            if wordPass.isEmpty {
                Text("?")
                    .foregroundColor(Color.primaryGray())
                    .font(.robotoBold40())
            } else {
                VStack(alignment: .leading, spacing: 16) {
                    HStack(alignment: .center, spacing: 16) {
                        Text("\(EncryptPassword.encrypt(text: wordPass))")
                            .fontWeight(.bold)
                    }.onTapGesture {
                        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        showActionSheet.toggle()
                        resultActionSheet = EncryptPassword.encrypt(text: wordPass)
                    }
                }
            }
        }
    }
}

private extension PasswordView {
    private var generatePass: some View {
        VStack {
            VStack(alignment: .leading) {
                Text(NSLocalizedString("Параметры", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoBold25())
                    .padding(.top, 16)
                
                
                VStack {
                    capitalLettersAndNumbers
                    lowerCaseAndSymbols
                        .padding(.top, 16)
                }
                .padding(.vertical, 16)
                .padding(.horizontal, 16)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.primaryDefault())))
                
                Text(NSLocalizedString("Длина пароля", comment: ""))
                    .foregroundColor(.primaryGray())
                    .font(.robotoBold25())
                    .padding(.top, 16)
                
                passwordLength
            }
            .padding(.bottom, 24)
            
            if result.isEmpty {
                Text("?")
                    .foregroundColor(Color.primaryGray())
                    .font(.robotoBold40())
            } else {
                VStack {
                    listResults
                        .opacity(isPressedResultButton ? 0.95 : 1)
                        .scaleEffect(isPressedResultButton ? 0.95 : 1)
                        .animation(.easeInOut(duration: 0.2), value: isPressedResultButton)
                }
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                    showActionSheet.toggle()
                    resultActionSheet = result
                }
                .opacity(isPressedResultButton ? 0.95 : 1)
                .scaleEffect(isPressedResultButton ? 0.95 : 1)
                .animation(.easeInOut(duration: 0.1))
                .pressAction {
                    isPressedResultButton = true
                } onRelease: {
                    isPressedResultButton = false
                }
            }
        }
    }
}

private extension PasswordView {
    var navigationButtonCopy: some View {
        Button(action: {
            if selectedPass == 0 {
                UIPasteboard.general.string = result
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            } else {
                UIPasteboard.general.string = EncryptPassword.encrypt(text: wordPass)
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
            
        }) {
            Image(systemName: "doc.on.doc")
                .font(.system(size: 16))
                .foregroundColor(.blue)
        }
    }
}

private extension PasswordView {
    var navigationButtonTrash: some View {
        Button(action: {
            if selectedPass == 0 {
                result = ""
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            } else {
                wordPass = ""
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            }
        }) {
            Image(systemName: "trash")
                .font(.system(size: 16))
                .foregroundColor(.blue)
        }
    }
}

private extension PasswordView {
    var generateButton: some View {
        Button(action: {
            result = generatePass(state: appBinding)
            actionButton?()
            Feedback.shared.impactHeavy(.medium)
        }) {
            ButtonView(textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Сгенерировать", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .opacity(isPressedButton ? 0.95 : 1)
        .scaleEffect(isPressedButton ? 0.95 : 1)
        .animation(.easeInOut(duration: 0.1))
        .pressAction {
            isPressedButton = true
        } onRelease: {
            isPressedButton = false
        }
        .padding(.vertical, 16)
    }
}

// MARK: secondTF
private extension PasswordView {
    var secondTF: some View {
        HStack {
            TextFieldUIKit(placeholder: "99",
                           text: appBinding.password.passwordLength,
                           font: UIFont.robotoMedium16()!,
                           foregroundColor: UIColor.primaryGray(),
                           keyType: .numberPad,
                           isSecureText: false,
                           textAlignment: .center,
                           limitLength: 2)
                .frame(width: 100, height: 30, alignment: .center)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.primaryDefault())))
                .foregroundColor(.clear)
        }
    }
}

// MARK: Capital Letters And Numbers
private extension PasswordView {
    var capitalLettersAndNumbers: some View {
        HStack {
            Toggle(isOn: appBinding.password.capitalLetters) {
                HStack {
                    Text(NSLocalizedString("Прописные буквы", comment: ""))
                        .foregroundColor(.primaryGray())
                        .font(.robotoRegular18())
                        .multilineTextAlignment(.leading)
                }
            }
            
            Spacer(minLength: 24)
            
            Toggle(isOn: appBinding.password.numbers) {
                HStack {
                    Text(NSLocalizedString("Цифры", comment: ""))
                        .foregroundColor(.primaryGray())
                        .font(.robotoRegular18())
                }
            }
        }
    }
}

// MARK: lower Case And Symbols
private extension PasswordView {
    var lowerCaseAndSymbols: some View {
        HStack {
            Toggle(isOn: appBinding.password.lowerCase) {
                HStack {
                    Text(NSLocalizedString("Строчные буквы", comment: ""))
                        .foregroundColor(.primaryGray())
                        .font(.robotoRegular18())
                        .multilineTextAlignment(.leading)
                }
            }
            
            Spacer(minLength: 24)
            
            Toggle(isOn: appBinding.password.symbols) {
                HStack {
                    Text(NSLocalizedString("Символы", comment: ""))
                        .foregroundColor(.primaryGray())
                        .font(.robotoRegular18())
                }
            }
        }
    }
}

// MARK: lower Case And Symbols
private extension PasswordView {
    var passwordLength: some View {
        HStack {
            Text(NSLocalizedString("От", comment: ""))
                .foregroundColor(.primaryGray())
                .font(.robotoRegular18())
                .multilineTextAlignment(.center)
            
            Text("4")
                .frame(width: 100, height: 30, alignment: .center)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.primaryDefault())))
                .foregroundColor(.primaryDefault())
            
            Spacer(minLength: 24)
            
            Text(NSLocalizedString("До", comment: ""))
                .foregroundColor(.primaryGray())
                .font(.robotoRegular18())
                .multilineTextAlignment(.center)
            
            secondTF
        }
    }
}

// MARK: setColor for Symbols
private extension PasswordView {
    func setColorFor(symbol: String) -> Color {
        if symbol.isNumber {
            return Color.primaryBlue()
        }
        
        if symbol.isSymbols {
            return Color.orange
        }
        
        if symbol.isLowercaseLetters {
            return Color.red
        }
        
        if symbol.isLetters {
            return Color.primaryGray()
        }
        
        return Color.primaryGreen()
    }
}

// MARK: List results
private extension PasswordView {
    var listResults: some View {
        Group {
            // MARK: Строка 1
            HStack {
                ForEach(0..<result.count, id: \.self) { index in
                    
                    if index <= 10 {
                        Text(result[index])
                            .foregroundColor(setColorFor(symbol: result[index]))
                            .font(.robotoBold25())
                            .animation(.default, value: false)
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // MARK: Строка 2
            HStack {
                ForEach(0..<result.count, id: \.self) { index in
                    
                    if index >= 11 && index <= 20 {
                        Text(result[index])
                            .foregroundColor(setColorFor(symbol: result[index]))
                            .font(.robotoBold25())
                            .animation(.default, value: false)
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // MARK: Строка 3
            HStack {
                ForEach(0..<result.count, id: \.self) { index in
                    
                    if index >= 21 && index <= 30 {
                        Text(result[index])
                            .foregroundColor(setColorFor(symbol: result[index]))
                            .font(.robotoBold25())
                            .animation(.default, value: false)
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // MARK: Строка 4
            HStack {
                ForEach(0..<result.count, id: \.self) { index in
                    
                    if index >= 31 && index <= 40 {
                        Text(result[index])
                            .foregroundColor(setColorFor(symbol: result[index]))
                            .font(.robotoBold25())
                            .animation(.default, value: false)
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // MARK: Строка 5
            HStack {
                ForEach(0..<result.count, id: \.self) { index in
                    
                    if index >= 41 && index <= 50 {
                        Text(result[index])
                            .foregroundColor(setColorFor(symbol: result[index]))
                            .font(.robotoBold25())
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // MARK: Строка 6
            HStack {
                ForEach(0..<result.count, id: \.self) { index in
                    
                    if index >= 51 && index <= 60 {
                        Text(result[index])
                            .foregroundColor(setColorFor(symbol: result[index]))
                            .font(.robotoBold25())
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // MARK: Строка 7
            HStack {
                ForEach(0..<result.count, id: \.self) { index in
                    
                    if index >= 61 && index <= 70 {
                        Text(result[index])
                            .foregroundColor(setColorFor(symbol: result[index]))
                            .font(.robotoBold25())
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // MARK: Строка 8
            HStack {
                ForEach(0..<result.count, id: \.self) { index in
                    
                    if index >= 71 && index <= 80 {
                        Text(result[index])
                            .foregroundColor(setColorFor(symbol: result[index]))
                            .font(.robotoBold25())
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // MARK: Строка 9
            HStack {
                ForEach(0..<result.count, id: \.self) { index in
                    
                    if index >= 81 && index <= 90 {
                        Text(result[index])
                            .foregroundColor(setColorFor(symbol: result[index]))
                            .font(.robotoBold25())
                    }
                }
            }
            .padding(.horizontal, 16)
            
            // MARK: Строка 10
            HStack {
                ForEach(0..<result.count, id: \.self) { index in
                    
                    if index >= 91 && index <= 99 {
                        Text(result[index])
                            .foregroundColor(setColorFor(symbol: result[index]))
                            .font(.robotoBold25())
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

// MARK: Actions
private extension PasswordView {
    private func generatePass(state: Binding<AppState.AppData>) -> String {
        return injected.interactors.passwordInteractor
            .generatePassword(state: state)
    }
}

struct PasswordView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordView(appBinding: .constant(.init()), actionButton: nil)
    }
}
