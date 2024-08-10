//
//  SettingsView.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 10/25/23.
//

import SwiftUI
import SwiftData
import StoreKit

struct SettingsView: View {
  @Environment(\.modelContext) var modelContext

  @Query() var quests: [Quest]

  @State var settings: Settings
  @State var user: User

  @StateObject var storeKit = StoreKitManager()

  var body: some View {
    List {
      Section {
        VStack {
          HStack {
            Text("Daily Reset Time:")

            DatePicker("", selection: $settings.time, displayedComponents: .hourAndMinute)
              .colorMultiply(.cyan)
              .onChange(of: settings.time) {
                if settings.weeklyResetWarning {

                  LocalNotifications().deleteWeeklyNotification()

                  LocalNotifications().scheduleWeeklyNotification(modelContext: modelContext)
                }
              }
          }
        }
      }
      .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
      .listRowSeparator(.hidden)

      Section {
        VStack {
          HStack {
            Text("Weekly Reset Day:")

            Picker("", selection: $settings.day) {
              ForEach(DayOfTheWeek.allCases, id: \.self) { day in
                Text("\(day.description)")
              }
            }
            .onChange(of: settings.day) {
              if settings.weeklyResetWarning {
                LocalNotifications().deleteWeeklyNotification()

                LocalNotifications().scheduleWeeklyNotification(modelContext: modelContext)
              }
            }
          }

          HStack {
            Text("Weekly Reset Warning:")

            Spacer()

            Toggle("", isOn: $settings.weeklyResetWarning)
              .onChange(of: settings.weeklyResetWarning) {

                if settings.weeklyResetWarning {

                  UNUserNotificationCenter.current().requestAuthorization(
                    options: [.alert, .badge, .sound]
                  ) { success, error in
                    if success {
                      LocalNotifications().scheduleWeeklyNotification(modelContext: modelContext)

                      print("Permission approved!")
                    } else if let error = error {
                      print(error.localizedDescription)
                    }
                  }
                } else {
                  LocalNotifications().deleteWeeklyNotification()
                }
              }
          }
        }
      }
      .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
      .listRowSeparator(.hidden)

      Section {
        HStack {
          Text("Level Scaling:")

          Picker("", selection: $user.scaling) {
            ForEach(LevelingSchemes.allCases, id: \.self) { scheme in
              let pickerText = scheme.description
              Text("\(pickerText)")
            }
          }
        }
      }
      .listRowBackground(StylizedOutline().stroke(.cyan.opacity(0.4)))
      .listRowSeparator(.hidden)

      ForEach(storeKit.storeProducts) { product in
        Section {
          StoreItem(storeKit: storeKit, product: product)
        }
        .listRowBackground(StylizedOutline().foregroundStyle(.cyan).opacity(storeKit.purchasedProducts.contains(product) ? 0 : 0.8))
        .listRowSeparator(.hidden)
      }
    }
    .padding(.horizontal)
    .foregroundStyle(.cyan)
    .listStyle(.grouped)
    .tint(.cyan)
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

#Preview {
    SettingsView(settings: PreviewSampleData.previewSettings, user: PreviewSampleData.previewUser)
      .modelContainer(PreviewSampleData.container)
}
