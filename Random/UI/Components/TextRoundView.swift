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
            .roundedEdge()
            .lineLimit(1)
    }
}

struct TextRoundView_Previews: PreviewProvider {
    static var previews: some View {
        TextRoundView(name: "1")
    }
}
