//
//  CollapsibleSection.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/1/24.
//

import SwiftUI

class SectionModel: NSObject, ObservableObject {
  @Published var sections: [String: Bool] = [String: Bool]()

  var shouldBeExpanded: Bool = true

  func isExpanded(title: String) -> Bool {
    if let value = sections[title] {
      return value
    } else {
      return shouldBeExpanded
    }
  }

  func toggle(title: String) {
    let current = sections[title] ?? true

    withAnimation {
      sections[title] = !current
    }
  }
}

struct CategoryHeader: View {
  var title: String

  @ObservedObject var model: SectionModel

  var number: Int?

  var shouldBeExpanded: Bool

  init(title: String, model: SectionModel, number: Int? = nil, shouldBeExpanded: Bool) {
    self.title = title
    self.model = model
    self.number = number
    self.shouldBeExpanded = shouldBeExpanded

    model.shouldBeExpanded = shouldBeExpanded
  }

  var body: some View {
    HStack {
      Text(title)

      if model.isExpanded(title: title) == false {
        if let number {
          Text("(\(number))")
        }
      }

      Spacer()

      Image(systemName: model.isExpanded(title: title) ? "chevron.down" : "chevron.up")
    }
    .contentShape(Rectangle())
    .onTapGesture {
      self.model.toggle(title: self.title)
    }
    .foregroundStyle(.cyan)
  }
}
