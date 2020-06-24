//
//  IntroView.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 10.6.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import SwiftUI

// TODO: Intro view has a blurred background where a repeating sorting animation can
// be seen repeating, until user starts the animation.

struct IntroView: View {
   
   var engine: SortCoordinator
   
   var body: some View {
      VStack {
         VStack(alignment: .leading) {
            Text("This application demonstrates different sorting methods.\n")
            Text("There are \(engine.getCountOfSupportedMethods()) sorting methods supported currently.\n")
            Text("When you start, the methods are first animated to show how they do their job of sorting numbers.\n")
            Text("You can tap the animation screen to stop sorting and move to the next method.\n")
            Text("After animations, sorting methods are used to sort a large array and execution time is recorded. You will be able to see the results after this.\n")
            Text("You can adjust the count of numbers to sort as well as the animations in the application settings.")
         }
         .padding()
         Spacer()
         Button(action: {
            self.engine.execute()
         }) {
            Text("Tap to start")
         }
      }
   }
}

struct IntroView_Previews: PreviewProvider {
   static var previews: some View {
      IntroView(engine: SortCoordinator())
   }
}
