//
//  RewardsView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 12/5/23.
//

import CoreData
import Foundation
import SwiftUI

struct RewardsView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @FetchRequest(sortDescriptors: [],
                predicate: NSPredicate(
                  format: "questBonusReward != nil")) var questsWithBonusRewards: FetchedResults<Quest>
  @FetchRequest(sortDescriptors: [SortDescriptor(\.dateEarned)],
                predicate: NSPredicate(
                  format: "isEarned == true")) var availableRewards: FetchedResults<Reward>
  @FetchRequest(sortDescriptors: [SortDescriptor(\.sortId)],
                predicate: NSPredicate(
                  format: "isMilestoneReward == false && isEarned == false"))
  var minorRewards: FetchedResults<Reward>

  @FetchRequest(sortDescriptors: [SortDescriptor(\.sortId)],
                predicate: NSPredicate(
                  format: "isMilestoneReward == true && isEarned == false"))
  var milestoneRewards: FetchedResults<Reward>
  @FetchRequest(sortDescriptors: []) var userFetchResults: FetchedResults<User>
  var user: User {
    return userFetchResults.first!
  }
  var nextMilestoneLevel: Int64 {
    var milestoneCandidate: Int64 = 0
    for number in 1..<6 where (user.level + Int64(number)) % 5 == 0 {
      milestoneCandidate = (user.level + Int64(number))
    }
    return milestoneCandidate
  }

  var body: some View {
    NavigationStack {
      List {
        Section(header: Text("Unclaimed Rewards")) {
          if availableRewards.isEmpty {
            Text("You have no unclaimed rewards. Keep leveling to earn more!")
          } else {
            ForEach(availableRewards, id: \.self) { reward in
              HStack {
                Text(reward.name!)
                Spacer()
                Button("Claim Reward!") {
                  managedObjectContext.delete(reward)
                }
              }
            }
          }
        }
        Section(header: Text("Next Level")) {
          if (user.level + 1) % 5 == 0 {
            Text("You earn a Milestone reward next level!")
          } else {
            if minorRewards.first != nil {
              Text("Reach the next level to earn \(minorRewards.first!.name ?? "")!")
            } else {
              Text("You have no Minor rewards set up! Add them using the Manage Rewards button below.")
            }
          }
        }

        Section(header: Text("Next Milestone: Level \(nextMilestoneLevel)")) {
          if milestoneRewards.first != nil {
            Text("Keep up the good work! Reach level \(nextMilestoneLevel) and earn yourself \(milestoneRewards.first!.name ?? "").")
          } else {
            Text("You have no Milestone rewards set up! Add them using the Manage Rewards button below.")
          }
        }
        NavigationLink(destination: ManageRewardsView()) {
          Button("Manage Rewards") {
          }
        }
      }
    }
  }
}

#Preview {
  RewardsView().environment(\.managedObjectContext, CoreDataController.preview.persistentContainer.viewContext)
}
