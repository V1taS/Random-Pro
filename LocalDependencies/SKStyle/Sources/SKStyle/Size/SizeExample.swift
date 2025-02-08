//
//  SizeExample.swift
//
//
//  Created by Vitalii Sosin on 25.11.2023.
//

import SwiftUI

struct SizeExample: View {
  var body: some View {
    VStack {
      ScrollView(showsIndicators: false) {
        ForEach(Constants.sizes, id: \.self) { item in
          Text("Размер: \(item.size), Имя: \(item.name)")
            .font(.fancy.text.regular)
            .padding(.bottom)
        }
      }
    }
    .padding(.top)
  }
}

// MARK: - Preview

struct SizeExample_Previews: PreviewProvider {
  static var previews: some View {
    SizeExample()
  }
}

// MARK: - Constants

private enum Constants {
  static let sizes: [SizeItem] = [
    SizeItem(size: .s1, name: "s1"),
    SizeItem(size: .s2, name: "s2"),
    SizeItem(size: .s3, name: "s3"),
    SizeItem(size: .s4, name: "s4"),
    SizeItem(size: .s5, name: "s5"),
    SizeItem(size: .s6, name: "s6"),
    SizeItem(size: .s7, name: "s7"),
    SizeItem(size: .s8, name: "s8"),
    SizeItem(size: .s9, name: "s9"),
    SizeItem(size: .s10, name: "s10"),
    SizeItem(size: .s11, name: "s11"),
    SizeItem(size: .s12, name: "s12"),
    SizeItem(size: .s13, name: "s13"),
    SizeItem(size: .s14, name: "s14"),
    SizeItem(size: .s15, name: "s15"),
    SizeItem(size: .s16, name: "s16"),
    SizeItem(size: .s17, name: "s17"),
    SizeItem(size: .s18, name: "s18"),
    SizeItem(size: .s19, name: "s19"),
    SizeItem(size: .s20, name: "s20"),
    SizeItem(size: .s26, name: "s26")
  ]
}

// MARK: - SizeItem

struct SizeItem: Hashable {
  let size: Int
  let name: String
}
