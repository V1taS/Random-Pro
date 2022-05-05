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
    private var actionButton: (() -> Void)?
    
    init(appBinding: Binding<AppState.AppData>, actionButton: (() -> Void)?) {
        self.appBinding = appBinding
        self.actionButton = actionButton
    }
    @Environment(\.injected) private var injected: DIContainer
    
    @State private var isPressedButtonDay = false
    @State private var isPressedButtonTime = false
    @State private var isPressedButtonDate = false
    @State private var isPressedButtonMonth = false
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(appBinding.dateAndTime.result.wrappedValue)")
                .font(.robotoBold50())
                .foregroundColor(.primaryGray())
                .opacity(isPressedButtonMonth || isPressedButtonDate ||
                            isPressedButtonTime || isPressedButtonDay ? 0.8 : 1)
                .scaleEffect(isPressedButtonMonth || isPressedButtonDate ||
                                isPressedButtonTime || isPressedButtonDay ? 0.8 : 1)
                .animation(.easeInOut(duration: 0.2), value: isPressedButtonMonth ||
                            isPressedButtonDate || isPressedButtonTime ||
                            isPressedButtonDay)
            
            Spacer()
            listResults
            generateButton
        }.onAppear(perform: {
            AppMetrics.trackEvent(name: .dateAndTimeScreen)
        })
        .navigationBarTitle(Text(NSLocalizedString("Дата и время", comment: "")), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            appBinding.dateAndTime.showSettings.wrappedValue.toggle()
        }) {
            Image(systemName: "gear")
                .font(.system(size: 24))
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
                    actionButton?()
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    ButtonView(textColor: .primaryPale(),
                               borderColor: .primaryPale(),
                               text: NSLocalizedString("День", comment: ""),
                               switchImage: false,
                               image: "")
                }
                .opacity(isPressedButtonDay ? 0.8 : 1)
                .scaleEffect(isPressedButtonDay ? 0.9 : 1)
                .animation(.easeInOut(duration: 0.1))
                .pressAction {
                    isPressedButtonDay = true
                } onRelease: {
                    isPressedButtonDay = false
                }
                
                Button(action: {
                    generateTime(state: appBinding)
                    saveDayToUserDefaults(state: appBinding)
                    actionButton?()
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    ButtonView(textColor: .primaryPale(),
                               borderColor: .primaryPale(),
                               text: NSLocalizedString("Время", comment: ""),
                               switchImage: false,
                               image: "")
                }
                .opacity(isPressedButtonTime ? 0.8 : 1)
                .scaleEffect(isPressedButtonTime ? 0.9 : 1)
                .animation(.easeInOut(duration: 0.1))
                .pressAction {
                    isPressedButtonTime = true
                } onRelease: {
                    isPressedButtonTime = false
                }
                
            }
            
            HStack {
                Button(action: {
                    generateDate(state: appBinding)
                    saveDayToUserDefaults(state: appBinding)
                    actionButton?()
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    ButtonView(textColor: .primaryPale(),
                               borderColor: .primaryPale(),
                               text: NSLocalizedString("Дата", comment: ""),
                               switchImage: false,
                               image: "")
                }
                .opacity(isPressedButtonDate ? 0.8 : 1)
                .scaleEffect(isPressedButtonDate ? 0.9 : 1)
                .animation(.easeInOut(duration: 0.1))
                .pressAction {
                    isPressedButtonDate = true
                } onRelease: {
                    isPressedButtonDate = false
                }
                
                Button(action: {
                    generateMonth(state: appBinding)
                    saveDayToUserDefaults(state: appBinding)
                    actionButton?()
                    Feedback.shared.impactHeavy(.medium)
                }) {
                    ButtonView(textColor: .primaryPale(),
                               borderColor: .primaryPale(),
                               text: NSLocalizedString("Месяц", comment: ""),
                               switchImage: false,
                               image: "")
                }
                .opacity(isPressedButtonMonth ? 0.8 : 1)
                .scaleEffect(isPressedButtonMonth ? 0.9 : 1)
                .animation(.easeInOut(duration: 0.1))
                .pressAction {
                    isPressedButtonMonth = true
                } onRelease: {
                    isPressedButtonMonth = false
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
                ForEach(Array(appBinding.dateAndTime.listResult
                                .wrappedValue.enumerated()), id: \.0) { (index, element) in
                    
                    if index == 0 {
                        TextRoundView(name: "\(element)")
                            .opacity(isPressedButtonMonth || isPressedButtonDate ||
                                        isPressedButtonTime || isPressedButtonDay ? 0.8 : 1)
                            .scaleEffect(isPressedButtonMonth || isPressedButtonDate ||
                                            isPressedButtonTime || isPressedButtonDay ? 0.9 : 1)
                            .animation(.easeInOut(duration: 0.1), value: isPressedButtonMonth ||
                                        isPressedButtonDate || isPressedButtonTime ||
                                        isPressedButtonDay)
                    } else {
                        Text("\(element)")
                            .foregroundColor(.primaryGray())
                            .font(.robotoMedium18())
                    }
                }
            }
            .padding(.leading, 16)
            .padding(.vertical, 16)
        }
    }
}

// MARK: Actions Day
private extension DateAndTimeView {
    private func generateDay(state: Binding<AppState.AppData>) {
        injected.interactors.dateAndTimeInteractor
            .generateDay(state: state)
    }
}

// MARK: Actions Date
private extension DateAndTimeView {
    private func generateDate(state: Binding<AppState.AppData>) {
        injected.interactors.dateAndTimeInteractor
            .generateDate(state: state)
    }
}

// MARK: Actions Month
private extension DateAndTimeView {
    private func generateMonth(state: Binding<AppState.AppData>) {
        injected.interactors.dateAndTimeInteractor
            .generateMonth(state: state)
    }
}

// MARK: Actions Time
private extension DateAndTimeView {
    private func generateTime(state: Binding<AppState.AppData>) {
        injected.interactors.dateAndTimeInteractor
            .generateTime(state: state)
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
        DateAndTimeView(appBinding: .constant(.init()), actionButton: nil)
    }
}
