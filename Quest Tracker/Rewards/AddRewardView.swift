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
    NavigationStack {
      List {
        Section(header: Text("Reward Name")) {
          TextField("Reward Name", text: $reward.name)
            .foregroundStyle(.cyan)
        }
        .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))

        Section(header: Text("Reward Type")) {
          Picker("Reward Type", selection: $reward.isMilestoneReward) {
            Text("Minor").tag(false)
            Text("Milestone").tag(true)

          }
          .pickerStyle(.segmented)
          .colorMultiply(.cyan)

        }
        .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))

      }
    }
    .foregroundStyle(.cyan)
    .padding(.horizontal)
    .scrollContentBackground(.hidden)
    .listStyle(.grouped)
    .background(GlobalUISettings.background)
    .onDisappear(perform: {
      if reward.name.count > 0 {
        if reward.isMilestoneReward {
          reward.sortId = Int64(milestoneRewardCount)
        } else {
          reward.sortId = Int64(minorRewardCount)
        }
        modelContext.insert(reward)
      } else {
        //          modelContext.delete(reward)
      }
    }
    )
  }
}
