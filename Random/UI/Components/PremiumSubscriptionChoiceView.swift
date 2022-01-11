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
    @State private var yearsColor = true
    @State private var monthlyColor = true
    @State private var lifelongColor = true
    
    @State private var isPressedYearsButton = false
    @State private var isPressedMonthButton = false
    @State private var isPressedLifePlanButton = false
    
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
                .opacity(isPressedYearsButton ? 0.8 : 1)
                .scaleEffect(isPressedYearsButton ? 0.9 : 1)
                .animation(.easeInOut(duration: 0.1))
                .pressAction {
                    isPressedYearsButton = true
                } onRelease: {
                    isPressedYearsButton = false
                    buttonAction?(.years)
                }
            
            monthButton
                .opacity(isPressedMonthButton ? 0.8 : 1)
                .scaleEffect(isPressedMonthButton ? 0.9 : 1)
                .animation(.easeInOut(duration: 0.1))
                .pressAction {
                    isPressedMonthButton = true
                } onRelease: {
                    isPressedMonthButton = false
                    buttonAction?(.monthly)
                }
            
            lifePlanButton
                .opacity(isPressedLifePlanButton ? 0.8 : 1)
                .scaleEffect(isPressedLifePlanButton ? 0.9 : 1)
                .animation(.easeInOut(duration: 0.1))
                .pressAction {
                    isPressedLifePlanButton = true
                } onRelease: {
                    isPressedLifePlanButton = false
                    buttonAction?(.lifelong)
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
