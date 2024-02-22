//
//  ManageRewardsView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 12/11/23.
//

import SwiftUI

struct ManageRewardsView: View {
  @Environment(\.modelContext) var modelContext

  var minorRewards: [Reward]
  var milestoneRewards: [Reward]

  var body: some View {
    NavigationStack {
      VStack {

        NavigationLink(destination: AddRewardView(reward: Reward(isMilestoneReward: false, name: "", sortId: -1),
                                                  minorRewardCount: minorRewards.count,
                                                  milestoneRewardCount: milestoneRewards.count)) {
          Button("Add Reward") {
          }
          .buttonStyle(.borderedProminent)
             .foregroundStyle(.black)
        }

        List {
          Section(header: Text("Minor Rewards")) {
            ForEach(minorRewards, id: \.self) { reward in
              Text(reward.name)
                .swipeActions(edge: .trailing) {

                  Button(role: .destructive) {
                    modelContext.delete(reward)
                  } label: {
                    Label("Delete", systemImage: "trash")
                  }

                  NavigationLink(destination: AddRewardView(reward: reward,
                                                            minorRewardCount: minorRewards.count,
                                                            milestoneRewardCount: milestoneRewards.count)) {
                    Button(action: {
                    }, label: {
                      Text("Edit")
                    }
                    )
                  }
                }            }
            .onMove(perform: moveMinorRewards)
          }
          .listRowBackground(Color.cyan.opacity(0.2))

          Section(header: Text("Milestone Rewards")) {
            ForEach(milestoneRewards, id: \.self) { reward in
              Text(reward.name)
                .swipeActions(edge: .trailing) {

                  Button(role: .destructive) {
                    modelContext.delete(reward)
                  } label: {
                    Label("Delete", systemImage: "trash")
                  }

                  NavigationLink(destination: AddRewardView(reward: reward,
                                                            minorRewardCount: minorRewards.count,
                                                            milestoneRewardCount: milestoneRewards.count)) {
                    Button(action: {
                    }, label: {
                      Text("Edit")
                    }
                    )
                  }
                }
            }
            .onMove(perform: moveMilestoneRewards)
          }
          .listRowBackground(Color.cyan.opacity(0.2))

        }
        .toolbar {
          EditButton()
        }
      }
      .tint(.cyan)
      .foregroundStyle(.cyan)
      .scrollContentBackground(.hidden)
      .listStyle(.grouped)
      .background(AngularGradient(colors: [.cyan, .black],
                                              center: UnitPoint(x: -0.1, y: -0.1),
                                              startAngle: Angle(degrees: -30),
                                              endAngle: Angle(degrees: 60)))

    }
  }
  private func moveMinorRewards(from source: IndexSet, to destination: Int) {
    var updatedMinorRewards: [Reward] = minorRewards.map({ $0 })
    updatedMinorRewards.move(fromOffsets: source, toOffset: destination)
    for reverseIndex in stride( from: updatedMinorRewards.count - 1,
                                through: 0,
                                by: -1) {
      updatedMinorRewards[reverseIndex].sortId = Int64(reverseIndex)
    }
  }
  private func moveMilestoneRewards(from source: IndexSet, to destination: Int) {
    var updatedMilestoneRewards: [Reward] = milestoneRewards.map({ $0 })
    updatedMilestoneRewards.move(fromOffsets: source, toOffset: destination)
    for reverseIndex in stride( from: updatedMilestoneRewards.count - 1,
                                through: 0,
                                by: -1) {
      updatedMilestoneRewards[reverseIndex].sortId = Int64(reverseIndex)
    }
  }
}
//
// #Preview {
//  ManageRewardsView().environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
// }
