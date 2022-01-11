//
//  PremiumSubscriptionConfirmButtonView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct PremiumSubscriptionConfirmButtonView: View {
    
    enum TypeButtons {
        case non
        case confirm
        case restore
        case termsAndConditions
        case privacyPolicy
    }
    
    // MARK: - Private
    @State private var isPressedMainButton = false
    @State private var isPressedRestoreButton = false
    @State private var isPressedTermsAndConditionsButton = false
    @State private var isPressedPrivacyPolicyButton = false
    @State private var typeButtons: TypeButtons = .non
    
    private let constants = Constants()
    
    // MARK: - Public
    var actionButton: ((TypeButtons) -> Void)?
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            restorePurchaseButton
            
            VStack(alignment: .center, spacing: 4) {
                Text(constants.termsEULA)
                    .multilineTextAlignment(.center)
                    .font(.robotoRegular12())
                    .foregroundColor(Color.primaryGray())
                    .padding(.horizontal, 16)
                
                HStack(alignment: .center, spacing: 8) {
                    termsAndConditionsButton
                    Text("|")
                        .font(.robotoRegular14())
                        .foregroundColor(Color.primaryGray())
                    privacyPolicyButton
                }
            }
            
        }
    }
}

private extension PremiumSubscriptionConfirmButtonView {
    var mainButton: some View {
        Button(action: {
            typeButtons = .confirm
            actionButton?(typeButtons)
            Feedback.shared.impactHeavy(.soft)
        }) {
            ButtonView(textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: "Продолжить",
                       switchImage: false,
                       image: "")
        }
        .opacity(isPressedMainButton ? 0.8 : 1)
        .scaleEffect(isPressedMainButton ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.1))
        .pressAction {
            isPressedMainButton = true
        } onRelease: {
            isPressedMainButton = false
        }
        .padding(.horizontal, 16)
    }
    
    var restorePurchaseButton: some View {
        Button(action: {
            typeButtons = .restore
            actionButton?(typeButtons)
            Feedback.shared.impactHeavy(.soft)
        }) {
            Text(constants.restorePurchaseTitle)
                .foregroundColor(.blue)
        }
        .opacity(isPressedRestoreButton ? 0.8 : 1)
        .scaleEffect(isPressedRestoreButton ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.1))
        .pressAction {
            isPressedRestoreButton = true
        } onRelease: {
            isPressedRestoreButton = false
        }
    }
    
    var termsAndConditionsButton: some View {
        Button(action: {
            typeButtons = .termsAndConditions
            actionButton?(typeButtons)
            Feedback.shared.impactHeavy(.soft)
        }) {
            Text(constants.termsAndConditionsTitle)
                .font(.robotoRegular14())
                .foregroundColor(.blue)
        }
        .opacity(isPressedTermsAndConditionsButton ? 0.8 : 1)
        .scaleEffect(isPressedTermsAndConditionsButton ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.1))
        .pressAction {
            isPressedTermsAndConditionsButton = true
        } onRelease: {
            isPressedTermsAndConditionsButton = false
        }
    }
    
    var privacyPolicyButton: some View {
        Button(action: {
            typeButtons = .privacyPolicy
            actionButton?(typeButtons)
            Feedback.shared.impactHeavy(.soft)
        }) {
            Text(constants.privacyPolicyTitle)
                .font(.robotoRegular14())
                .foregroundColor(.blue)
        }
        .opacity(isPressedPrivacyPolicyButton ? 0.8 : 1)
        .scaleEffect(isPressedPrivacyPolicyButton ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.1))
        .pressAction {
            isPressedPrivacyPolicyButton = true
        } onRelease: {
            isPressedPrivacyPolicyButton = false
        }
    }
}

private extension PremiumSubscriptionConfirmButtonView {
    struct Constants {
        let restorePurchaseTitle = NSLocalizedString("Восстановить покупку", comment: "")
        let termsAndConditionsTitle = NSLocalizedString("Условия и Положения", comment: "")
        let privacyPolicyTitle = NSLocalizedString("Политика конфиденциальности", comment: "")
        
        let termsEULA = NSLocalizedString("EULASubscriptions", comment: "")
    }
}

struct PremiumSubscriptionConfirmButtonView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumSubscriptionConfirmButtonView()
    }
}
