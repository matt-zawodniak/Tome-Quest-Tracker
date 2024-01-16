//
//  CoreDataControllerPreview.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 1/16/24.
//

import Foundation

extension CoreDataController {
  static var preview: CoreDataController = {
    let result = CoreDataController(inMemory: true)
    let viewContext = result.container.viewContext
    for number in 1..<3 {
      let newReward = Reward(context: viewContext)
      newReward.name = "Reward \(number)"
      newReward.isEarned = true
      newReward.isClaimed = false
      newReward.sortId = Int64(number)
    }
    for number in 4..<9 {
      let newReward = Reward(context: viewContext)
      newReward.name = "Reward \(number)"
      newReward.isEarned = false
      newReward.isClaimed = false
      newReward.sortId = Int64(number)
    }
    let previewUser = User(context: viewContext)
    previewUser.currentExp = 27
    previewUser.expToLevel = 40
    previewUser.level = 3

    do {
      try viewContext.save()
    } catch {
      let nsError = error as NSError
      fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
    }
    return result
  }()
}
