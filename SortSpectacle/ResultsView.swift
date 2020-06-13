//
//  ResultsView.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 5.6.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import SwiftUI

struct PerformanceRow: View {
   
   var rowData: TimingResult
   
   var body: some View {
      HStack {
//         Button(action: {
//            self.showDetails.toggle()
//         }) {
//            Image(systemName: "info.circle")
//               .frame(minWidth: 20, maxWidth: 20, minHeight: 50, maxHeight: 50)
//               .font(Font.system(.title))
//         }
         Image(systemName: "info.circle")
//            .frame(minWidth: 20, maxWidth: 20, minHeight: 20, maxHeight: 20)
            .font(Font.system(.headline))
         Text(self.rowData.methodName)
            .font(.headline)
            .multilineTextAlignment(.leading)
         Spacer()
         Text(self.rowData.timingAsString)
            .font(.system(.headline, design: .monospaced))
            .multilineTextAlignment(.trailing)
      }
   }
}

/**
 The view displaying the results from executing the "real" sorting algorithms without the delays
 caused by the animations and step by step execution of the algorithms.
 */
struct ResultsView: View {
   /// The timing results for each of the algorithm executed.
   @ObservedObject var engine: SortCoordinator
   @State var description = ""
      
   var body: some View {
      VStack(alignment: .leading) {
         VStack(alignment: .leading, spacing: 20) {
            Text("Sorting speed in seconds")
               .font(.headline)
            Divider()
            ForEach(engine.performanceTable, id: \.self) { item in
               PerformanceRow(rowData: item)
//                  .padding(.all, 1.0)
                  .onTapGesture {
                     self.description = self.engine.getDescription(for: item.methodName)
                  }
            }
         }
         Spacer()
         if description.count > 0 {
            Text(description)
            Spacer()
         }
         Button(action: {
            self.engine.stop()
         }) {
            Text("Back to start")
         }
      }
      .padding()
   }
}
