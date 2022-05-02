//
//  TitleWithDescriptionCell.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct TitleWithDescriptionCell: View {
    
    let iconSystemName: String
    let title: String
    let description: String
    let isEnabledDivider: Bool
    
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(alignment: .center, spacing: 16) {
                Image(systemName: iconSystemName)
                    .font(.system(size: 44))
                    .gradientForeground(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))])
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .foregroundColor(.primaryGray())
                        .font(.robotoMedium18())
                    
                    Text(description)
                        .foregroundColor(.secondary)
                        .font(.robotoMedium14())
                        .lineLimit(2)
                }
                Spacer()
            }
            if isEnabledDivider {
                Divider()
            }
        }
       
        
    }
}

struct TitleWithDescriptionCell_Previews: PreviewProvider {
    static var previews: some View {
        TitleWithDescriptionCell(iconSystemName: "xmark.circle",
                                 title: "Отсутствие рекламы",
                                 description: "Полностью исключите показ рекламы в приложении",
                                 isEnabledDivider: true)
    }
}
