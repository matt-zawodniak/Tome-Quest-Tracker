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

  @Binding var settings: Settings
  @Binding var user: User

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
        HStack {
          Spacer()

          Button("Manage Rewards") {

          }.buttonStyle(.borderedProminent)
          Spacer()
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
      CoreDataController.shared.save(context: managedObjectContext)
    })
  }
}
