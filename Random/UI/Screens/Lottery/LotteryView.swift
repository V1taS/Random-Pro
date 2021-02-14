//
//  LotteryView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct LotteryView: View {
    
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        ZStack {
            Color(.clear)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    firstTF
                    secondTF
                }
                Spacer()
                Text("\(appBinding.lottery.result.wrappedValue)")
                    .font(.robotoBold70())
                    .foregroundColor(.primaryGray())
                    .padding(.horizontal, 16)
                    .onTapGesture {
                        if !appBinding.lottery.firstNumber.wrappedValue.isEmpty &&
                            !appBinding.lottery.secondNumber.wrappedValue.isEmpty {
                            generateNumbers(state: appBinding)
                            Feedback.shared.impactHeavy(.medium)
                            saveLotteryToUserDefaults(state: appBinding)
                        }
                    }
                
                Spacer()
                
                listResults
                generateButton
            }
            .padding(.top, 16)
            
            .navigationBarTitle(Text(NSLocalizedString("Лотерея", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.lottery.showSettings.wrappedValue.toggle()
            }) {
                Image(systemName: "gear")
                    .font(.system(size: 24))
            })
            .sheet(isPresented: appBinding.lottery.showSettings, content: {
                LotterySettingsView(appBinding: appBinding)
            })
        }
        .dismissingKeyboard()
    }
}

private extension LotteryView {
    var firstTF: some View {
        HStack {
            TextFieldUIKit(placeholder: "7",
                           text: appBinding.lottery.firstNumber,
                           font: UIFont.robotoMedium16()!,
                           foregroundColor: UIColor.primaryGray(),
                           keyType: .numberPad,
                           isSecureText: false,
                           textAlignment: .center,
                           limitLength: 3)
                .frame(width: 130, height: 30, alignment: .center)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.primaryDefault())))
                .foregroundColor(.clear)
        }
    }
}

private extension LotteryView {
    var secondTF: some View {
        HStack {
            TextFieldUIKit(placeholder: "49",
                           text: appBinding.lottery.secondNumber,
                           font: UIFont.robotoMedium16()!,
                           foregroundColor: UIColor.primaryGray(),
                           keyType: .numberPad,
                           isSecureText: false,
                           textAlignment: .center,
                           limitLength: 3)
                .frame(width: 130, height: 30, alignment: .center)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.primaryDefault())))
                .foregroundColor(.clear)
        }
    }
}

private extension LotteryView {
    var listResults: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(appBinding.lottery.listResult.wrappedValue, id: \.self) { number in
                    
                    Text("\(number)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                }
            }
            .padding(.leading, 16)
            .padding(.vertical, 16)
        }
    }
}

private extension LotteryView {
    var generateButton: some View {
        Button(action: {
            if !appBinding.lottery.firstNumber.wrappedValue.isEmpty &&
                !appBinding.lottery.secondNumber.wrappedValue.isEmpty {
                generateNumbers(state: appBinding)
                Feedback.shared.impactHeavy(.medium)
                saveLotteryToUserDefaults(state: appBinding)
            }
        }) {
            ButtonView(background: .primaryTertiary(),
                       textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Сгенерировать", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .padding(16)
    }
}

// MARK: Actions
private extension LotteryView {
    private func generateNumbers(state: Binding<AppState.AppData>) {
        injected.interactors.lotteryInteractor
            .generateNumbers(state: state)
    }
}

private extension LotteryView {
    private func saveLotteryToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.lotteryInteractor
            .saveLotteryToUserDefaults(state: state)
    }
}

struct LotteryView_Previews: PreviewProvider {
    static var previews: some View {
        LotteryView(appBinding: .constant(.init()))
    }
}
