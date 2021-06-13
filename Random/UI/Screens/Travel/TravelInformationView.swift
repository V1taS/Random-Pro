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
    private var appBinding: Binding<AppState.AppData>
    
    init(appBinding: Binding<AppState.AppData>) {
        self.appBinding = appBinding
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
                                          rightText: "Россия")

                TravelInformationViewCell(leftText: NSLocalizedString("Город", comment: ""),
                                          rightText: "Москва")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Дата вылета", comment: ""),
                                          rightText: "26 мая")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Количество дней", comment: ""),
                                          rightText: "7")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Стоимость в рублях", comment: ""),
                                          rightText: "200 000 Р")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Количество людей", comment: ""),
                                          rightText: "2")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Размер скидки в %", comment: ""),
                                          rightText: "20")

                TravelInformationViewCell(leftText: NSLocalizedString("Трансфер включен", comment: ""),
                                          rightText: "да")
           
                
                TravelInformationViewCell(leftText: NSLocalizedString("Мед. страховка включена", comment: ""),
                                          rightText: "да")
            }
            
            Group {
                TravelInformationViewCell(leftText: NSLocalizedString("Питание", comment: ""),
                                          rightText: "Без питания")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Название отеля", comment: ""),
                                          rightText: "Elysium Gallery Hotel")
                
                TravelInformationViewCell(leftText: NSLocalizedString("Количество звезд", comment: ""),
                                          rightText: "5")
            }
            
            WebImage(url: URL(string: ""))
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
}

struct TravelInformationView_Previews: PreviewProvider {
    static var previews: some View {
        TravelInformationView(appBinding: .constant(.init()))
    }
}
