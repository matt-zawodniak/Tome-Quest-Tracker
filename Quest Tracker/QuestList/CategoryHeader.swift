//
//  CategoryHeader.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/1/24.
//

import SwiftUI

struct CategoryHeader: View {
  var title: String

  @ObservedObject var model: SectionsModel

  var countOfEntitiesInCategory: Int?

  var shouldBeExpanded: Bool

  var body: some View {
    HStack {
      Text(title)

      if !model.isExpanded(title: title) {
        if let countOfEntitiesInCategory {
          Text("(\(countOfEntitiesInCategory))")
        }
      }

      Spacer()

      Image(systemName: model.isExpanded(title: title) ? "chevron.down" : "chevron.up")
    }
    .contentShape(Rectangle())
    .onTapGesture {
      model.toggle(title: self.title)
    }
    .foregroundStyle(.cyan)
  }
}
