//
//  YesNoWidget.swift
//  YesNoWidget
//
//  Created by Vitalii Sosin on 06.05.2023.
//

import WidgetKit
import SwiftUI
import RandomUIKit

struct Provider: TimelineProvider {
  
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), result: "-")
  }
  
  func getSnapshot(in context: Context,
                   completion: @escaping (SimpleEntry) -> Void) {
    let entry = SimpleEntry(date: Date(), result: "")
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    let currentDate = Date()
    
    let viewModel = YesNoViewModel()
    viewModel.generateResult()
    
    let entry = SimpleEntry(date: currentDate, result: viewModel.result)
    
    let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
    let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let result: String
}

struct YesNoWidgetEntryView: View {
  @Environment(\.widgetFamily) var widgetFamily
  var entry: Provider.Entry
  
  var body: some View {
    switch widgetFamily {
    case .systemSmall:
      smallWidgetView
    default:
      smallWidgetView
    }
  }
  
  var smallWidgetView: some View {
    VStack {
      Text(YesNoWidgetStrings.updatedEvery15Min)
        .modifier(ResultLabelModifier(fontSize: 8))
        .padding(.top)
      Spacer()
      Text(entry.result)
        .modifier(ResultLabelModifier(fontSize: 60))
      Spacer()
      VStack {
        Text(YesNoWidgetStrings.lastUpdate)
          .modifier(ResultLabelModifier(fontSize: 10))
        Text(lastUpdateText(for: entry.date))
          .modifier(ResultLabelModifier(fontSize: 10))
      }
      .padding(.bottom)
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    .gradientBackgroundStyle()
  }
  
  func lastUpdateText(for date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    let timeString = dateFormatter.string(from: date)
    return String(format: timeString)
  }
}

struct YesNoWidget: Widget {
  let kind: String = "YesNoWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      YesNoWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
    .supportedFamilies([.systemSmall])
  }
}

struct YesNoWidget_Previews: PreviewProvider {
  static var previews: some View {
    YesNoWidgetEntryView(entry: SimpleEntry(date: Date(), result: "?"))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
