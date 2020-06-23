//
//  ContentView.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 19.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import SwiftUI

var lineWidth: CGFloat = 1.0

/**
 A shape which draws the numbers in an array of integers as lines.
 
 The area to draw is adjusted to the Rect in the parameter to the `path` function. Line
 lengths are adjusted to the range of numbers so that the largest (abs) value determines the length
 of the tallest line. Line widht is also calculated based on the number of lines to draw adjusted to the available space.
 */
struct NumbersLineShape: Shape {
   private var array: [Int]
   private var maxAbsValue = 1
   private var minValue = 0

   /**
    Initializes the shape by providing the array which contains the numbers to be drawn.
    - parameter sourceArray: The array to draw.
   */
   init(sourceArray: [Int]?) {
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

   /**
    Creates the `Path` shape from the numbers in the array
    - parameter rect: The rectangle to draw the lines.
    - returns: Returnst the path to draw to the View.
   */
   func path(in rect: CGRect) -> Path {
      var path = Path(rect)

      lineWidth = rect.height / CGFloat(array.count)

      var xOrigin = rect.origin.x
      if minValue >= 0 {
         xOrigin += 2
      } else {
         xOrigin = rect.origin.x+rect.width/2
      }
      var pixelsPerLineUnit = (rect.width - xOrigin) / CGFloat(maxAbsValue)
      if pixelsPerLineUnit <= 0 {
         pixelsPerLineUnit = 1
      }
//      path.move(to: CGPoint(x: xOrigin, y: rect.origin.y))
//      path.addLine(to: CGPoint(x: xOrigin, y: rect.origin.y+rect.height))
      var yOrigin = rect.origin.y+2
      var xTarget = xOrigin
      //print("Drawing path for \(array.count) numbers...")
      for number in array {
         path.move(to: CGPoint(x: xOrigin, y: yOrigin))
         xTarget = CGFloat(number) * pixelsPerLineUnit
         // path.addLine(to: CGPoint(x: xOrigin + xTarget, y: yOrigin))
         path.addEllipse(in: CGRect(origin: CGPoint(x: xOrigin + xTarget, y: yOrigin-1), size: CGSize(width: 3, height: 3)))
         yOrigin += lineWidth
      }
      return path
   }
}

/**
 The main view of the app.
 
 The view displays, depending on the state of the `SortCoordinator`:
 
 - either the animation of the sorting being executed, or
 - the timing results of the "real" algorithms being executed.
 
 Tapping the view starts the animation, executing all the supported sorting algorithms. After the
 animations are done, the same algorithms are again executed without animations nor delays. Execution
 time is measured and then displayed as each algorithm finishes. After this, user can restart the whole
 thing again by tapping the screen.
 */
struct ContentView: View {

   @ObservedObject private var sortEngine = SortCoordinator()

   var tap: some Gesture {
      TapGesture(count: 1)
         .onEnded { _ in
            if self.sortEngine.isExecuting() {
               print("Stopped sorter")
               self.sortEngine.nextMethod()
            } else {
               print("Starting sorter")
               self.sortEngine.execute()
            }
      }
   }

   // TODO: IntroView has longer text explaining the app
   // TODO: ContentView is a ZStack where text about the current sort method is transparent and floating atop of the shapes
   // TODO: ResultsView is a list where clicking a line takes to details.
   var body: some View {

      VStack {
         Text("Sort it out")
            .font(.largeTitle)
         Text(sortEngine.description)
            .font(.headline)
         Spacer()
         if sortEngine.state == SortCoordinator.State.atStart {
            IntroView(engine: sortEngine)
         } else if sortEngine.state == SortCoordinator.State.animating {
            NumbersLineShape(sourceArray: sortEngine.array)
               .stroke(Color.red, style: StrokeStyle(lineWidth: 1.0, lineCap: .butt, lineJoin: .miter, miterLimit: 1))
               .gesture(tap)
         } else {
            ResultsView(engine: sortEngine)
         }
      }
   }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
      ContentView()
   }
}
