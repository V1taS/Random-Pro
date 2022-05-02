//
//  CloudCurrentAppVersion.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 20.02.2022.
//  Copyright © 2022 Sosin.bet. All rights reserved.
//

import CloudKit
import UIKit

struct CloudCurrentAppVersion {
    
    // MARK: - Public variables
    
    public static let recordType = "CurrentAppVersion"
    
    public var record: CKRecord
    
    public var element: String {
        get {
            return self.record.value(forKey: CloudCurrentAppVersion.keyElement) as! String
        }
        set {
            self.record.setValue(newValue, forKey: CloudCurrentAppVersion.keyElement)
        }
    }
    
    // MARK: - Private variables
    
    private static let keyElement = "version"
    
    // MARK: - Init
    
    init(record: CKRecord) {
        self.record = record
    }
    
    init() {
        record = CKRecord(recordType: CloudCurrentAppVersion.recordType)
    }
}

