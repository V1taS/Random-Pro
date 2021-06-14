//
//  TravelInformationView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 13.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct TravelInformationView: View {
    
    private var tourInfo: HotTravelResult.Data
    
    init(tourInfo: HotTravelResult.Data) {
        self.tourInfo = tourInfo
    }
    
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        VStack {
            listResults
        }
        .navigationBarTitle(Text(NSLocalizedString("Информация по горящему туру", comment: "")), displayMode: .inline)
    }
}

private extension TravelInformationView {
    var listResults: some View {
        List {
            
            Group {
                TravelInformationViewCell(leftText: NSLocalizedString("Страна", comment: ""),
                                          rightText: "\(tourInfo.country ?? "-")")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Город", comment: ""),
                                          rightText: "\(tourInfo.region ?? "-")")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Дата вылета", comment: ""),
                                          rightText:  "\(tourInfo.date?.formatterDate() ?? "-")")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Количество дней", comment: ""),
                                          rightText: "\(tourInfo.nights ?? 0)")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Стоимость в рублях", comment: ""),
                                          rightText: "\(priceFormatted(tourInfo.price ?? 0))")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Количество людей", comment: ""),
                                          rightText: "\(tourInfo.adults ?? 0)")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Размер скидки в %", comment: ""),
                                          rightText: "\(Int(tourInfo.discount ?? 0))")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Трансфер", comment: ""),
                                          rightText: "\(getTrueOrFalse(tourInfo.transfer))")
                
                
                TravelInformationViewCell(leftText: NSLocalizedString("Мед. страховка", comment: ""),
                                          rightText: "\(getTrueOrFalse(tourInfo.medical_insurance))")
            }
            
            Group {
                TravelInformationViewCell(leftText: NSLocalizedString("Питание", comment: ""),
                                          rightText: "\(tourInfo.pansion_description ?? "-")")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Название отеля", comment: ""),
                                          rightText: "\(tourInfo.hotel?.name ?? "-")")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Количество звезд", comment: ""),
                                          rightText: "\(tourInfo.hotel?.stars ?? 0)")
            }
            
            HStack {
                Spacer()
                buyButton
                Spacer()
            }
            
            imageDevice
        }
    }
}

// MARK: Device
private extension TravelInformationView {
     private var imageDevice: AnyView {
         switch UIDevice.current.userInterfaceIdiom == .phone {
         case true:
             return AnyView(imageIPhone)
         case false:
             return AnyView(imageIPad)
         }
     }
 }

// MARK: Image iPhone
private extension TravelInformationView {
    var imageIPhone: some View {
        WebImage(url: URL(string: "\(tourInfo.hotel?.picture ?? "")"))
            .resizable()
            .renderingMode(.original)
            .onSuccess { image, data, cacheType in }
            .placeholder(Image("no_image"))
            .indicator(.activity)
            .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 340),
                   height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 250))
            .transition(.fade(duration: 0.5))
            .aspectRatio(contentMode: .fill)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4)))
            .padding(.vertical, 24)
    }
}

// MARK: Image iPad
 private extension TravelInformationView {
     var imageIPad: some View {
        HStack {
            Spacer()
            WebImage(url: URL(string: "\(tourInfo.hotel?.picture ?? "")"))
                .resizable()
                .renderingMode(.original)
                .onSuccess { image, data, cacheType in }
                .placeholder(Image("no_image"))
                .indicator(.activity)
                .frame(width: 340,
                       height: 250)
                .transition(.fade(duration: 0.5))
                .aspectRatio(contentMode: .fill)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray4)))
                .padding(.vertical, 24)
            Spacer()
        }
     }
 }

private extension TravelInformationView {
    var buyButton: some View {
        Button(action: {
            print("TAPPP")
            openLinkTravel(link: tourInfo.link)
            Feedback.shared.impactHeavy(.medium)
        }) {
            ButtonView(textColor: .black,
                       borderColor: .white,
                       text: NSLocalizedString("Купить", comment: ""),
                       height: 30,
                       gradientForeground: [.white])
                .frame(width: 80)
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }
}

private extension TravelInformationView {
    private func priceFormatted(_ value: Double) -> String {
        return String.formatted(with: .currency, value: NSNumber(value: value))
    }
    
    private func getTrueOrFalse(_ value: Bool?) -> String {
        guard let value = value else { return "-" }
        return value ? NSLocalizedString("есть", comment: "") : NSLocalizedString("нет", comment: "")
    }
    
}

private extension TravelInformationView {
    private func openLinkTravel(link: String?) {
        print("link \(String(describing: link))")
        guard let link = link else { return }
        print("guard link \(link)")
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

struct TravelInformationView_Previews: PreviewProvider {
    static var previews: some View {
        TravelInformationView(tourInfo: HotTravelResult.Data())
    }
}
