//
//  LocalNotifications.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 3/11/24.
//

import SwiftUI
import UserNotifications
import SwiftData

struct LocalNotifications {

  public func scheduleWeeklyNotification(modelContext: ModelContext) {

    let content = UNMutableNotificationContent()
    content.title = "Dawn of the Final Day"
    content.subtitle = "Weekly reset is in one day!"
    content.sound = UNNotificationSound.default

    let settings = Settings.fetchFirstOrCreate(context: modelContext)

    var components = Calendar.current.dateComponents([.hour, .minute, .second], from: settings.time)
    components.weekday = Int(settings.dayOfTheWeek) - 1

    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

    let request = UNNotificationRequest(identifier: "weeklyReset",
                                        content: content,
                                        trigger: trigger)

    UNUserNotificationCenter.current().add(request)
  }

  public func deleteWeeklyNotification() {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["weeklyReset"])
  }
}
