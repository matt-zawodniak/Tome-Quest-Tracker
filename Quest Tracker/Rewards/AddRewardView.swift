//
//  AddRewardView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 12/16/23.
//

import CoreData
import SwiftUI

struct AddRewardView: View {
  @Environment(\.managedObjectContext) var managedObjectContext

  @StateObject var reward: Reward

  @State var minorRewardCount: Int
  @State var milestoneRewardCount: Int

    var body: some View {
      NavigationStack {
        Form {
          Section(header: Text("Reward Name")) {
            TextField("Reward Name", text: $reward.name.bound)
          }
          Section(header: Text("Reward Type")) {
            Picker("Reward Type", selection: $reward.isMilestoneReward) {
              Text("Minor").tag(false)
              Text("Milestone").tag(true)
            }
            .pickerStyle(.segmented)
          }
        }
      }
      .onDisappear(perform: {
        if reward.isMilestoneReward {
            reward.sortId = Int64(milestoneRewardCount)
          } else {
            reward.sortId = Int64(minorRewardCount)
          }
          CoreDataController.shared.save(context: managedObjectContext)
        }
      )
    }
}

#Preview {
  AddRewardView(reward: Reward(context: CoreDataController.preview.container.viewContext), minorRewardCount: 5,
                milestoneRewardCount: 3)
  .environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
}
