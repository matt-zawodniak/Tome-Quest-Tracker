//
//  SectionsModel.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 5/17/24.
//

import SwiftUI

class SectionsModel: NSObject, ObservableObject {
  @Published var sectionsSelectedStatus: [String: Bool] = [String: Bool]()

  var shouldBeExpanded: Bool = true

  func isExpanded(title: String) -> Bool {
    if let value = sectionsSelectedStatus[title] {
      return value
    } else {
      return shouldBeExpanded
    }
  }

  func toggle(title: String) {
    let currentStatus = sectionsSelectedStatus[title] ?? true

    withAnimation {
      sectionsSelectedStatus[title] = !currentStatus
    }
  }
}
