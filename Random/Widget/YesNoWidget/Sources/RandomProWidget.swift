//
//  RandomProWidget.swift
//  YesNoWidget
//
//  Created by Vitalii Sosin on 06.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct RandomProWidget: Widget {
  private let kind: String = "RandomProWidget"
  
  public var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      RandomProWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Random Pro Widget")
    .description("This is a simple example of a Random Pro widget.")
  }
}
