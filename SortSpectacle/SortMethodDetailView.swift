//
//  SortMethodDetailView.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.6.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import SwiftUI

struct SortMethodDetailView: View {
   var sortMethod: SortMethod

   var body: some View {
      VStack {
         Text(sortMethod.description)
         Spacer()
         ForEach(0..<sortMethod.webLinks.count) { linkIndex in
            Button(action: {
               if let url = URL(string: self.sortMethod.webLinks[linkIndex].1) {
                  UIApplication.shared.open(url)
               }
            }) {
               HStack {
                  Image(systemName: "link.circle.fill")
                  Text(self.sortMethod.webLinks[linkIndex].0)
               }
            }
         }
         .padding(.bottom)
      }
      .padding()
      .navigationBarTitle(sortMethod.name)
   }

   //            Link(description, destination: URL(string: link)!) {
   //               Image(systemName: "link.circle.fill")
   //                  .font(.largeTitle)
   //            }

}

struct SortMethodDetailView_Previews: PreviewProvider {
   static var previews: some View {
      SortMethodDetailView(sortMethod: BubbleSort(arraySize: 10))
   }
}
