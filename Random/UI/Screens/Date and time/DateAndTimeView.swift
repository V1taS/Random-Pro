//
//  DateAndTimeView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct DateAndTimeView: View {
    private var appBinding: Binding<AppState.AppData>
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
    }
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(appBinding.dateAndTime.result.wrappedValue)")
                .font(.robotoBold70())
                .foregroundColor(.primaryGray())

            Spacer()
            listResults
            generateButton
        }
        .navigationBarTitle(Text(NSLocalizedString("Дата и время", comment: "")), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            appBinding.dateAndTime.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
        })
        .sheet(isPresented: appBinding.dateAndTime.showSettings, content: {
            DateAndTimeSettingsView(appBinding: appBinding)
        })
    }
}

private extension DateAndTimeView {
    var generateButton: some View {
        VStack {
            HStack {
                Button(action: {
                    generateDay(state: appBinding)
                    saveDayToUserDefaults(state: appBinding)
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    ButtonView(background: .primaryTertiary(),
                               textColor: .primaryPale(),
                               borderColor: .primaryPale(),
                               text: NSLocalizedString("День", comment: ""),
                               switchImage: false,
                               image: "")
                }
                
                Button(action: {
        //            generateYesOrNo(state: appBinding)
        //            saveYesOrNotToUserDefaults(state: appBinding)
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    ButtonView(background: .primaryTertiary(),
                               textColor: .primaryPale(),
                               borderColor: .primaryPale(),
                               text: NSLocalizedString("Время", comment: ""),
                               switchImage: false,
                               image: "")
                }
                
            }
            
            HStack {
                Button(action: {
        //            generateYesOrNo(state: appBinding)
        //            saveYesOrNotToUserDefaults(state: appBinding)
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    ButtonView(background: .primaryTertiary(),
                               textColor: .primaryPale(),
                               borderColor: .primaryPale(),
                               text: NSLocalizedString("Дата", comment: ""),
                               switchImage: false,
                               image: "")
                }
                
                Button(action: {
        //            generateYesOrNo(state: appBinding)
        //            saveYesOrNotToUserDefaults(state: appBinding)
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    ButtonView(background: .primaryTertiary(),
                               textColor: .primaryPale(),
                               borderColor: .primaryPale(),
                               text: NSLocalizedString("Месяц", comment: ""),
                               switchImage: false,
                               image: "")
                }
                
            }
            
            
        }
        .padding(16)
    }
}

private extension DateAndTimeView {
    var listResults: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(appBinding.dateAndTime.listResult.wrappedValue, id: \.self) { element in
                    
                    Text("\(element)")
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                }
            }
            .padding(.leading, 16)
            .padding(.vertical, 16)
        }
    }
}

// MARK: Actions
private extension DateAndTimeView {
    private func generateDay(state: Binding<AppState.AppData>) {
        injected.interactors.dateAndTimeInteractor
            .generateDay(state: state)
    }
}

private extension DateAndTimeView {
    private func saveDayToUserDefaults(state: Binding<AppState.AppData>) {
        injected.interactors.dateAndTimeInteractor
            .saveDayToUserDefaults(state: state)
    }
}

struct DateAndTimeView_Previews: PreviewProvider {
    static var previews: some View {
        DateAndTimeView(appBinding: .constant(.init()))
    }
}
