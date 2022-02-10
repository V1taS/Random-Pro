//
//  PremiumSubscriptionView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct PremiumSubscriptionView: View {
    
    @ObservedObject
    var storeManager: StoreManager
    var appBinding: Binding<AppState.AppData>
    
    @Environment(\.injected) private var injected: DIContainer
    
    private let constants = Constants()
    
    @State
    private var showAlertPremiumAccessActivated = false
    @State
    private var showAlertNoPreviousPurchasesFound = false
    @State
    private var showAlertNone = false
    
    @State
    private var isShowOwnerAdminView = false
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: $storeManager.showActivityIndicator) {
                ScrollView(.vertical, showsIndicators: false) {
                    
                    VStack(alignment: .leading, spacing: 8) {
                        info
                            .padding(.horizontal)
                            .alert(isPresented: $showAlertPremiumAccessActivated) {
                                Alert(title: Text(NSLocalizedString("Внимание", comment: "")),
                                      message: Text(constants.premiumAccessActivated),
                                      dismissButton: .default(Text(NSLocalizedString("Ок", comment: "")),
                                                              action: {
                                    appBinding.premium.presentingModal.wrappedValue = false
                                }))
                            }
                        buttons
                            .padding(.top, 24)
                            .padding(.horizontal)
                            .alert(isPresented: $showAlertNoPreviousPurchasesFound) {
                                Alert(title: Text(NSLocalizedString("Внимание", comment: "")),
                                      message: Text(constants.noPreviousPurchasesFound),
                                      dismissButton: .default(Text(NSLocalizedString("Ок", comment: "")),
                                                              action: {}
                                                             )
                                )
                            }
                        
                        confirmButtons
                            .padding(.top, 32)
                            .alert(isPresented: $showAlertNone) {
                                Alert(title: Text(NSLocalizedString("Внимание", comment: "")),
                                      message: Text(constants.youDidNotChooseAnything),
                                      dismissButton: .default(Text(NSLocalizedString("Ок", comment: "")),
                                                              action: {}
                                                             )
                                )
                            }
                    }
                    .padding(.top, 24)
                }
                .navigationBarTitle(Text("Premium"), displayMode: .large)
                .navigationBarItems(trailing: HStack(spacing: 24) {
                    Button(action: {
                        appBinding.premium.presentingModal.wrappedValue = false
                    }) {
                        Image(systemName: "xmark.circle")
                            .renderingMode(.template)
                            .font(.system(size: 24))
                            .foregroundColor(.blue)
                    }
                })
            }.onAppear {
                Metrics.trackEvent(name: .purchasesScreen)
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
                isEnabledDivider: false
            )
                .onTapGesture(count: 20) {
                    isShowOwnerAdminView = true
                }
            
//            TitleWithDescriptionCell(
//                iconSystemName: "lock.open.fill",
//                title: constants.titleAdvanced,
//                description: constants.descriptionAdvanced,
//                isEnabledDivider: false
//            )
//                .onTapGesture(count: 20) {
//                    isShowOwnerAdminView = true
//                }
        }
        .sheet(isPresented: $isShowOwnerAdminView, onDismiss: {
            isShowOwnerAdminView = false
            appBinding.adminOwner.passwordTF.wrappedValue = ""
            UserDefaults.standard.set(appBinding.adminOwner.premiumIsEnabled.wrappedValue, forKey: GlobalConstants.ownerPremiumUserDefaultsID)
            appBinding.premium.premiumIsEnabled.wrappedValue = appBinding.adminOwner.premiumIsEnabled.wrappedValue
            UserDefaults.standard.set(appBinding.premium.premiumIsEnabled.wrappedValue, forKey: GlobalConstants.premiumUserDefaultsID)
        }) {
            OwnerAdminView(appBinding: appBinding)
        }
    }
}

private extension PremiumSubscriptionView {
    var buttons: some View {
        PremiumSubscriptionChoiceView(
            buttonAction: { type in
                switch type {
                case .non:
                    showAlertNone = true
                case .years:
                    purchaseProduct(type: .yearsSubscription)
                case .monthly:
                    purchaseProduct(type: .monthlySubscription)
                case .lifelong:
                    purchaseProduct(type: .lifePlan)
                }
            },
            yearsPrimaryTitle: "\(constants.yearsPlan)",
            yearsSecondaryTitle: "",
            yearsPrimaryDescription: "\(calculatesTheCost(type: .yearsSubscription)) / \(constants.year)",
            yearsSecondaryDescription: "",
            monthlyPrimaryTitle: "\(constants.monthlyPlan)",
            monthlySecondaryTitle: "",
            monthlyPrimaryDescription: "\(calculatesTheCost(type: .monthlySubscription)) / \(constants.month)",
            monthlySecondaryDescription: "",
            lifelongPrimaryTitle: "\(constants.lifePlan)",
            lifelongSecondaryTitle: "",
            lifelongPrimaryDescription: "\(calculatesTheCost(type: .lifePlan))",
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
                case .confirm: break
                case .restore:
                    storeManager.showActivityIndicator = true
                    storeManager.restoreProducts()
                    storeManager.statePurchase = { status in
                        savePremiumStatus(status: status)
                        appBinding.premium.premiumIsEnabled.wrappedValue = status
                        if status {
                            showAlertPremiumAccessActivated = true
                        } else {
                            showAlertNoPreviousPurchasesFound = true
                        }
                    }
                case .termsAndConditions:
                    openLinkFromStringURL(link: constants.termsAndConditionsLink)
                case .privacyPolicy:
                    openLinkFromStringURL(link: constants.privacyPolicyLink)
                }
            })
    }
}

private extension PremiumSubscriptionView {
    func purchaseProduct(type: ProductSubscriptionIDs) {
        guard let getProduct = ProductSubscriptionIDs
                .getSKProduct(
                    type: type,
                    productsSKP: storeManager.myProducts
                ) else { return }
        storeManager.showActivityIndicator = true
        storeManager.purchaseProduct(product: getProduct)
        storeManager.statePurchase = { status in
            savePremiumStatus(status: status)
            appBinding.premium.premiumIsEnabled.wrappedValue = status
            if status {
                appBinding.premium.presentingModal.wrappedValue = false
            }
        }
    }
}

private extension PremiumSubscriptionView {
    struct Constants {
        let titleAdv = NSLocalizedString("Отсутствие рекламы", comment: "")
        let descriptionAdv = NSLocalizedString("Полное отключение всплывающей рекламы", comment: "")
        
        let titleAdvanced = NSLocalizedString("Расширенный функционал", comment: "")
        let descriptionAdvanced = NSLocalizedString("Открывает доступ к заблокированным функциям", comment: "")
        
        let yearsPlan = NSLocalizedString("Годовая подписка", comment: "")
        let monthlyPlan = NSLocalizedString("Месячная подписка", comment: "")
        let lifePlan = NSLocalizedString("Разовая покупка навсегда", comment: "")
        let saving = NSLocalizedString("экономия", comment: "")
        let inYear = NSLocalizedString("в год", comment: "")
        let year = NSLocalizedString("год", comment: "")
        let month = NSLocalizedString("месяц", comment: "")
        
        let termsAndConditionsLink = "https://sosinvitalii.com/terms-conditions"
        let privacyPolicyLink = "https://sosinvitalii.com/privacy-policy"
        
        let premiumAccessActivated = NSLocalizedString("Премиум доступ активирован", comment: "")
        let noPreviousPurchasesFound = NSLocalizedString("Ранее совершенных покупок не найдено", comment: "")
        let youDidNotChooseAnything = NSLocalizedString("Вы ничего не выбрали", comment: "")
        
        let mainButtonTitle = NSLocalizedString("Продолжить", comment: "")
        let mainButtonTitleSubscribe = NSLocalizedString("Подписаться", comment: "")
        let mainButtonTitleBuy = NSLocalizedString("Купить", comment: "")
    }
}

private extension PremiumSubscriptionView {
    func savePremiumStatus(status: Bool) {
        UserDefaults.standard.set(status, forKey: GlobalConstants.premiumUserDefaultsID)
    }
    
    func calculatesTheCost(type: ProductSubscriptionIDs) -> String {
        guard let getProduct = ProductSubscriptionIDs.getSKProduct(type: type,
                                                                   productsSKP: storeManager.myProducts) else { return NSLocalizedString("Обновление прайса", comment: "") }
        return getProduct.localizedPrice ?? NSLocalizedString("Обновление прайса", comment: "")
    }
    
    func calculatesDiscount() {
        // TODO: -
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
