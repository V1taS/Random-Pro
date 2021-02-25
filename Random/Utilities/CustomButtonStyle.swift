//
//  CustomButtonStyle.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 25.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        return configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.8 : 1)
            .animation(.easeInOut(duration: 0.2))
    }
}


//struct CustomButtonStyle<Content>: ButtonStyle where Content: View {
//    var change: (Bool) -> Content
//
//    func makeBody(configuration: Self.Configuration) -> some View {
//        return change(configuration.isPressed)
//    }
//}
