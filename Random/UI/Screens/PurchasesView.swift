//
//  PurchasesView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import StoreKit

struct PurchasesView: View {
    
    @ObservedObject var storeManager: StoreManager
    
    var body: some View {
        LoadingView(isShowing: $storeManager.showActivityIndicator) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    teaView
                    wineView
                    breakfastView
                    lunchView
                    dinnerView
                    dateWithMyGirlView
                    tripView
                    
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 24)
                .navigationBarTitle(Text(LocalizedStringKey("Чаевые разработчику")), displayMode: .automatic)
            }
        }
    }
}

private extension PurchasesView {
    var teaView: some View {
        Button(action: {
            guard let getTeaPrice = ProductSubscriptionIDs.getSKProduct(type: .tipForTea, productsSKP: storeManager.myProducts) else { return }
            storeManager.showActivityIndicator = true
            storeManager.purchaseProduct(product: getTeaPrice)
            
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("☕️")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(LocalizedStringKey("На чай"))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        if let priceTea = ProductSubscriptionIDs.getSKProduct(type: .tipForTea, productsSKP: storeManager.myProducts) {
                            Text("\(priceTea.localizedPrice ?? "error" )")
                                .foregroundColor(.primaryGray())
                                .font(.robotoRegular16())
                        }
                    }
                    
                    Spacer()
                }
                Divider()
            }
        }
    }
}

private extension PurchasesView {
    var wineView: some View {
        Button(action: {
            guard let getTeaPrice = ProductSubscriptionIDs.getSKProduct(type: .tipForWine,
                                                                        productsSKP: storeManager.myProducts) else { return }
            storeManager.showActivityIndicator = true
            storeManager.purchaseProduct(product: getTeaPrice)
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("🍷")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(LocalizedStringKey("На вино"))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        if let priceTea = ProductSubscriptionIDs.getSKProduct(type: .tipForWine,
                                                                              productsSKP: storeManager.myProducts) {
                            Text("\(priceTea.localizedPrice ?? "error" )")
                                .foregroundColor(.primaryGray())
                                .font(.robotoRegular16())
                        }
                    }
                    Spacer()
                }
                Divider()
            }
        }
    }
}

private extension PurchasesView {
    var breakfastView: some View {
        Button(action: {
            guard let getTeaPrice = ProductSubscriptionIDs.getSKProduct(type: .tipForBreakfast,
                                                                        productsSKP: storeManager.myProducts) else { return }
            storeManager.showActivityIndicator = true
            storeManager.purchaseProduct(product: getTeaPrice)
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("🥣")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(LocalizedStringKey("На завтрак"))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        if let priceTea = ProductSubscriptionIDs.getSKProduct(type: .tipForBreakfast,
                                                                              productsSKP: storeManager.myProducts) {
                            Text("\(priceTea.localizedPrice ?? "error" )")
                                .foregroundColor(.primaryGray())
                                .font(.robotoRegular16())
                        }
                    }
                    Spacer()
                }
                Divider()
            }
        }
    }
}

private extension PurchasesView {
    var lunchView: some View {
        Button(action: {
            guard let getTeaPrice = ProductSubscriptionIDs.getSKProduct(type: .tipForLunch,
                                                                        productsSKP: storeManager.myProducts) else { return }
            storeManager.showActivityIndicator = true
            storeManager.purchaseProduct(product: getTeaPrice)
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("🍝")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(LocalizedStringKey("На обед"))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        if let priceTea = ProductSubscriptionIDs.getSKProduct(type: .tipForLunch,
                                                                              productsSKP: storeManager.myProducts) {
                            Text("\(priceTea.localizedPrice ?? "error" )")
                                .foregroundColor(.primaryGray())
                                .font(.robotoRegular16())
                        }
                    }
                    Spacer()
                }
                Divider()
            }
        }
    }
}

private extension PurchasesView {
    var dinnerView: some View {
        Button(action: {
            guard let getTeaPrice = ProductSubscriptionIDs.getSKProduct(type: .tipForDinner,
                                                                        productsSKP: storeManager.myProducts) else { return }
            storeManager.showActivityIndicator = true
            storeManager.purchaseProduct(product: getTeaPrice)
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("🥗")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(LocalizedStringKey("На ужин"))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        if let priceTea = ProductSubscriptionIDs.getSKProduct(type: .tipForDinner,
                                                                              productsSKP: storeManager.myProducts) {
                            Text("\(priceTea.localizedPrice ?? "error" )")
                                .foregroundColor(.primaryGray())
                                .font(.robotoRegular16())
                        }
                    }
                    Spacer()
                }
                Divider()
            }
        }
    }
}

private extension PurchasesView {
    var dateWithMyGirlView: some View {
        Button(action: {
            guard let getTeaPrice = ProductSubscriptionIDs.getSKProduct(type: .tipForDateWithMyGirlfriend,
                                                                        productsSKP: storeManager.myProducts) else { return }
            storeManager.showActivityIndicator = true
            storeManager.purchaseProduct(product: getTeaPrice)
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("🥂")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(LocalizedStringKey("На свидание с девушкой"))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        if let priceTea = ProductSubscriptionIDs.getSKProduct(type: .tipForDateWithMyGirlfriend,
                                                                              productsSKP: storeManager.myProducts) {
                            Text("\(priceTea.localizedPrice ?? "error" )")
                                .foregroundColor(.primaryGray())
                                .font(.robotoRegular16())
                        }
                    }
                    Spacer()
                }
                Divider()
            }
        }
    }
}

private extension PurchasesView {
    var tripView: some View {
        Button(action: {
            guard let getTeaPrice = ProductSubscriptionIDs.getSKProduct(type: .tipForTravel,
                                                                        productsSKP: storeManager.myProducts) else { return }
            storeManager.showActivityIndicator = true
            storeManager.purchaseProduct(product: getTeaPrice)
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("🛩")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(LocalizedStringKey("На путешествие"))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        if let priceTea = ProductSubscriptionIDs.getSKProduct(type: .tipForTravel,
                                                                              productsSKP: storeManager.myProducts) {
                            Text("\(priceTea.localizedPrice ?? "error" )")
                                .foregroundColor(.primaryGray())
                                .font(.robotoRegular16())
                        }
                    }
                    Spacer()
                }
                Divider()
            }
        }
    }
}

struct PurchasesView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasesView(storeManager: StoreManager())
    }
}
