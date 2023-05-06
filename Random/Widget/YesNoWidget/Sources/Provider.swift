//
//  Provider.swift
//  YesNoWidget
//
//  Created by Vitalii Sosin on 06.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import WidgetKit

struct Provider: TimelineProvider {
  typealias Entry = SimpleEntry
  
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), text: "Placeholder")
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
    let entry = SimpleEntry(date: Date(), text: "Snapshot")
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
    let currentDate = Date()
    let entry = SimpleEntry(date: currentDate, text: "Timeline Entry")
    let timeline = Timeline(entries: [entry], policy: .atEnd)
    completion(timeline)
  }
}
