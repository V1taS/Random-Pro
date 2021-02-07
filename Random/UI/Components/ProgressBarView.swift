//
//  ProgressBarView.swift
//  Random
//
//  Created by Vitalii Sosin on 08.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct ProgressBarView: View {
    let height = UIScreen.screenHeight
    let width = UIScreen.screenWidth
    @Binding var value: Float
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: width * Size.shared.getAdaptSizeWidth(px: 160),
                       height: height * Size.shared.getAdaptSizeHeight(px: 5))
                .opacity(0.3)
                .foregroundColor(Color.primaryDefault())
            
            Rectangle()
                .frame(width: min(CGFloat(self.value) * width * Size.shared.getAdaptSizeWidth(px: 160), width * Size.shared.getAdaptSizeWidth(px: 160)),
                       height: height * Size.shared.getAdaptSizeHeight(px: 5))
                .foregroundColor(Color.primarySky())
                .animation(.linear)
        }
        .cornerRadius(5)
        .padding(.top, height * Size.shared.getAdaptSizeHeight(px: 16))
    }
}

struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView(value: .constant(0.5))
    }
}
