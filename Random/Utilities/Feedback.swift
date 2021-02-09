//
//  Feedback.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 09.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import UIKit

class Feedback {
    
    static let shared = Feedback()
    private init() {}
    func impactHeavy(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
        let impactHeavy = UIImpactFeedbackGenerator(style: feedbackStyle)
                    impactHeavy.impactOccurred()
    }
}
