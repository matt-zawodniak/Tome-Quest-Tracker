//
//  CustomListBackground.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/21/24.
//

import SwiftUI

struct CustomListBackground: View {
  var type: QuestType

    var body: some View {
      HStack(spacing: 0) {
        switch type {
        case .mainQuest: Rectangle().frame(width: 10).foregroundStyle(.red).opacity(0.8).border(.black, width: 0.5)
        case .sideQuest: Rectangle().frame(width: 10).foregroundStyle(.yellow).opacity(0.8).border(.black, width: 0.5)
        case .dailyQuest: Rectangle().frame(width: 10).foregroundStyle(.green).opacity(0.8).border(.black, width: 0.5)
        case .weeklyQuest: Rectangle().frame(width: 10).foregroundStyle(.purple).opacity(0.8).border(.black, width: 0.5)
        }
        Rectangle().strokeBorder(.cyan.opacity(0.4))
//        switch type {
//        case .mainQuest: Rectangle().stroke(.red.opacity(0.6))
//
//        case .sideQuest: Rectangle().stroke(.yellow.opacity(0.6))
//
//        case .dailyQuest: Rectangle().stroke(.green.opacity(0.6))
//
//        case .weeklyQuest: Rectangle().stroke(.purple.opacity(0.6))
//        }
      }
    }
}

#Preview {
  CustomListBackground(type: .mainQuest)
}
