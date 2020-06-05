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
         Text(self.rowData.methodName)
            .font(.headline)
            .bold()
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

   var body: some View {
      VStack {
         VStack(alignment: .leading, spacing: 10) {
            Text("Sorting speed in seconds")
               .font(.headline)
            Divider()
            ForEach(engine.performanceTable, id: \.self) { item in
               PerformanceRow(rowData: item)
            }
         }
         Spacer()
         Button(action: {
            self.engine.stop()
         }) {
            Text("Back to start")
         }
      }
      .padding()
   }
}
