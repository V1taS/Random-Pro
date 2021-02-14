//
//  DateAndTimeSettingsView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct DateAndTimeSettingsView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Toggle(isOn: appBinding.dateAndTime.noRepetitionsDay) {
                        Text(NSLocalizedString("Без повторений (дни)", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    Toggle(isOn: appBinding.dateAndTime.noRepetitionsDate) {
                        Text(NSLocalizedString("Без повторений (даты)", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    Toggle(isOn: appBinding.dateAndTime.noRepetitionsMonth) {
                        Text(NSLocalizedString("Без повторений (месяцы)", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Cгенерировано:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.dateAndTime.listResult.wrappedValue.count)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        Text(NSLocalizedString("Последнее значение:", comment: ""))
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                        Spacer()
                        
                        Text("\(appBinding.dateAndTime.listResult.wrappedValue.last ?? NSLocalizedString("нет", comment: ""))")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                    
                    HStack {
                        NavigationLink(
                            destination: DateAndTimeResultsView(appBinding: appBinding)
                                .allowAutoDismiss { false }) {
                            Text(NSLocalizedString("Результат генерации", comment: ""))
                                .foregroundColor(.primaryGray())
                                .font(.robotoMedium18())
                        }
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            cleanDay(state: appBinding)
                            cleanDate(state: appBinding)
                            cleanMonth(state: appBinding)
                            saveDayToUserDefaults(state: appBinding)
                            Feedback.shared.impactHeavy(.medium)
                        }) {
                            Text(NSLocalizedString("Очистить", comment: ""))
                                .font(.robotoRegular16())
                        }
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(Text(NSLocalizedString("Настройки", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                appBinding.dateAndTime.showSettings.wrappedValue = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.primaryGray())
            })
        }
    }
}

// MARK: Actions clean Day
private extension DateAndTimeSettingsView {
    private func cleanDay(state: Binding<AppState.AppData>) {
        injected.interactors.dateAndTimeInteractor
            .cleanDay(state: state)
    }
}

// MARK: Actions clean Date
private extension DateAndTimeSettingsView {
    private func cleanDate(state: Binding<AppState.AppData>) {
        injected.interactors.dateAndTimeInteractor
            .cleanDate(state: state)
    }
}

// MARK: Actions clean Month
private extension DateAndTimeSettingsView {
    private func cleanMonth(state: Binding<AppState.AppData>) {
        injected.interactors.dateAndTimeInteractor
            .cleanMonth(state: state)
    }
}

private extension DateAndTimeSettingsView {
    private func saveDayToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.dateAndTimeInteractor
            .saveDayToUserDefaults(state: state)
    }
}

struct DateAndTimeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        DateAndTimeSettingsView(appBinding: .constant(.init()))
    }
}
