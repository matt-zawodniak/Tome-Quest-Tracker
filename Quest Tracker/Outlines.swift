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

    var path = Path()

//    path.move(to: CGPoint(x: 0,
//                          y: 0))
    path.move(to: CGPoint(x: 0,
                             y: rect.size.height))
    path.addLine(to: CGPoint(x: rect.size.width * 0.95,
                             y: rect.size.height))
    path.addLine(to: CGPoint(x: rect.size.width,
                             y: rect.size.height - (rect.size.width * 0.05 )))
    path.addLine(to: CGPoint(x: rect.size.width,
                             y: 0))
    path.addLine(to: CGPoint(x: 0, y: 0))

    return path
 }
}

struct StylizedOutline: Shape {

  var opacity = 1

  func path(in rect: CGRect) -> Path {

    var path = Path()

    path.move(to: CGPoint(x: 0,
                          y: 0))
    path.addLine(to: CGPoint(x: 0,
                             y: rect.size.height))
    path.addLine(to: CGPoint(x: rect.size.width * 0.95,
                             y: rect.size.height))
    path.addLine(to: CGPoint(x: rect.size.width,
                             y: rect.size.height - (rect.size.width * 0.05)))
    path.addLine(to: CGPoint(x: rect.size.width,
                             y: 0))
    path.addLine(to: CGPoint(x: 0, y: 0))

    return path
 }
}

#Preview {
    StylizedQuestOutline()
}
