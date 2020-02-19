//
//  ContentView.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 19.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import SwiftUI

struct NumbersShape : Shape {
   func path(in rect: CGRect) -> Path {
      var path = Path()
      path.addRect(rect)
      path.move(to: CGPoint(x: rect.origin.x+rect.width/2, y: rect.origin.y))
      path.addLine(to: CGPoint(x: rect.origin.x+rect.width/2, y: rect.origin.y+rect.height))
      return path
   }
}

struct ContentView: View {
   
   private var numbers = NumberCollection(range: 100)
   
    var body: some View {
      VStack {
         Text("Sort Spectacle")
            .font(.largeTitle)
         Text("<sort method here>")
         NumbersShape()
            .stroke()
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
