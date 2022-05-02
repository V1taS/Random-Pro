//
//  CloudList.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 30.01.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import CloudKit
import UIKit

struct CloudList {
    
    // MARK: - Public variables
    
    public static let recordType = "List"
    
    public var record: CKRecord
    
    public var element: String {
        get {
            return self.record.value(forKey: CloudList.keyElement) as! String
        }
        set {
            self.record.setValue(newValue, forKey: CloudList.keyElement)
        }
    }
    
    // MARK: - Private variables
    
    private static let keyElement = "element"
    
    // MARK: - Init
    
    init(record: CKRecord) {
        self.record = record
    }
    
    init() {
        record = CKRecord(recordType: CloudList.recordType)
    }
}

