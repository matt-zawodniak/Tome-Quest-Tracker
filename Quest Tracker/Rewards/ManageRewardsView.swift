//
//  ManageRewardsView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 12/11/23.
//

import SwiftUI

struct ManageRewardsView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @FetchRequest(sortDescriptors: [SortDescriptor(\.sortId)],
                predicate: NSPredicate(
                  format: "isMilestoneReward == false && isEarned == false"))
  var minorRewards: FetchedResults<Reward>

  @FetchRequest(sortDescriptors: [SortDescriptor(\.sortId)],
                predicate: NSPredicate(
                  format: "isMilestoneReward == true && isEarned == false"))
  var milestoneRewards: FetchedResults<Reward>

    var body: some View {
      NavigationStack {
        VStack {
          Button("Add Reward") {

          }.buttonStyle(.borderedProminent)
          List {
            Section(header: Text("Minor Rewards")) {
              ForEach(minorRewards, id: \.self) { reward in
                Text(reward.name ?? "")
              }
              .onMove(perform: moveMinorRewards)
            }
            Section(header: Text("Milestone Rewards")) {
              ForEach(milestoneRewards, id: \.self) { reward in
                Text(reward.name ?? "")
              }
              .onMove(perform: moveMilestoneRewards)
            }
          }
          .toolbar {
            EditButton()
          }
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
    ManageRewardsView().environment(\.managedObjectContext, CoreDataController.preview.container.viewContext)
}
