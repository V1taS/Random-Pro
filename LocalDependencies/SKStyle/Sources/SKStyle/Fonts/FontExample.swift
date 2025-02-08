//
//  FontExample.swift
//
//
//  Created by Vitalii Sosin on 25.11.2023.
//

import SwiftUI

struct FontExample: View {
  var body: some View {
    VStack {
      ScrollView(showsIndicators: false) {
        ForEach(Constants.fonts, id: \.self) { item in
          Text("Шрифт: \(item.name)")
            .font(item.font)
            .padding(.bottom)
        }
      }
    }
    .padding(.top)
  }
}

// MARK: - Preview

struct FontExample_Previews: PreviewProvider {
  static var previews: some View {
    FontExample()
  }
}

// MARK: - Constants

private enum Constants {
  static let fonts: [FontItem] = [
    FontItem(font: .fancy.text.largeTitle, name: "largeTitle"),
    FontItem(font: .fancy.text.title, name: "title"),
    FontItem(font: .fancy.text.regularMedium, name: "regularMedium"),
    FontItem(font: .fancy.text.regular, name: "regular"),
    FontItem(font: .fancy.text.small, name: "small")
  ]
}

// MARK: - FontItem

struct FontItem: Hashable {
  let font: Font
  let name: String
}
