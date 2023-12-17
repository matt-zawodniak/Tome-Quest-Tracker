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

  @State var rewardName: String = ""
  @State var rewardIsMileStone: Bool = false
  @State var minorRewardCount: Int
  @State var milestoneRewardCount: Int

    var body: some View {
      NavigationStack {
        Form {
          Section(header: Text("Reward Name")) {
            TextField("Reward Name", text: $rewardName)
          }
          Section(header: Text("Reward Type")) {
            Picker("Reward Type", selection: $rewardIsMileStone) {
              Text("Minor").tag(false)
              Text("Milestone").tag(true)
            }
            .pickerStyle(.segmented)
          }
        }
      }
      .onDisappear(perform: {
        if rewardName != "" {
          let newReward = Reward(context: managedObjectContext)
          newReward.name = rewardName
          newReward.isMilestoneReward = rewardIsMileStone
          newReward.isEarned = false
          if rewardIsMileStone {
            newReward.sortId = Int64(milestoneRewardCount)
          } else {
            newReward.sortId = Int64(minorRewardCount)
          }
          CoreDataController.shared.save(context: managedObjectContext)
        }
      })
    }
}

#Preview {
  AddRewardView(minorRewardCount: 5,
                milestoneRewardCount: 3)
  .environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
}
