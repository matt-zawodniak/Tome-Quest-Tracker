//
//  SettingsView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 10/25/23.
//

import SwiftUI
import CoreData

struct SettingsView: View {
  @Environment(\.managedObjectContext) var managedObjectContext
  @FetchRequest(sortDescriptors: []) var quests: FetchedResults<Quest>

  @ObservedObject var settings: Settings
  var body: some View {
    NavigationStack {
      List {
        VStack {
          HStack {
            Text("Daily Reset Time:")
            DatePicker("", selection: $settings.time.bound, displayedComponents: .hourAndMinute)
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
          Picker("", selection: $settings.scaling) {
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
      for quest in quests {
        if quest.type == .dailyQuest {
          quest.setDateToDailyResetTime(quest: quest, settings: settings)
        } else if quest.type == .weeklyQuest {
          quest.setDateToWeeklyResetDate(quest: quest, settings: settings)
        }
      }
      CoreDataController.shared.save(context: managedObjectContext)
    })
  }
}

struct SettingsView_Previews: PreviewProvider {
  static func loadPreviewSettings(context: NSManagedObjectContext) -> Settings {
    let defaultSettings = Settings(context: context)

    var components = DateComponents()
    components.day = 1
    components.second = -1

    defaultSettings.dayOfTheWeek = 3
    defaultSettings.time = Calendar.current.date(byAdding: components, to: Calendar.current.startOfDay(for: Date()))
    defaultSettings.dailyResetWarning = true
    defaultSettings.weeklyResetWarning = false
    defaultSettings.levelingScheme = 2

    return defaultSettings
  }
  static var previews: some View {
    let previewContext = CoreDataController.shared.container.viewContext
    let settings = loadPreviewSettings(context: previewContext)
    SettingsView(settings: settings)
  }
}
