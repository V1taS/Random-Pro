//
//  CellMainLockView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 06.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CellMainLockView: View {
    
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
private extension CellMainLockView {
    var iPad: some View {
        ZStack {
            Rectangle()
                .frame(width: CGFloat(225.28), height: CGFloat(138.7192118226601))
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.2),
                                                                       Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.3)
                                                                      ]), startPoint: .trailing, endPoint: .leading))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.clear)))
                .foregroundColor(.clear)
                .shadow(radius: 4)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: image)
                        .renderingMode(.template)
                        .font(.robotoMedium32())
                        .foregroundColor(.primaryGray())
                    
                    Spacer()
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text(title)
                        .font(.robotoMedium20())
                        .foregroundColor(.primaryGray())
                        .lineLimit(2)
                        .frame(width: CGFloat(184.32), alignment: .trailing)
                }
                .padding(.bottom, 16)
                .padding(.horizontal, 16)
            }
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Image(systemName: "lock")
                        .foregroundColor(.primaryGray())
                        .font(.system(size: 24))
                }
                .padding(.top, UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 8))
                .padding(.trailing, UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 8))
                Spacer()
            }
            .opacity(0.9)
        }
        .frame(width: CGFloat(225.28), height: CGFloat(138.7192118226601))
    }
}

// MARK: iPhone
private extension CellMainLockView {
    var iPhone: some View {
        ZStack {
            Rectangle()
                .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 160),
                       height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 85))
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.2),
                                                                       Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)).opacity(0.3)
                                                                      ]), startPoint: .trailing, endPoint: .leading))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.clear)))
                .foregroundColor(.clear)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(systemName: image)
                        .renderingMode(.template)
                        .font(UIScreen.screenHeight < 570 ? .body : .title)
                        .foregroundColor(.primaryGray())
                    Spacer()
                }
                .padding(.top, 8)
                .padding(.horizontal, 8)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text(title)
                        .font(UIScreen.screenHeight < 570 ? .robotoMedium14() : .robotoMedium18())
                        .foregroundColor(.primaryGray())
                        .lineLimit(2)
                        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 130), alignment: .trailing)
                }
                .padding(.bottom, 8)
                .padding(.horizontal, 8)
            }
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Image(systemName: "lock")
                        .foregroundColor(.primaryGray())
                        .font(.system(size: 24))
                }
                .padding(.top, UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 8))
                .padding(.trailing, UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 8))
                Spacer()
            }
            .opacity(0.9)
        }
        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 160),
               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 85))
    }
}

struct CellMainLockView_Previews: PreviewProvider {
    static var previews: some View {
        CellMainLockView(image: "number", title: "Число")
    }
}

