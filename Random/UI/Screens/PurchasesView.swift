//
//  PurchasesView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct PurchasesView: View {
    var body: some View {
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
        }
        .navigationBarTitle(Text(NSLocalizedString("Чаевые разработчику", comment: "")), displayMode: .automatic)
    }
}

private extension PurchasesView {
    var teaView: some View {
        Button(action: {
            
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("☕️")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(NSLocalizedString("Чай", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        Text(NSLocalizedString("75,00 ₽", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16())
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
            
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("🍷")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(NSLocalizedString("Вино", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        Text(NSLocalizedString("149,00 ₽", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16())
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
            
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("🥣")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(NSLocalizedString("Завтрак", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        Text(NSLocalizedString("229,00 ₽", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16())
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
            
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("🍝")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(NSLocalizedString("Обед", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        Text(NSLocalizedString("399,00 ₽", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16())
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
            
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("🥗")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(NSLocalizedString("Ужин", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        Text(NSLocalizedString("799,00 ₽", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16())
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
            
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("🥂")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(NSLocalizedString("Свидание с моей девушкой", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        Text(NSLocalizedString("1 550,00 ₽", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16())
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
            
        }) {
            VStack(spacing: 4) {
                HStack(spacing: 16) {
                    Text("🛩")
                        .font(.system(size: 50))
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(NSLocalizedString("Путешествие", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoBold25())
                        
                        Text(NSLocalizedString("2 350,00 ₽", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoRegular16())
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
        PurchasesView()
    }
}
