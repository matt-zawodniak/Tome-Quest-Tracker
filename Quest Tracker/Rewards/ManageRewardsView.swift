//
//  ManageRewardsView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 12/11/23.
//

import SwiftUI

struct ManageRewardsView: View {
  @Environment(\.modelContext) var modelContext
  @Environment(\.editMode) var editMode

  var minorRewards: [Reward]
  var milestoneRewards: [Reward]

  @State var presentingAddRewardView: Bool = false

  var body: some View {
    NavigationStack {
      List {
        HStack {
          Spacer()

          Text("Add Reward")

          Spacer()
        }
        .overlay(
          NavigationLink("", destination: AddRewardView(
            reward: Reward(isMilestoneReward: false, name: "", sortId: -1),
            minorRewardCount: minorRewards.count,
            milestoneRewardCount: milestoneRewards.count))
          .opacity(0)
        )
        .listRowBackground(StylizedOutline()
          .stroke(.cyan.opacity(0.4))
          .background(StylizedOutline().fill().opacity(0.2))
        )
        .listRowSeparator(.hidden)

        Section(header: Text("Minor Rewards")) {
          ForEach(minorRewards, id: \.self) { reward in
            Text(reward.name)
              .overlay(
                NavigationLink("", destination: AddRewardView(reward: reward,
                                                          minorRewardCount: minorRewards.count,
                                                          milestoneRewardCount: milestoneRewards.count))
                .opacity(0)
              )
              .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                  modelContext.delete(reward)
                } label: {
                  Label("Delete", systemImage: "trash")
                }
              }
          }
          .onMove(perform: moveMinorRewards)
        }
        .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
        .listRowSeparator(.hidden)

        Section(header: Text("Milestone Rewards")) {
          ForEach(milestoneRewards, id: \.self) { reward in
            Text(reward.name)
              .overlay(
                NavigationLink("", destination: AddRewardView(reward: reward,
                                                          minorRewardCount: minorRewards.count,
                                                          milestoneRewardCount: milestoneRewards.count))
                .opacity(0)
              )
              .swipeActions(edge: .trailing) {
                Button(role: .destructive) {
                  modelContext.delete(reward)
                } label: {
                  Label("Delete", systemImage: "trash")
                }
              }
          }
          .onMove(perform: moveMilestoneRewards)
        }
        .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
        .listRowSeparator(.hidden)
      }
    }
    .toolbar {
      Button("Rearrange") {
        switch self.editMode?.wrappedValue {
        case .active: self.editMode?.wrappedValue = .inactive
        case .inactive: self.editMode?.wrappedValue = .active
        default: print("Rearrange in transient state.")
        }
      }
    }
    .padding(.horizontal)
    .foregroundStyle(.cyan)
    .scrollContentBackground(.hidden)
    .listStyle(.grouped)
    .listRowSpacing(5)
  }

  private func moveMinorRewards(from source: IndexSet, to destination: Int) {
    var updatedMinorRewards: [Reward] = minorRewards.map({ $0 })

    updatedMinorRewards.move(fromOffsets: source, toOffset: destination)

    for reverseIndex in stride( from: updatedMinorRewards.count - 1,
                                through: 0,
                                by: -1) {
      updatedMinorRewards[reverseIndex].sortId = reverseIndex
    }
  }

  private func moveMilestoneRewards(from source: IndexSet, to destination: Int) {
    var updatedMilestoneRewards: [Reward] = milestoneRewards.map({ $0 })

    updatedMilestoneRewards.move(fromOffsets: source, toOffset: destination)

    for reverseIndex in stride( from: updatedMilestoneRewards.count - 1,
                                through: 0,
                                by: -1) {
      updatedMilestoneRewards[reverseIndex].sortId = reverseIndex
    }
  }
}

#Preview {
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
