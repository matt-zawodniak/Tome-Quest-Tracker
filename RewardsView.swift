//
//  RewardsView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 12/5/23.
//

import CoreData
import SwiftUI

struct RewardsView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @FetchRequest(sortDescriptors: [],
                predicate: NSPredicate(
                  format: "questBonusReward != nil")) var questsWithBonusRewards: FetchedResults<Quest>
  @FetchRequest(sortDescriptors: [SortDescriptor(\.sortId)]) var rewards: FetchedResults<Reward>

  var body: some View {
    List {
      Section(header: Text("Unclaimed Rewards")) {
        if rewards.isEmpty {
          Text("You have no unclaimed rewards. Keep leveling to earn more!")
        } else {
          ForEach(rewards, id: \.self) { reward in
            if reward.isEarned == true && reward.isClaimed == false {
              HStack {
                Text(reward.name!)
                Spacer()
                Button("Claim Reward!") {
                  reward.isClaimed = true
                }
              }
            }
          }
        }
      }
      Section(header: Text("Next Level")) {
        Text("Reach the next level to earn \(rewards.first?.name ?? "")!")
      }
      Section(header: Text("Next Milestone: Level 5")) {
        Text("Keep up the good work! Reach level 5 and earn yourself a Day at the Beach!")
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
