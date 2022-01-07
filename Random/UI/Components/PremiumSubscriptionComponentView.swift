//
//  PremiumSubscriptionComponentView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct PremiumSubscriptionComponentView: View {
    let primaryTitle: String
    let secondaryTitle: String
    
    let primaryDescription: String
    let secondaryDescription: String
    
    let isEnabled: Bool
    
    private let borderColorIsOff = LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))]), startPoint: .topLeading, endPoint: .bottomTrailing)
    
    private let borderColorIsOn = LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))]), startPoint: .trailing, endPoint: .leading)
    
    var body: some View {
        button
    }
}

private extension PremiumSubscriptionComponentView {
    var button: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                
                HStack(alignment: .center, spacing: 16) {
                    Text(primaryTitle)
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                        .lineLimit(1)
                    
                    Text(secondaryTitle)
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                        .strikethrough(true)
                        .lineLimit(1)
                }
                
                HStack(alignment: .center, spacing: 16) {
                    Text(primaryDescription)
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                        .lineLimit(1)
                    
                    Text(secondaryDescription)
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                        .strikethrough(true)
                        .lineLimit(1)
                }
                
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.01))
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(isEnabled ? borderColorIsOn : borderColorIsOff, lineWidth: 4))
    }
}

struct PremiumSubscriptionComponentView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumSubscriptionComponentView(primaryTitle: "Годовой план - экономия 50%", secondaryTitle: "", primaryDescription: "1 050,00 Р / год", secondaryDescription: "(2 0 90,00 Р / год)", isEnabled: true)
    }
}
