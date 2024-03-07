//
//  Reward.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/22/24.
//
//

import Foundation
import SwiftData

@Model public class Reward {

  var dateEarned: Date?

  var isEarned: Bool = false

  var isMilestoneReward: Bool = false

  var name: String = ""

  var sortId: Int64 = -1

  public init(isMilestoneReward: Bool, name: String, sortId: Int64) {

    self.isMilestoneReward = isMilestoneReward
    self.name = name
    self.sortId = sortId

  }

}
