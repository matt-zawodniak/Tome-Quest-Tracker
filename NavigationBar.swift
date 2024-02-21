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
      VStack {
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
        .foregroundColor(.white)

        Divider()
          .frame(height: 2)
          .overlay(.cyan)
          .background(.indigo)
      }
      .padding()

      PlusNavBackground().fill().foregroundStyle(.black)
      PlusNavBackground().fill().foregroundStyle(.cyan.opacity(0.2))
        .background(PlusNavBackground().stroke(.cyan, lineWidth: 5))

      VStack {
        Image(systemName: "plus.square.dashed").font(.largeTitle)
          .foregroundColor(.cyan)
      }
    }
    .background(.black)
  }
}

#Preview {
    NavigationBar()
}
