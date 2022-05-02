//
//  TextRoundView.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 17.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct TextRoundView: View {
    let name: String
    
    var body: some View {
        Text(name)
            .foregroundColor(.white)
            .font(.robotoBold25())
            .roundedEdge(startPointColor: Color(#colorLiteral(red: 0.007843137255, green: 0.7960784314, blue: 0.6705882353, alpha: 1)), endPointColor: Color(#colorLiteral(red: 0.01176470588, green: 0.6745098039, blue: 0.6941176471, alpha: 1)))
            .lineLimit(1)
    }
}

struct TextRoundView_Previews: PreviewProvider {
    static var previews: some View {
        TextRoundView(name: "1")
    }
}
