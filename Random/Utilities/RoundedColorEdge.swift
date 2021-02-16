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
            .background(LinearGradient(gradient: Gradient(colors: [Color.primaryTertiary(), Color.primaryGreen()]), startPoint: .top, endPoint: .bottom))
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
