//
//  TravelImageCellView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 12.06.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct TravelImageCellView: View {
    
    private var isEnabledDiscount = true
    private var isEnabledStarsCount = true
    private var isEnabledImageStr = false
    
    init(discount: Double, starsCount: Int, imageStr: String) {
        self.discount = discount
        self.starsCount = starsCount
        self.imageStr = imageStr
        
        if discount == 0 { isEnabledDiscount = false }
        if starsCount == 0 { isEnabledStarsCount = false }
        if !imageStr.isEmpty { isEnabledImageStr = true }
    }
    
    private var imageStr: String
    private var discount: Double
    private var starsCount: Int
    
    private var discountFormat: String {
        return String(format: "%.0f", discount)
    }
    
    private var starBackgroundFormat: [Color] {
        switch starsCount {
        case 0...2:
            return [Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)), Color.primaryError()]
        case 3...4:
            return [Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)), Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))]
        default:
            return [Color.primaryTertiary(), Color.primaryGreen()]
        }
    }
    
    private var backgroundFormat: LinearGradient {
        switch discount {
        case 15...100:
            return LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)), Color.primaryError()]), startPoint: .top, endPoint: .bottom)
        case 0...4:
            return LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)), Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1))]), startPoint: .top, endPoint: .bottom)
        case 5...14:
            return LinearGradient(gradient: Gradient(colors: [Color.primaryTertiary(), Color.primaryGreen()]), startPoint: .top, endPoint: .bottom)
        default:
            return LinearGradient(gradient: Gradient(colors: [Color.primaryTertiary(), Color.primaryGreen()]), startPoint: .top, endPoint: .bottom)
        }
    }
    
    var body: some View {
        imageDevice
    }
}

// MARK: Device
private extension TravelImageCellView {
    private var imageDevice: AnyView {
        return AnyView(imageIPhone)
    }
}

// MARK: Image iPhone
private extension TravelImageCellView {
    var imageIPhone: some View {
        ZStack {
            WebImage(url: URL(string: imageStr))
                .resizable()
                .renderingMode(.original)
                .onSuccess { image, data, cacheType in }
                .placeholder(Image("no_image"))
                .indicator(.activity)
                .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 340),
                       height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 250))
                .transition(.fade(duration: 0.5))
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(16)
                .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.systemGray4)))
            
            if isEnabledImageStr {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(LinearGradient(gradient: Gradient(colors: [.clear, .primarySky().opacity(0.2)]), startPoint: .leading, endPoint: .trailing))
                    .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 340),
                           height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 250))
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16)
                                .stroke(Color(.systemGray4)))
            }
            
            if isEnabledDiscount {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text("- \(discountFormat)%")
                            .foregroundColor(.white)
                            .frame(width: 50, height: 25)
                            .lineLimit(1)
                            .font(.robotoBold14())
                            .background(backgroundFormat)
                            .cornerRadius(8)
                    }
                    .padding(.top, 16)
                    .offset(x: 13)
                    Spacer()
                }
            }
            
            if isEnabledStarsCount {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        ZStack {
                            Image(systemName: "star.fill")
                                .font(.title)
                                .foregroundColor(.red)
                                .gradientForeground(colors: starBackgroundFormat)
                            
                            Text("\(starsCount)")
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .font(.robotoBold13())
                                .offset(y: 3)
                        }
                    }
                    .padding(.top, 50)
                    .offset(x: 13)
                    Spacer()
                }
            }
        }
        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 340),
               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 250))
    }
}

struct TravelCellView_Previews: PreviewProvider {
    static var previews: some View {
        TravelImageCellView(discount: 20,
                            starsCount: 5,
                            imageStr: "")
    }
}

