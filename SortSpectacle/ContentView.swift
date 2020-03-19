//
//  ContentView.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 19.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import SwiftUI

var lineWidth : CGFloat = 1.0

struct NumbersShape : Shape {
   private var array : [Int]
   private var maxAbsValue = 1
   private var minValue = 0
   
   init(sourceArray : [Int]?) {
      if let arr = sourceArray {
         //print("Init NumbersShape with \(arr.count) numbers.")
         array = arr
         if array.count > 2 {
            maxAbsValue = abs(array.max()!) > abs(array.min()!) ? array.max()! : array.min()!
            maxAbsValue = abs(maxAbsValue)
            minValue = array.min()!
         }
      } else {
         array = [Int]()
      }
   }
   
   func path(in rect: CGRect) -> Path {
      var path = Path()
      path.addRect(rect)
      
      lineWidth = rect.height / CGFloat(array.count)
      
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
      //print("Drawing path for \(array.count) numbers...")
      for number in array {
         path.move(to: CGPoint(x: xOrigin, y: yOrigin))
         xTarget = CGFloat(number) * pixelsPerLineUnit
         path.addLine(to: CGPoint(x: xOrigin + xTarget, y: yOrigin))
         yOrigin += lineWidth
      }
      return path
   }
}

struct ContentView: View {
   
   @ObservedObject private var sortEngine = SortCoordinator()
   
   var tap: some Gesture {
      TapGesture(count: 1)
         .onEnded { _ in
            if self.sortEngine.isRunning() {
               print("Stopped sorter")
               self.sortEngine.stop()
            } else {
               print("Starting sorter")
               self.sortEngine.start()
            }
      }
   }
   
   var body: some View {
      
      return VStack {
         Text("Sort it out")
            .font(.largeTitle)
         Text(sortEngine.methodName)
         NumbersShape(sourceArray: sortEngine.getArray())
            .stroke(Color.red, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round, miterLimit: 3))
            .gesture(tap)
      }
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}
