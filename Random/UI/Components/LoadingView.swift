//
//  LoadingView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct LoadingView<Content>: View where Content: View {

    @Binding var isShowing: Bool
    var content: () -> Content

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .center) {

                self.content()
                    .disabled(self.isShowing)
                    .blur(radius: self.isShowing ? 3 : 0)

                VStack {
                    Text(LocalizedStringKey("Загрузка..."))
                    ActivityIndicator(isAnimating: .constant(true), style: .large)
                }
                .frame(width: geometry.size.width / 2,
                       height: geometry.size.height / 5)
                .background(Color.secondary.colorInvert())
                .foregroundColor(Color.primaryGray())
                .cornerRadius(20)
                .opacity(self.isShowing ? 1 : 0)
                .offset(y: -80)

            }
        }
    }
}
