//
//  StylizedOutline.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/27/24.
//

import SwiftUI

struct StylizedQuestOutline: Shape {
  var opacity = 1

  func path(in rect: CGRect) -> Path {
    let bottomRight: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? rect.size.width * 0.95 : rect.size.width * 0.98
    let rightMid: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? rect.size.height - (rect.size.width * 0.05) : rect.size.height - (rect.size.width * 0.02)

    var path = Path()

    path.move(to: CGPoint(x: 0,
                          y: rect.size.height))

    path.addLine(to: CGPoint(x: bottomRight,
                             y: rect.size.height))

    path.addLine(to: CGPoint(x: rect.size.width,
                             y: rightMid))

    path.addLine(to: CGPoint(x: rect.size.width,
                             y: 0))

    path.addLine(to: CGPoint(x: 0, y: 0))

    return path
  }
}

struct StylizedOutline: Shape {
  var opacity = 1

  func path(in rect: CGRect) -> Path {
    let bottomRight: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? rect.size.width * 0.95 : rect.size.width * 0.98
    let rightMid: CGFloat = UIDevice.current.userInterfaceIdiom == .phone ? rect.size.height - (rect.size.width * 0.05) : rect.size.height - (rect.size.width * 0.02)

    var path = Path()

    path.move(to: CGPoint(x: 0,
                          y: 0))

    path.addLine(to: CGPoint(x: 0,
                             y: rect.size.height))

    path.addLine(to: CGPoint(x: bottomRight,
                             y: rect.size.height))

    path.addLine(to: CGPoint(x: rect.size.width,
                             y: rightMid))

    path.addLine(to: CGPoint(x: rect.size.width,
                             y: 0))

    path.addLine(to: CGPoint(x: 0, y: 0))

    return path
  }
}

#Preview {
  StylizedQuestOutline()
}
