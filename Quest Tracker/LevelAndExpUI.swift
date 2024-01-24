//
//  LevelAndExpUI.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 11/30/23.
//

import SwiftUI
import SwiftData

struct LevelAndExpUI: View {

  @Query() var users: [User]

  var user: User {
    return users.first!
  }

  var body: some View {
    HStack {
      Text("LVL \(user.level)")
      ProgressView(value: user.currentExp, total: user.expToLevel)
      Text("\(String(format: "%.0f", user.currentExp.rounded()))/ \(String(format: "%.0f", user.expToLevel.rounded()))")
    }
  }
}
//
// #Preview {
//    LevelAndExpUI().environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
// }
