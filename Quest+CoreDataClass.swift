//
//  Quest+CoreDataClass.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 11/6/23.
//
//

import Foundation
import CoreData

@objc(Quest)
public class Quest: NSManagedObject {
  @Published public var isSelected: Bool = false
}
