//
//  LotteryScreenFactory.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 18.05.2022.
//  Copyright © 2022 SosinVitalii.com. All rights reserved.
//

import UIKit

protocol LotteryScreenFactoryOutput: AnyObject {
  
}

protocol LotteryScreenFactoryInput: AnyObject {
  
}

final class LotteryScreenFactory: LotteryScreenFactoryInput {
  
  // MARK: - Internal property
  
  weak var output: LotteryScreenFactoryOutput?
}
