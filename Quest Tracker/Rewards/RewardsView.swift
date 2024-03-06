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

  var user: User

  var nextMilestoneLevel: Int64 {
    var milestoneCandidate: Int64 = 0
    for number in 1..<6 where (user.level + Int64(number)) % 5 == 0 {
      milestoneCandidate = (user.level + Int64(number))
    }
    return milestoneCandidate
  }

  var availableRewards: [Reward] { rewards.filter({ $0.isEarned == true }).sorted { $0.dateEarned! < $1.dateEarned! }
  }

  var minorRewards: [Reward] {
    rewards.filter({ $0.isMilestoneReward == false && $0.isEarned == false})
      .sorted { $0.sortId < $1.sortId }
  }

  var milestoneRewards: [Reward] {
    rewards.filter({ $0.isMilestoneReward == true && $0.isEarned == false})
      .sorted { $0.sortId < $1.sortId }
  }

  var body: some View {

      List {
        Section(header: Text("")) {

              HStack {
                Spacer()
                Text("Manage Rewards")
                Spacer()
              }
              .overlay(
                NavigationLink("", destination: ManageRewardsView(
                  minorRewards: minorRewards,
                  milestoneRewards: milestoneRewards))
                  .opacity(0)
              )
        }
        .listRowBackground(StylizedOutline()
          .stroke(.cyan.opacity(0.4))
          .background(StylizedOutline().fill().opacity(0.2)))
        .listRowSeparator(.hidden)

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
        .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
        .listRowSeparator(.hidden)

        Section(header: Text("Next Milestone: Level \(nextMilestoneLevel)")) {
          if let nextMilestoneReward = milestoneRewards.first {
            Text("Keep up the good work! Reach level \(nextMilestoneLevel) and earn yourself \(nextMilestoneReward.name).")
          } else {
            Text("You have no Milestone rewards set up! Add them using the Manage Rewards button below.")
          }
        }
        .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
        .listRowSeparator(.hidden)

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
        .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
        .listRowSeparator(.hidden)

      }
      .padding(.horizontal)
      .foregroundStyle(.cyan)
      .scrollContentBackground(.hidden)
      .listRowSpacing(5)
      .listStyle(.inset)
    .introspect(.navigationStack, on: .iOS(.v16, .v17), scope: .ancestor) {
                    $0.viewControllers.forEach { controller in
                        controller.view.backgroundColor = .clear
                    }
                }
  }
}
//
// #Preview {
//  RewardsView().environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
// }
