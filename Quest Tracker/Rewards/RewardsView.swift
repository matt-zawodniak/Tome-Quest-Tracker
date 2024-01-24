//
//  RewardsView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 12/5/23.
//

import SwiftData
import Foundation
import SwiftUI

struct RewardsView: View {
  @Environment(\.modelContext) var modelContext

  @Query() var rewards: [Reward]

  @Query() var users: [User]

  var user: User {
    return users.first!
  }

  var nextMilestoneLevel: Int64 {
    var milestoneCandidate: Int64 = 0
    for number in 1..<6 where (user.level + Int64(number)) % 5 == 0 {
      milestoneCandidate = (user.level + Int64(number))
    }
    return milestoneCandidate
  }

  var body: some View {

    @State var availableRewards = rewards.filter({ $0.isEarned == true }).sorted { $0.dateEarned! < $1.dateEarned! }

    @State var minorRewards = rewards.filter({ $0.isMilestoneReward == false && $0.isEarned == false}).sorted { $0.sortId < $1.sortId }

    @State var milestoneRewards = rewards.filter({ $0.isMilestoneReward == true && $0.isEarned == false}).sorted { $0.sortId < $1.sortId }

    // These might not update with the state being in the body. might have to move it up and make them each computed vars.

    NavigationStack {
      List {
        Section(header: Text("Unclaimed Rewards")) {
          if availableRewards.isEmpty {
            Text("You have no unclaimed rewards. Keep leveling to earn more!")
          } else {
            ForEach(availableRewards, id: \.self) { reward in
              HStack {
                Text(reward.name)
                Spacer()
                Button("Claim Reward!") {
                  modelContext.delete(reward)
                }
              }
            }
          }
        }
        Section(header: Text("Next Level")) {
          if (user.level + 1) % 5 == 0 {
            Text("You earn a Milestone reward next level!")
          } else {
            if let nextMinorReward = minorRewards.first {
              Text("Reach the next level to earn \(nextMinorReward.name )!")
            } else {
              Text("You have no Minor rewards set up! Add them using the Manage Rewards button below.")
            }
          }
        }

        Section(header: Text("Next Milestone: Level \(nextMilestoneLevel)")) {
          if let nextMilestoneReward = milestoneRewards.first {
            Text("Keep up the good work! Reach level \(nextMilestoneLevel) and earn yourself \(nextMilestoneReward.name).")
          } else {
            Text("You have no Milestone rewards set up! Add them using the Manage Rewards button below.")
          }
        }
        NavigationLink(destination: ManageRewardsView(minorRewards: minorRewards, milestoneRewards: milestoneRewards)) {
          Button("Manage Rewards") {
          }
        }
      }
    }
  }
}
//
//#Preview {
//  RewardsView().environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
//}
