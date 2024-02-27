//
//  CollapsibleSection.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/1/24.
//

import SwiftUI

class SectionModel: NSObject, ObservableObject {

  @Published var sections: [String: Bool] = [String: Bool]()

  func isOpen(title: String) -> Bool {
    if let value = sections[title] {
      return value
    } else {
      return true
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

  var body: some View {
    HStack {
      Text(title)
      if model.isOpen(title: title) == false {
        if let number {
          Text("(\(number))")
        }
      }
      Spacer()
      Image(systemName: model.isOpen(title: title) ? "chevron.down" : "chevron.up")
    }
    .contentShape(Rectangle())
    .onTapGesture {
      self.model.toggle(title: self.title)
    }
    .foregroundStyle(.cyan)
  }
}
