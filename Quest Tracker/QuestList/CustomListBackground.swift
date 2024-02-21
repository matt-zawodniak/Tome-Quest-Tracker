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
        Rectangle().fill(.cyan.opacity(0.2))
      }
    }
}

#Preview {
  CustomListBackground(type: .mainQuest)
}
