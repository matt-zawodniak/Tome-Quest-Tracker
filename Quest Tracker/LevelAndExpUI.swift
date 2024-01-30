//
//  LevelAndExpUI.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 11/30/23.
//

import SwiftUI
import SwiftData

struct LevelAndExpUI: View {
  @Environment(\.modelContext) var modelContext

  @Query() var users: [User]

  var user: User {
    return users.first ?? User.fetchFirstOrInitialize(context: modelContext)
  }

  var body: some View {
    HStack {
      Text("LVL \(user.level)")
      ProgressView(value: user.currentExp, total: user.expToLevel).animation(.linear, value: user.currentExp)
      Text("\(String(format: "%.0f", user.currentExp.rounded()))/ \(String(format: "%.0f", user.expToLevel.rounded()))")
    }
  }
}
//
// #Preview {
//    LevelAndExpUI().environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
// }
