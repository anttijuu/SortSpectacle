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
      Button(action: {
         self.engine.execute()
      }) {
         Text("Tap to start")
      }
   }
}

struct IntroView_Previews: PreviewProvider {
   static var previews: some View {
      IntroView(engine: SortCoordinator())
   }
}
