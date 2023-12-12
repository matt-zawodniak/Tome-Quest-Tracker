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
  @FetchRequest(sortDescriptors: [SortDescriptor(\.sortId)],
                predicate: NSPredicate(
                  format: "isEarned == true")) var availableRewards: FetchedResults<Reward>
  @FetchRequest(sortDescriptors: [SortDescriptor(\.sortId)],
                predicate: NSPredicate(format: "isEarned == false")) var earnableRewards: FetchedResults<Reward>
  @FetchRequest(sortDescriptors: []) var userFetchResults: FetchedResults<User>
  var user: User {
    return userFetchResults.first!
  }
  var nextMilestoneLevel: Int64 {
    var milestoneCandidate: Int64 = 0
    for number in 0..<5 where (user.level + Int64(number)) % 5 == 0 {
      milestoneCandidate = (user.level + Int64(number))
    }
    return milestoneCandidate
  }
  var nextMilestoneReward: String {
    let milestoneReward = earnableRewards.first(where: {$0.sortId == nextMilestoneLevel})!
    return milestoneReward.name ?? ""
  }
  var body: some View {
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
                
              }
            }
          }
        }
      }
      Section(header: Text("Next Level")) {
        Text("Reach the next level to earn \(earnableRewards.first!.name ?? "")!")
      }

      Section(header: Text("Next Milestone: Level \(nextMilestoneLevel)")) {
        Text("Keep up the good work! Reach level \(nextMilestoneLevel) and earn yourself \(nextMilestoneReward).")
      }
    }
    Button("Manage Rewards") {
    }
    LevelAndExpUI()
      .padding(.horizontal)
  }
}

#Preview {
  RewardsView().environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
}
