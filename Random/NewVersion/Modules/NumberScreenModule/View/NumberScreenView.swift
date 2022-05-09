//
//  NumberScreenView.swift
//  Random Pro
//
//  Created by Tatiana Sosina on 09.05.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import UIKit

protocol NumberScreenViewOutput: AnyObject {
    
}

protocol NumberScreenViewInput: AnyObject {
    
}

typealias NumberScreenViewProtocol = UIView & NumberScreenViewInput

final class NumberScreenView: NumberScreenViewProtocol {
    
    // MARK: - Internal property
    
    weak var output: NumberScreenViewOutput?
    
    // MARK: - Internal func
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
