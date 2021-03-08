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
                .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 110),
                       height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 110))
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
                        .font(.robotoMedium24())
                        .foregroundColor(Color.primaryPale())
                        .lineLimit(2)
                        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 90), alignment: .trailing)
                }
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
            }
        }
        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 110),
               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 110))
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
                        .font(.title)
                        .foregroundColor(Color.primaryPale())
                    
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.horizontal, 8)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text(title)
                        .font(.robotoMedium18())
                        .foregroundColor(Color.primaryPale())
                        .lineLimit(2)
                        .frame(width: 130, alignment: .trailing)
                }
                .padding(.bottom, 8)
                .padding(.horizontal, 8)
            }
        }
        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 160),
               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 85))
    }
}

struct CellMainView_Previews: PreviewProvider {
    static var previews: some View {
        CellMainView(image: "number", title: "Число")
    }
}
