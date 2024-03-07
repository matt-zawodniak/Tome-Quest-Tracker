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
  @State var presentingAddRewardView: Bool = false

  var body: some View {
    NavigationStack {
      VStack {
        Button("Add Reward") {
          presentingAddRewardView = true
        }.buttonStyle(.borderedProminent)
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
        }
        .toolbar {
          EditButton()
        }
      }
      .popover(isPresented: $presentingAddRewardView) {
        AddRewardView(reward: Reward(isMilestoneReward: false, name: "", sortId: -1),
                      minorRewardCount: minorRewards.count,
                      milestoneRewardCount: milestoneRewards.count)
      }
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

#Preview {
  MainActor.assumeIsolated {
    ManageRewardsView(minorRewards: [Reward(
                        isMilestoneReward: false,
                        name: "Minor",
                        sortId: 1)],
                      milestoneRewards: [Reward(
                        isMilestoneReward: true,
                        name: "Milestone", sortId:
                          1)])
      .modelContainer(PreviewSampleData.container)
  }
}
