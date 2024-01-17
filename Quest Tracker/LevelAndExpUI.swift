//
//  LevelAndExpUI.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 11/30/23.
//

import SwiftUI

struct LevelAndExpUI: View {

  @FetchRequest(sortDescriptors: []) var userFetchResults: FetchedResults<User>
  var user: User {
    return userFetchResults.first!
  }

  var body: some View {
    HStack {
      Text("LVL \(user.level)")
      ProgressView(value: user.currentExp, total: user.expToLevel)
      Text("\(String(format: "%.0f", user.currentExp.rounded()))/ \(String(format: "%.0f", user.expToLevel.rounded()))")
    }
  }
}

#Preview {
    LevelAndExpUI().environment(\.managedObjectContext, CoreDataController.preview.persistentContainer.viewContext)
}
