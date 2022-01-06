//
//  PremiumSubscriptionView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct PremiumSubscriptionView: View {
    
    @ObservedObject var storeManager: StoreManager
    
    var appBinding: Binding<AppState.AppData>
    
    @Environment(\.injected) private var injected: DIContainer
    
    private let constants = Constants()
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: $storeManager.showActivityIndicator) {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        info
                        buttons
                            .padding(.top, 32)
                        
                        confirmButtons
                            .padding(.top, 32)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal)
                }
                .navigationBarTitle(Text("Premium"), displayMode: .large)
                .navigationBarItems(trailing: HStack(spacing: 24) {
                    Button(action: {
                        appBinding.premium.presentingModal.wrappedValue = false
                    }) {
                        Image(systemName: "xmark.circle")
                            .renderingMode(.template)
                            .font(.system(size: 24))
                            .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
                    }
                })
            }
            
        }
    }
}

private extension PremiumSubscriptionView {
    var info: some View {
        VStack(alignment: .center, spacing: 8) {
            TitleWithDescriptionCell(
                iconSystemName: "megaphone.fill",
                title: constants.titleAdv,
                description: constants.descriptionAdv,
                isEnabledDivider: true
            )
            
            TitleWithDescriptionCell(
                iconSystemName: "lock.open.fill",
                title: constants.titleAdvanced,
                description: constants.descriptionAdvanced,
                isEnabledDivider: false
            )
        }
    }
}

private extension PremiumSubscriptionView {
    var buttons: some View {
        PremiumSubscriptionChoiceView(
            buttonAction: { type in
                switch type {
                case .non: break
                case .years:
                    break
                case .monthly:
                    break
                case .lifelong:
                    break
                }
            },
            yearsPrimaryTitle: "\(constants.yearsPlan) - \(constants.saving) 50%",
            yearsSecondaryTitle: "",
            yearsPrimaryDescription: "1 050,00 Р / \(constants.year)",
            yearsSecondaryDescription: "(2 0 90,00 Р / \(constants.year))",
            monthlyPrimaryTitle: "\(constants.monthlyPlan) - \(constants.saving) 20%",
            monthlySecondaryTitle: "",
            monthlyPrimaryDescription: "269,00 Р / \(constants.month)",
            monthlySecondaryDescription: "",
            lifelongPrimaryTitle: "\(constants.lifePlan) - \(constants.saving) 95%",
            lifelongSecondaryTitle: "",
            lifelongPrimaryDescription: "3 390,00 Р",
            lifelongSecondaryDescription: ""
        )
    }
}

private extension PremiumSubscriptionView {
    var confirmButtons: some View {
        PremiumSubscriptionConfirmButtonView(
            actionButton: { typeButtons in
                switch typeButtons {
                case .non: break
                case .confirm:
                    break
                case .restore:
                    break
                case .termsAndConditions:
                    openLinkFromStringURL(link: constants.termsAndConditionsLink)
                case .privacyPolicy:
                    openLinkFromStringURL(link: constants.privacyPolicyLink)
                }
            }
        )
    }
}

private extension PremiumSubscriptionView {
    struct Constants {
        let titleAdv = NSLocalizedString("Отсутствие рекламы", comment: "")
        let descriptionAdv = NSLocalizedString("Полностью исключите показ рекламы в приложении", comment: "")
        
        let titleAdvanced = NSLocalizedString("Расширенный функционал", comment: "")
        let descriptionAdvanced = NSLocalizedString("Открывает доступ к заблокированным функциям", comment: "")
        
        let yearsPlan = NSLocalizedString("Годовой план", comment: "")
        let monthlyPlan = NSLocalizedString("Месячный план", comment: "")
        let lifePlan = NSLocalizedString("Пожизненный план", comment: "")
        let saving = NSLocalizedString("экономия", comment: "")
        let inYear = NSLocalizedString("в год", comment: "")
        let year = NSLocalizedString("год", comment: "")
        let month = NSLocalizedString("месяц", comment: "")
        
        let termsAndConditionsLink = "https://sosinvitalii.com/terms-conditions"
        let privacyPolicyLink = "https://sosinvitalii.com/privacy-policy"
    }
}

private extension PremiumSubscriptionView {
    func openLinkFromStringURL(link: String?) {
        guard let link = link else { return }
        guard let urlString = link.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        guard let httpsUrl = URL(string: urlString) else { return }
        DispatchQueue.main.async {
            UIApplication.shared.open(httpsUrl, options: [:])
        }
    }
}

struct PremiumSubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumSubscriptionView(storeManager: .init(), appBinding: .constant(.init()))
    }
}
