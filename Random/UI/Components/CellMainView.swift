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
    private let isLabelDisabled: Bool
    private let textLabel: String
    
    init(image: String, title: String, isLabelDisabled: Bool, textLabel: String) {
        self.image = image
        self.title = title
        self.isLabelDisabled = isLabelDisabled
        self.textLabel = textLabel
    }
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .pad {
            iPad
        } else {
            iPhone
        }
    }
}

// MARK: iPAD
private extension CellMainView {
    var iPad: some View {
        ZStack {
            Rectangle()
                .frame(width: CGFloat(225.28), height: CGFloat(138.7192118226601))
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))]), startPoint: .trailing, endPoint: .leading))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.clear)))
                .foregroundColor(.clear)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: image)
                        .renderingMode(.template)
                        .font(.robotoMedium32())
                        .foregroundColor(Color.primaryPale())
                    
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text(title)
                        .font(.robotoMedium20())
                        .foregroundColor(Color.primaryPale())
                        .lineLimit(2)
                        .frame(width: CGFloat(184.32), alignment: .trailing)
                }
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
            }
        }
        .frame(width: CGFloat(225.28), height: CGFloat(138.7192118226601))
    }
}

// MARK: iPhone
private extension CellMainView {
    var iPhone: some View {
        ZStack {
            Rectangle()
                .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 160),
                       height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 85))
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))]), startPoint: .trailing, endPoint: .leading))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.clear)))
                .foregroundColor(.clear)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: image)
                        .renderingMode(.template)
                        .font(UIScreen.screenHeight < 570 ? .body : .title)
                        .foregroundColor(Color.primaryPale())
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.horizontal, 8)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text(title)
                        .font(UIScreen.screenHeight < 570 ? .robotoMedium14() : .robotoMedium18())
                        .foregroundColor(Color.primaryPale())
                        .lineLimit(2)
                        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 130), alignment: .trailing)
                }
                .padding(.bottom, 8)
                .padding(.horizontal, 8)
            }
            
            if !isLabelDisabled {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Text(textLabel)
                            .foregroundColor(.white)
                            .frame(width: UIScreen.screenHeight < 570 ?
                                    UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 50) :
                                    UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 50),
                                   height: UIScreen.screenHeight < 570 ?
                                    UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 24) :
                                    UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 20))
                            .lineLimit(1)
                            .font(UIScreen.screenHeight < 570 ? .robotoBold8() : .robotoBold10())
                            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)), Color.primaryError()]), startPoint: .top, endPoint: .bottom))
                            .cornerRadius(UIScreen.screenHeight < 570 ? 6 : 8)
                    }
                    .padding(.top, UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 8))
                    .padding(.trailing, UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 8))
                    Spacer()
                }
                .opacity(0.9)
            }
        }
        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 160),
               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 85))
    }
}

struct CellMainView_Previews: PreviewProvider {
    static var previews: some View {
        CellMainView(image: "number", title: "Число", isLabelDisabled: false, textLabel: "HIT")
    }
}
