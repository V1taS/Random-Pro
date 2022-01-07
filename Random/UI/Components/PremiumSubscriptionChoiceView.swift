//
//  PremiumSubscriptionChoiceView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct PremiumSubscriptionChoiceView: View {
    enum TypeSubscriptions {
        case non
        case years
        case monthly
        case lifelong
    }
    
    // MARK: - Private
    @State private var typeSubscriptions: TypeSubscriptions = .non
    @State private var yearsColor = false
    @State private var monthlyColor = false
    @State private var lifelongColor = false
    
    // MARK: - Public
    var buttonAction: ((TypeSubscriptions) -> Void)?
    let yearsPrimaryTitle: String
    let yearsSecondaryTitle: String?
    let yearsPrimaryDescription: String
    let yearsSecondaryDescription: String?
    
    let monthlyPrimaryTitle: String
    let monthlySecondaryTitle: String?
    let monthlyPrimaryDescription: String
    let monthlySecondaryDescription: String?
    
    let lifelongPrimaryTitle: String
    let lifelongSecondaryTitle: String?
    let lifelongPrimaryDescription: String
    let lifelongSecondaryDescription: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            yearsButton
                .onTapGesture {
                    typeSubscriptions = .years
                    changeColorButton()
                    buttonAction?(yearsColor ? .years : .non)
                }
            monthButton
                .onTapGesture {
                    typeSubscriptions = .monthly
                    changeColorButton()
                    buttonAction?(monthlyColor ? .monthly : .non)
                }
            lifePlanButton
                .onTapGesture {
                    typeSubscriptions = .lifelong
                    changeColorButton()
                    buttonAction?(lifelongColor ? .lifelong : .non)
                }
        }
    }
}

private extension PremiumSubscriptionChoiceView {
    var yearsButton: some View {
        PremiumSubscriptionComponentView(
            primaryTitle: yearsPrimaryTitle,
            secondaryTitle: yearsSecondaryTitle ?? "",
            primaryDescription: yearsPrimaryDescription,
            secondaryDescription: yearsSecondaryDescription ?? "",
            isEnabled: yearsColor
        )
    }
    
    var monthButton: some View {
        PremiumSubscriptionComponentView(
            primaryTitle: monthlyPrimaryTitle,
            secondaryTitle: monthlySecondaryTitle ?? "",
            primaryDescription: monthlyPrimaryDescription,
            secondaryDescription: monthlySecondaryDescription ?? "",
            isEnabled: monthlyColor
        )
    }
    
    var lifePlanButton: some View {
        PremiumSubscriptionComponentView(
            primaryTitle: lifelongPrimaryTitle,
            secondaryTitle: lifelongSecondaryTitle ?? "",
            primaryDescription: lifelongPrimaryDescription,
            secondaryDescription: lifelongSecondaryDescription ?? "",
            isEnabled: lifelongColor
        )
    }
}

private extension PremiumSubscriptionChoiceView {
    private func changeColorButton() {
        switch typeSubscriptions {
        case .non:
            yearsColor = false
            monthlyColor = false
            lifelongColor = false
        case .years:
            if yearsColor {
                yearsColor = false
                monthlyColor = false
                lifelongColor = false
            } else {
                yearsColor = true
                monthlyColor = false
                lifelongColor = false
            }
            
        case .monthly:
            if monthlyColor {
                yearsColor = false
                monthlyColor = false
                lifelongColor = false
            } else {
                yearsColor = false
                monthlyColor = true
                lifelongColor = false
            }
        case .lifelong:
            if lifelongColor {
                yearsColor = false
                monthlyColor = false
                lifelongColor = false
            } else {
                yearsColor = false
                monthlyColor = false
                lifelongColor = true
            }
        }
    }
}

struct PremiumSubscriptionChoiceView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumSubscriptionChoiceView(
            yearsPrimaryTitle: "Годовой план - экономия 50%",
            yearsSecondaryTitle: "",
            yearsPrimaryDescription: "1 050,00 Р / год",
            yearsSecondaryDescription: "(2 0 90,00 Р / год)",
            monthlyPrimaryTitle: "Месячный план",
            monthlySecondaryTitle: "",
            monthlyPrimaryDescription: "269,00 Р / месяц",
            monthlySecondaryDescription: "",
            lifelongPrimaryTitle: "Пожизненный план",
            lifelongSecondaryTitle: "",
            lifelongPrimaryDescription: "3 390,00 Р / месяц",
            lifelongSecondaryDescription: ""
        )
    }
}
