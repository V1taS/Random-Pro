//
//  PurchasesView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import  StoreKit

struct PurchasesView: View {
    
    @ObservedObject var storeManager: StoreManager
    
    var body: some View {
        LoadingView(isShowing: $storeManager.showActivityIndicator){
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
            guard let getTeaPrice = getTeaPrice() else { return }
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
                        
                        if let priceTea = getTeaPrice() {
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
    func getTeaPrice() -> SKProduct? {
        let priceTea = storeManager.myProducts.filter { $0.productIdentifier == "com.sosinvitalii.Random.TipForTea" }
        return priceTea.first
    }
}

private extension PurchasesView {
    var wineView: some View {
        Button(action: {
            guard let getTeaPrice = getWinePrice() else { return }
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
                        
                        if let priceTea = getWinePrice() {
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
    func getWinePrice() -> SKProduct? {
        let priceTea = storeManager.myProducts.filter { $0.productIdentifier == "com.sosinvitalii.Random.TipForWine" }
        return priceTea.first
    }
}

private extension PurchasesView {
    var breakfastView: some View {
        Button(action: {
            guard let getTeaPrice = getBreakfastPrice() else { return }
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
                        
                        if let priceTea = getBreakfastPrice() {
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
    func getBreakfastPrice() -> SKProduct? {
        let priceTea = storeManager.myProducts.filter { $0.productIdentifier == "com.sosinvitalii.Random.TipForBreakfast" }
        return priceTea.first
    }
}

private extension PurchasesView {
    var lunchView: some View {
        Button(action: {
            guard let getTeaPrice = getLunchPrice() else { return }
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
                        
                        if let priceTea = getLunchPrice() {
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
    func getLunchPrice() -> SKProduct? {
        let priceTea = storeManager.myProducts.filter { $0.productIdentifier == "com.sosinvitalii.Random.TipForLunch" }
        return priceTea.first
    }
}

private extension PurchasesView {
    var dinnerView: some View {
        Button(action: {
            guard let getTeaPrice = getDinnerPrice() else { return }
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
                        
                        if let priceTea = getDinnerPrice() {
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
    func getDinnerPrice() -> SKProduct? {
        let priceTea = storeManager.myProducts.filter { $0.productIdentifier == "com.sosinvitalii.Random.TipForDinner" }
        return priceTea.first
    }
}

private extension PurchasesView {
    var dateWithMyGirlView: some View {
        Button(action: {
            guard let getTeaPrice = getDateWithMyGirlPrice() else { return }
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
                        
                        if let priceTea = getDateWithMyGirlPrice() {
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
    func getDateWithMyGirlPrice() -> SKProduct? {
        let priceTea = storeManager.myProducts.filter { $0.productIdentifier == "com.sosinvitalii.Random.TipForDateWithMyGirlfriend" }
        return priceTea.first
    }
}

private extension PurchasesView {
    var tripView: some View {
        Button(action: {
            guard let getTeaPrice = getTripPrice() else { return }
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
                        
                        if let priceTea = getTripPrice() {
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
    func getTripPrice() -> SKProduct? {
        let priceTea = storeManager.myProducts.filter { $0.productIdentifier == "com.sosinvitalii.Random.TipForTravel" }
        return priceTea.first
    }
}

struct PurchasesView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasesView(storeManager: StoreManager())
    }
}
