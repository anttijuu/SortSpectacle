//
//  ContentView.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 19.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import SwiftUI

struct NumbersShape : Shape {
   private var array : [Int]!
   private var maxAbsValue = 1
   private var minValue = 0
   
   init(sourceArray : [Int]) {
      array = sourceArray
      if (array.count > 2) {
         maxAbsValue = abs(array.max()!) > abs(array.min()!) ? array.max()! : array.min()!
         minValue = array.min()!
      }
   }
   
   func path(in rect: CGRect) -> Path {
      var path = Path()
      path.addRect(rect)
      
      var xOrigin = rect.origin.x
      if (minValue >= 0) {
         xOrigin += 2
      } else {
         xOrigin = rect.origin.x+rect.width/2
      }
      var pixelsPerLineUnit = (rect.width - xOrigin) / CGFloat(maxAbsValue)
      if (pixelsPerLineUnit <= 0) {
         pixelsPerLineUnit = 1;
      }
      path.move(to: CGPoint(x: xOrigin, y: rect.origin.y))
      path.addLine(to: CGPoint(x: xOrigin, y: rect.origin.y+rect.height))
      var yOrigin = rect.origin.y+2
      var xTarget = xOrigin
      for number in array {
         path.move(to: CGPoint(x: xOrigin, y: yOrigin))
         xTarget = CGFloat(number) * pixelsPerLineUnit
         path.addLine(to: CGPoint(x: xOrigin + xTarget, y: yOrigin))
         yOrigin += 2
      }
      return path
   }
}

struct ContentView: View {
   
   @State private var numbers = [Int]()
   @State private var sorter : SortMethod?
   
   init() {
//      numbers = [Int]()
      numbers.prepare(range: -150...150, count: 200)
      sorter = BubbleSort(array: &numbers)
   }
   
   mutating func toggleSortOnOff() {
      if let worker = sorter {
         worker.stop()
      } else {
         sorter?.start()
      }
   }
   
   var body: some View {
      let _ = TapGesture()
         .onEnded { _ in
            if let worker = self.sorter {
               worker.stop()
            } else {
               self.sorter = BubbleSort(array: &self.numbers)
               self.sorter?.start()
            }
      }
      
      return VStack {
         Text("Sort Spectacle")
            .font(.largeTitle)
         Text("<sort method here>")
         NumbersShape(sourceArray: numbers)
            .stroke()
      }
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}
