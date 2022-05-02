//
//  ReversingScale.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 16.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import SwiftUI

struct ReversingScale: AnimatableModifier {
    var value: CGFloat

    private var target: CGFloat
    private var onEnded: () -> ()

    init(to value: CGFloat, onEnded: @escaping () -> () = {}) {
        self.target = value
        self.value = value
        self.onEnded = onEnded // << callback
    }

    var animatableData: CGFloat {
        get { value }
        set { value = newValue
            if newValue == target {
                onEnded()
            }
        }
    }

    func body(content: Content) -> some View {
        content.scaleEffect(value)
    }
}
