//
//  NavigationBar.swift
//  Quest Tracker
//
//  Created by Matt Zawodniak on 2/16/24.
//

import SwiftUI

struct NavigationBar: View {
  var body: some View {
    ZStack {

      HStack {
        Spacer()
        Image(systemName: "house")
        Spacer()
        Image(systemName: "book.closed")
        Spacer()
        Spacer()
        Spacer()
        Image(systemName: "gift.fill")
        Spacer()
        Image(systemName: "gearshape")
        Spacer()
      }
      .frame(alignment: .top)

      Image(systemName: "plus.square.dashed").font(.largeTitle)
    }
  }
}

#Preview {
    NavigationBar()
}
