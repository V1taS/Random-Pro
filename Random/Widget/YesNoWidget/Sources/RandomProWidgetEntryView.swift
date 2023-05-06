//
//  RandomProWidgetEntryView.swift
//  YesNoWidget
//
//  Created by Vitalii Sosin on 06.05.2023.
//  Copyright © 2023 SosinVitalii.com. All rights reserved.
//

import SwiftUI
import WidgetKit

struct RandomProWidgetEntryView: View {
  var entry: Provider.Entry
  
  var body: some View {
    Text(entry.text)
  }
}

struct RandomProWidgetEntryView_Previews: PreviewProvider {
  static var previews: some View {
    RandomProWidgetEntryView(entry: SimpleEntry(date: Date(), text: "Preview"))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
