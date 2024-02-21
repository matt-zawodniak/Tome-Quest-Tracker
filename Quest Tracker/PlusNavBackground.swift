//
//  PlusNavBackground.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/16/24.
//

import SwiftUI

struct PlusNavBackground: Shape {

  var opacity = 1

  func path(in rect: CGRect) -> Path {

    var path = Path()

    path.move(to: CGPoint(x: rect.size.width * 0.4,
                          y: 0))
    path.addLine(to: CGPoint(x: rect.size.width * 0.45,
                             y: rect.size.height * 0.95))
    path.addLine(to: CGPoint(x: rect.size.width * 0.55,
                             y: rect.size.height * 0.95))
    path.addLine(to: CGPoint(x: rect.size.width * 0.6,
                             y: 0))

    return path
 }
}

#Preview {
    PlusNavBackground()
}
