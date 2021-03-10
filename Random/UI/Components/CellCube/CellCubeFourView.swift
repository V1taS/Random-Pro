//
//  CellCubeFourView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CellCubeFourView: View {
    var body: some View {
        cube
    }
}

// MARK: Device
private extension CellCubeFourView {
    private var cube: AnyView {
        switch UIDevice.current.userInterfaceIdiom == .phone {
        case true:
            return AnyView(cubeIPhone)
        case false:
            return AnyView(cubeiPad)
        }
    }
}

// MARK: Cube IPhone
private extension CellCubeFourView {
    var cubeIPhone: some View {
        ZStack {
            Rectangle()
                .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 100),
                       height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 100))
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))]), startPoint: .trailing, endPoint: .leading))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.clear)))
                .foregroundColor(.clear)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Circle()
                        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 20),
                               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 20))
                    Spacer()
                    
                    Circle()
                        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 20),
                               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 20))
                }
                .padding(.top, 14)
                .padding(.horizontal, 14)
                
                Spacer()

                
                HStack {
                    Circle()
                        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 20),
                               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 20))
                    
                    Spacer()
                    Circle()
                        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 20),
                               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 20))
                }
                .padding(.bottom, 14)
                .padding(.horizontal, 14)

            }
        }
        .frame(width: UIScreen.screenWidth * Size.shared.getAdaptSizeWidth(px: 100),
               height: UIScreen.screenHeight * Size.shared.getAdaptSizeHeight(px: 100))
    }
}

// MARK: Cube iPad
private extension CellCubeFourView {
    var cubeiPad: some View {
        ZStack {
            Rectangle()
                .frame(width: 100, height: 100)
                .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))]), startPoint: .trailing, endPoint: .leading))
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.clear)))
                .foregroundColor(.clear)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Circle()
                        .frame(width: 20, height: 20)
                    Spacer()
                    
                    Circle()
                        .frame(width: 20, height: 20)
                }
                .padding(.top, 14)
                .padding(.horizontal, 14)
                
                Spacer()

                
                HStack {
                    Circle()
                        .frame(width: 20, height: 20)
                    
                    Spacer()
                    Circle()
                        .frame(width: 20, height: 20)
                }
                .padding(.bottom, 14)
                .padding(.horizontal, 14)

            }
        }
        .frame(width: 100, height: 100)
    }
}

struct CellCubeFourView_Previews: PreviewProvider {
    static var previews: some View {
        CellCubeFourView()
    }
}
