//
//  OwnerAdminView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct OwnerAdminView: View {
    
    var appBinding: Binding<AppState.AppData>
    @State private var isPressedButton = false
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 16) {
                    
                    if appBinding.adminOwner.key.wrappedValue == appBinding.adminOwner.passwordTF.wrappedValue {
                        HStack(alignment: .center, spacing: 16) {
                            Text("Premium")
                                .font(.robotoMedium18())
                                .foregroundColor(.primaryGray())
                            Spacer()
                            Toggle(isOn: appBinding.adminOwner.premiumIsEnabled) {
                                Text("")
                            }
                        }
                        .padding(.horizontal, 24)
                    } else {
                        VStack(alignment: .center, spacing: 16) {
                            passwordTF
                            doneButton
                        }
                        .padding(.top, 32)
                    }
                    
                    Spacer()
                    
                }
            }
            
            .navigationBarTitle(Text("Admin"), displayMode: .large)
        }
        
    }
}

private extension OwnerAdminView {
    var passwordTF: some View {
        HStack {
            TextFieldUIKit(placeholder: "* * * * *",
                           text: appBinding.adminOwner.passwordTF,
                           font: UIFont.robotoMedium16()!,
                           foregroundColor: UIColor.primaryGray(),
                           keyType: .default,
                           isSecureText: true,
                           textAlignment: .center,
                           limitLength: 10)
                .frame(width: 200, height: 30, alignment: .center)
                .background(Color.primaryPale())
                .cornerRadius(4)
                .overlay(RoundedRectangle(cornerRadius: 4)
                            .stroke(Color(.primaryDefault())))
                .foregroundColor(.clear)
        }
    }
}

private extension OwnerAdminView {
    var doneButton: some View {
        Button(action: {
            Feedback.shared.impactHeavy(.medium)
        }) {
            ButtonView(textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: "Done",
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
        .padding(16)
    }
}

struct OwnerAdminView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerAdminView(appBinding: .constant(.init()))
    }
}
