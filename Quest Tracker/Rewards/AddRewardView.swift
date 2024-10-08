//
//  AddRewardView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 12/16/23.
//

import CoreData
import SwiftUI

struct AddRewardView: View {

  @Environment(\.modelContext) var modelContext

  @State var reward: Reward
  @State var minorRewardCount: Int
  @State var milestoneRewardCount: Int

  var body: some View {
    List {
      Section(header: Text("Reward Name")) {
        TextField("Reward Name", text: $reward.name)
          .foregroundStyle(.cyan)
      }
      .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
      .listRowSeparator(.hidden)

      Section(header: Text("Reward Type")) {
        Picker("Reward Type", selection: $reward.isMilestoneReward) {
          Text("Minor").tag(false)
          Text("Milestone").tag(true)
        }
        .pickerStyle(.segmented)
        .colorMultiply(.cyan)
      }
      .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
      .listRowSeparator(.hidden)
    }
    .foregroundStyle(.cyan)
    .padding(.horizontal)
    .scrollContentBackground(.hidden)
    .listStyle(.grouped)
    .onDisappear(perform: {
      if reward.name.count > 0 {
        if reward.isMilestoneReward {
          reward.sortId = milestoneRewardCount
        } else {
          reward.sortId = minorRewardCount
        }

        modelContext.insert(reward)
      }
    })
  }
}

#Preview {
    AddRewardView(reward: Reward(isMilestoneReward: false, name: "Test Reward", sortId: 0),
                  minorRewardCount: 0,
                  milestoneRewardCount: 0)
    .modelContainer(PreviewSampleData.container)
}
