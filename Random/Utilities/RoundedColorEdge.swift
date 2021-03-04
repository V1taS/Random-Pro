//
//  RoundedColorEdge.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct RoundedColorEdge: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .fixedSize(horizontal: true, vertical: true)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1))]), startPoint: .trailing, endPoint: .leading))
            .cornerRadius(6)
            .overlay(RoundedRectangle(cornerRadius: 6)
                        .stroke(Color.clear))
    }
}

extension View {
    func roundedEdge() -> some View {
        self.modifier(RoundedColorEdge())
    }
}
