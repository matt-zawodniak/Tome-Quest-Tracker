//
//  SettingsView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 10/25/23.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @Query() var quests: [Quest]
  @Query() var rewards: [Reward]

  var minorRewards: [Reward] {
    rewards.filter({ $0.isMilestoneReward == false && $0.isEarned == false})
      .sorted { $0.sortId < $1.sortId }
  }

  var milestoneRewards: [Reward] {
    rewards.filter({ $0.isMilestoneReward == true && $0.isEarned == false})
      .sorted { $0.sortId < $1.sortId }
  }

  @State var settings: Settings
  @State var user: User

  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Text("Daily Reset Time:")
            DatePicker("", selection: $settings.time, displayedComponents: .hourAndMinute)
          }
          HStack {
            Text("Daily Reset Warning")
            Spacer()
            Toggle("", isOn: $settings.dailyResetWarning)
          }
        }
        VStack {
          HStack {
            Text("Weekly Reset Day:")
            Picker("", selection: $settings.day) {
              ForEach(DayOfTheWeek.allCases, id: \.self) { day in
                let pickerText = day.description
                Text("\(pickerText)")
              }
            }
          }
          HStack {
            Text("Weekly Reset Warning:")
            Spacer()
            Toggle("", isOn: $settings.weeklyResetWarning)
          }
        }
        HStack {
          Text("Level Scaling:")
          Picker("", selection: $user.scaling) {
            ForEach(LevelingSchemes.allCases, id: \.self) { scheme in
              let pickerText = scheme.description
              Text("\(pickerText)")
            }
          }
        }
        NavigationLink(destination: ManageRewardsView(minorRewards: minorRewards, milestoneRewards: milestoneRewards)) {
          Button("Manage Rewards") {
          }
        }
      }
      .navigationTitle("Settings").navigationBarTitleDisplayMode(.inline)
    }
    .onDisappear(perform: {
      settings.setNewResetTime()
      for quest in quests {
        if quest.type == .dailyQuest {
          quest.setDateToDailyResetTime(settings: settings)
        } else if quest.type == .weeklyQuest {
          quest.setDateToWeeklyResetDate(settings: settings)
        }
      }
    })
  }
}
