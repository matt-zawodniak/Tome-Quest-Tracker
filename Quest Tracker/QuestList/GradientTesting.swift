//
//  GradientTesting.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/22/24.
//

import SwiftUI

struct GradientTesting: View {
    var body: some View {
      Rectangle()
        .foregroundStyle(AngularGradient(colors: [.cyan,
                                                  .black,
                                                  .cyan,
                                                  .black,
                                                  .cyan,
                                                  .black,
                                                  .black], center: .topLeading)
)
        .background(.black.gradient)
    }
}

#Preview {
    GradientTesting()
}
