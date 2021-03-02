//
//  FilmCellView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 02.03.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct FilmCellView: View {
    
    init(ratingIsSwitch: Bool, ratingCount: Double, imageStr: String) {
        self.ratingIsSwitch = ratingIsSwitch
        self.ratingCount = ratingCount
        self.imageStr = imageStr
    }
    
    private var imageStr: String
    private var ratingIsSwitch: Bool
    private var ratingCount: Double
    
    private var ratingFormat: String {
        return String(format: "%.1f", ratingCount)
    }
    
    private var backgroundFormat: LinearGradient {
        switch ratingCount {
        case 0...4.9:
            return LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)), Color.primaryError()]), startPoint: .top, endPoint: .bottom)
        case 5...6.9:
            return LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))]), startPoint: .top, endPoint: .bottom)
        case 7...10:
            return LinearGradient(gradient: Gradient(colors: [Color.primaryTertiary(), Color.primaryGreen()]), startPoint: .top, endPoint: .bottom)
        default:
            return LinearGradient(gradient: Gradient(colors: [Color.primaryTertiary(), Color.primaryGreen()]), startPoint: .top, endPoint: .bottom)
            
        }
    }
    
    var body: some View {
        ZStack {
            WebImage(url: URL(string: imageStr))
                .resizable()
                .renderingMode(.original)
                .onSuccess { image, data, cacheType in }
                .placeholder(Image("no_image"))
                .indicator(.activity)
                .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 300),
                       height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 450))
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.systemGray4)))
            
            if ratingIsSwitch {
                VStack(spacing: 0) {
                    HStack {
                        Text("\(ratingFormat)")
                            .foregroundColor(.white)
                            .frame(width: 50, height: 30)
                            .lineLimit(1)
                            .font(.robotoBold25())
                            .background(backgroundFormat)
                            .cornerRadius(8)
                        Spacer()
                    }
                    .padding(.top, 16)
                    .offset(x: -13)
                    Spacer()
                }
                .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 300),
                       height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 450))
            }
        }

    }
}

struct FilmCellView_Previews: PreviewProvider {
    static var previews: some View {
        FilmCellView(ratingIsSwitch: true,
                     ratingCount: 7.33333,
                     imageStr: "")
    }
}
