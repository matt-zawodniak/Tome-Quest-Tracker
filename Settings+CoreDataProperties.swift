//
//  Settings+CoreDataProperties.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 11/3/23.
//
//

import Foundation
import CoreData


extension Settings {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Settings> {
        return NSFetchRequest<Settings>(entityName: "Settings")
    }

    @NSManaged public var dailyResetWarning: Bool
    @NSManaged public var dayOfTheWeek: Int64
    @NSManaged public var levelingScheme: Int64
    @NSManaged public var time: Date?
    @NSManaged public var weeklyResetWarning: Bool

}

extension Settings : Identifiable {

}
