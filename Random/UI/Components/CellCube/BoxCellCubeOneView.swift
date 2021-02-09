//
//  BoxCellCubeOneView.swift
//  Random
//
//  Created by Vitalii Sosin on 09.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct BoxCellCubeOneView: View {
    
    private var selectedCubeView: Int
    
    init(selectedCubeView: Int) {
        self.selectedCubeView = selectedCubeView
    }
    
    var body: some View {
        VStack {
            content
        }
    }
}

private extension BoxCellCubeOneView {
    private var content: AnyView {
        switch selectedCubeView {
        case 0:
            return AnyView(CellCubeOneView())
        case 1:
            return AnyView(CellCubeTwoView())
        case 2:
            return AnyView(CellCubeThreeView())
        case 3:
            return AnyView(CellCubeFourView())
        case 4:
            return AnyView(CellCubeFiveView())
        case 5:
            return AnyView(CellCubeSixView())
        default:
            return AnyView(CellCubeOneView())
        }
    }
}

struct BoxCellCubeOneView_Previews: PreviewProvider {
    static var previews: some View {
        BoxCellCubeOneView(selectedCubeView: 0)
    }
}
