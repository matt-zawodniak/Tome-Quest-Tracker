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
    content.title = "Weekly Reset"
    content.subtitle = "You have one day left to complete your weekly tasks!"
    content.sound = UNNotificationSound.default

    let settings = Settings.fetchFirstOrInitialize(context: modelContext)

    var components = Calendar.current.dateComponents([.hour, .minute, .second], from: settings.time)
    components.weekday = Int(settings.dayOfTheWeek) - 1

    let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

    let request = UNNotificationRequest(identifier: "weeklyReset",
                                        content: content,
                                        trigger: trigger)

    UNUserNotificationCenter.current().add(request)

    print(components)
  }

  public func deleteWeeklyNotification() {

    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["weeklyReset"])
  }
}
