//
//  TravelView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 14.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import Combine

struct TravelView: View {
    
    private var appBinding: Binding<AppState.AppData>
    private var actionButton: (() -> Void)?
    
    init(appBinding: Binding<AppState.AppData>, actionButton: (() -> Void)?) {
        self.appBinding = appBinding
        self.actionButton = actionButton
    }
    @Environment(\.injected) private var injected: DIContainer
    @State private var isPressedButton = false
    @State private var isPressedButtonMini = false
    @State var place = [NSLocalizedString("Популярные", comment: ""),
                        NSLocalizedString("Острова", comment: ""),
                        NSLocalizedString("Везде", comment: "")
    ]
    @State var departure = [NSLocalizedString("Сегодня", comment: ""),
                            NSLocalizedString("Неделя", comment: ""),
                            NSLocalizedString("Месяц", comment: "")
    ]
    
    var body: some View {
        LoadingView(isShowing: appBinding.travel.showActivityIndicator) {
            ZStack {
                Color(.clear)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    //                    pickerView
                    pickerViewSelectedDeparture
                    content
                    Spacer()
                    generateButton
                }
            }
            .dismissingKeyboard()
            
            .navigationBarTitle(Text(NSLocalizedString("Горящие туры", comment: "")), displayMode: .inline)
            .navigationBarItems(trailing: navigationButtonGear)
            
            .sheet(isPresented: appBinding.travel.showSettings,
                   onDismiss: {
                    //                    cleanContentOnDismissSetting()
                   }
                   , content: {
                    TravelSettingsView(appBinding: appBinding)
                   })
            .onAppear {
                AppMetrics.trackEvent(name: .travelScreen)
                getTravel(state: appBinding) {
                    getCurrentTravel(state: appBinding)
                }
            }
        }
    }
}

private extension TravelView {
    private var content: AnyView {
        switch appBinding.travel.selectedPlace.wrappedValue {
        case 0:
            return AnyView(russia)
        case 1:
            return AnyView(russia)
        case 2:
            return AnyView(russia)
        default:
            return AnyView(russia)
        }
    }
}

private extension TravelView {
    var russia: some View {
        VStack(spacing: 0) {
            TravelImageCellView(discount: appBinding.travel.travelRussiaInfo.discount.wrappedValue ?? 0, starsCount: appBinding.travel.travelRussiaInfo.wrappedValue.hotel?.stars ?? 0, imageStr: appBinding.travel.travelRussiaInfo.wrappedValue.hotel?.picture ?? "")
                .padding(.top, 24)
            
            TravelMiddleContentCellView(leftTitle: NSLocalizedString("СТРАНА", comment: ""),
                                        leftValue: "\(appBinding.travel.travelRussiaInfo.country.wrappedValue ?? "-")",
                                        rightTitle: NSLocalizedString("ДЛИТЕЛЬНОСТЬ", comment: "-"),
                                        rightValue: "\(numberOfNightsFormatted(appBinding.travel.travelRussiaInfo.nights.wrappedValue ?? 0, "number_of_nights_in_tour"))")
                .padding(.top, 24)
            
            TravelMiddleContentCellView(leftTitle: NSLocalizedString("КТО ПОЕДЕТ", comment: ""),
                                        leftValue: "\(numberOfNightsFormatted(appBinding.travel.travelRussiaInfo.adults.wrappedValue ?? 0, "number_of_adults_in_tour"))",
                                        rightTitle: NSLocalizedString("ДАТА ВЫЛЕТА", comment: ""),
                                        rightValue: "\(appBinding.travel.travelRussiaInfo.date.wrappedValue?.formatterDate() ?? "-")")
                .padding(.top, 12)
            
            
            buyButton
        }
        
    }
}

private extension TravelView {
    var pickerView: some View {
        VStack {
            Picker(selection: appBinding.travel.selectedPlace,
                   label: Text("Picker")) {
                ForEach(0..<place.count, id: \.self) {
                    Text("\(place[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

private extension TravelView {
    var buyButton: some View {
        VStack(spacing: 0) {
            Text("\(priceFormatted(appBinding.travel.travelRussiaInfo.price.wrappedValue ?? 0))")
                .font(UIScreen.screenHeight < 700 ? .robotoBold25() : .robotoBold30())
                .lineLimit(2)
                .padding(.horizontal, 24)
                .padding(.top, UIScreen.screenHeight < 700 ? 12 : 24)
            
            Button(action: {
                openLinkTravel(link: appBinding.travel.travelRussiaInfo.link.wrappedValue)
                Feedback.shared.impactHeavy(.medium)
            }) {
                ButtonView(textColor: .primaryPale(),
                           borderColor: .primaryPale(),
                           text: NSLocalizedString("Купить", comment: ""),
                           height: 30,
                           gradientForeground: [.black])
                    .frame(width: 80)
            }
            .opacity(isPressedButtonMini ? 0.8 : 1)
            .scaleEffect(isPressedButtonMini ? 0.9 : 1)
            .animation(.easeInOut(duration: 0.1))
            .pressAction {
                isPressedButtonMini = true
            } onRelease: {
                isPressedButtonMini = false
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            
        }
    }
}

private extension TravelView {
    var generateButton: some View {
        Button(action: {
            getTravel(state: appBinding)
            getCurrentTravel(state: appBinding)
            actionButton?()
            Feedback.shared.impactHeavy(.medium)
        }) {
            ButtonView(textColor: .primaryPale(),
                       borderColor: .primaryPale(),
                       text: NSLocalizedString("Сгенерировать", comment: ""),
                       switchImage: false,
                       image: "")
        }
        .opacity(isPressedButton ? 0.8 : 1)
        .scaleEffect(isPressedButton ? 0.9 : 1)
        .animation(.easeInOut(duration: 0.1))
        .pressAction {
            isPressedButton = true
        } onRelease: {
            isPressedButton = false
        }
        .padding(16)
    }
}

private var isEnabledSelectedDepartureOne = false
private var isEnabledSelectedDepartureTwo = true
private var isEnabledSelectedDepartureThree = true

private extension TravelView {
    var pickerViewSelectedDeparture: some View {
        VStack {
            Picker(selection: appBinding.travel.selectedDeparture,
                   label: Text("Picker")) {
                ForEach(0..<departure.count, id: \.self) {
                    Text("\(departure[$0])")
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .onReceive(Just(appBinding.travel.selectedDeparture.wrappedValue)) { value in
            
            switch value {
            case 0:
                if isEnabledSelectedDepartureOne {
                    if appBinding.travel.travelRussiaData.wrappedValue.isEmpty {
                        appBinding.travel.travelRussiaData.wrappedValue = []
                        getTravel(state: appBinding) {
                            getCurrentTravel(state: appBinding)
                        }
                    }
                    isEnabledSelectedDepartureOne = false
                    isEnabledSelectedDepartureTwo = true
                    isEnabledSelectedDepartureThree = true
                }
            case 1:
                if isEnabledSelectedDepartureTwo {
                    if appBinding.travel.travelRussiaData.wrappedValue.isEmpty {
                        appBinding.travel.travelRussiaData.wrappedValue = []
                        getTravel(state: appBinding) {
                            getCurrentTravel(state: appBinding)
                        }
                    }
                    isEnabledSelectedDepartureOne = true
                    isEnabledSelectedDepartureTwo = false
                    isEnabledSelectedDepartureThree = true
                }
            default:
                if isEnabledSelectedDepartureThree {
                    if appBinding.travel.travelRussiaData.wrappedValue.isEmpty {
                        appBinding.travel.travelRussiaData.wrappedValue = []
                        getTravel(state: appBinding) {
                            getCurrentTravel(state: appBinding)
                        }
                    }
                    isEnabledSelectedDepartureOne = true
                    isEnabledSelectedDepartureTwo = true
                    isEnabledSelectedDepartureThree = false
                }
            }
        }
    }
}

private extension TravelView {
    var navigationButtonGear: some View {
        VStack {
            if !appBinding.travel.travelRussiaHistory.wrappedValue.isEmpty {
                Button(action: {
                    appBinding.travel.showSettings.wrappedValue.toggle()
                }) {
                    Image(systemName: "gear")
                        .font(.system(size: 24))
                }
            }
        }
    }
}

private extension TravelView {
    private func priceFormatted(_ value: Double) -> String {
        return String.formatted(with: .currency, value: NSNumber(value: value))
    }
    
    private func numberOfNightsFormatted(_ value: Int, _ localizedString: String) -> String {
        let localizedString = NSLocalizedString(localizedString, comment: "")
        let resultString = String.localizedStringWithFormat(localizedString, value)
        return resultString
    }
}

private extension TravelView {
    private func getCurrentTravel(state: Binding<AppState.AppData>) {
        injected.interactors.travelInteractor
            .getCurrentTravel(state: state)
    }
    
    private func getTravel(state: Binding<AppState.AppData>, _ completion: (() -> Void)? = nil) {
        injected.interactors.travelInteractor
            .getTravel(state: state, completion: completion)
    }
}

private extension TravelView {
    private func openLinkTravel(link: String?) {
        guard let link = link else { return }
        let httpsUrl = "https://tp.media/r?marker=314946&trs=53541&p=660&u=https%3A%2F%2Flevel.travel%2F\(link)"
        if let url = URL(string: httpsUrl) {
            DispatchQueue.main.async {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:])
                }
            }
        }
    }
}

struct TravelView_Previews: PreviewProvider {
    static var previews: some View {
        TravelView(appBinding: .constant(.init()), actionButton: nil)
    }
}
