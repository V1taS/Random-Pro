//
//  ListWordsWidget.swift
//  ListWordsWidget
//
//  Created by Vitalii Sosin on 08.03.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import WidgetKit
import SwiftUI

let storage = StorageServiceImpl()
private var randomWord: [String] {
  let list = storage.listScreenModel?.allItems.compactMap {
    return $0.text
  }
  return list ?? []
}

struct Provider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), word: randomWord[0])
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
    let entry = SimpleEntry(date: Date(), word: randomWord[0])
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    var entries: [SimpleEntry] = []
    
    let currentDate = Date()
    for minuteOffset in 0..<60*24 {
      if let entryDate = Calendar.current.date(byAdding: .minute,
                                               value: minuteOffset,
                                               to: currentDate),
         let randomWord = randomWord.randomElement() {
        let entry = SimpleEntry(date: entryDate, word: randomWord)
        entries.append(entry)
      }
    }
    
    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let word: String
}

struct ListWordsWidgetEntryView: View {
  var entry: Provider.Entry
  
  var body: some View {
    Text(entry.word)
      .padding(.horizontal, 16)
      .font(Font.title)
  }
}

struct ListWordsWidget: Widget {
  let kind: String = "ListWordsWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      ListWordsWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Random words")
    .description("Generates a random word every 5 minutes")
  }
}

struct ListWordsWidget_Previews: PreviewProvider {
  static var previews: some View {
    ListWordsWidgetEntryView(entry: SimpleEntry(date: Date(), word: randomWord[0]))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
