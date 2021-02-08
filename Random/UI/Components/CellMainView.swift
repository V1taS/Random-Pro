//
//  CellMainView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CellMainView: View {
    
    private let image: String
    private let title: String
    
    init(image: String, title: String) {
        self.image = image
        self.title = title
    }

    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 170),
                       height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 100))
                .background(LinearGradient(gradient: Gradient(colors: [Color.primaryTertiary(), Color.primaryGreen()]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.clear)))
                .foregroundColor(.clear)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: image)
                        .renderingMode(.template)
                        .font(.title)
                        .foregroundColor(Color.primaryPale())
                    
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.horizontal, 16)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text(title)
                        .font(.robotoMedium20())
                        .foregroundColor(Color.primaryPale())
                        .lineLimit(2)
                        .frame(width: 130, alignment: .trailing)
                }
                .padding(.bottom, 8)
                .padding(.horizontal, 16)
            }
        }
        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 170),
               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 100))
    }
}

struct CellMainView_Previews: PreviewProvider {
    static var previews: some View {
        CellMainView(image: "number", title: "Число")
    }
}
