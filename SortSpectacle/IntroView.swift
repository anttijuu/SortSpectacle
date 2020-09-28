//
//  IntroView.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 10.6.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import SwiftUI
import Combine

// TODO: Intro view has a blurred background where a repeating sorting animation can
// be seen repeating, until user starts the animation.

struct IntroView: View {
   
   @ObservedObject var engine: SortCoordinator

   @State var numberArray: [Int] = [100, 150, 200, 400, 600, 1000, 2000]
   @State var selectedNumberIndex = 3

   var body: some View {
      VStack {
         VStack(alignment: .leading) {
            Text("Demonstration of different sorting methods.\n")
               .font(.title2)
            Text("There are \(engine.getCountOfSupportedMethods()) sorting methods supported currently.\n")
            Text("When you start, the methods are first animated to show how they do their job of sorting numbers.\n")
            Text("You can tap the animation screen to stop sorting and move to the next method.\n")
            Text("After animations, sorting methods are used to sort a large array and execution time is recorded. You will be able to see the results after this.\n")
            Text("You can adjust the count of numbers to sort (currently \(engine.countOfNumbers)) as well as the animations in the application settings.")
            Picker(selection: self.$selectedNumberIndex, label: Text("How many numbers to sort")) {
               ForEach(0..<self.numberArray.count) { number in
                  Text("\(numberArray[number])")
               }
            }
            .pickerStyle(SegmentedPickerStyle())
         }
         .padding()
         Spacer()
         Button(action: {
            self.engine.prepare(count: numberArray[selectedNumberIndex])
            self.engine.execute()
         }) {
            Text("Tap to start")
         }
      }
   }
}

struct IntroView_Previews: PreviewProvider {
   static var coordinator = SortCoordinator()
   static var previews: some View {
      IntroView(engine: coordinator)
   }
}
