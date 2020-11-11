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
   var method: SortMethod
   
   var body: some View {
      NavigationLink(destination: SortMethodDetailView(sortMethod: method)) {
         VStack(alignment: .leading) {
            Text(self.rowData.methodName)
               .font(.headline)
            Text(self.rowData.timingAsString)
               .font(.system(.subheadline, design: .monospaced))
         }
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
      NavigationView {
         VStack {
            Text("Hall of Fame")
               .font(.title)
            List {
               ForEach(engine.performanceTable, id: \.self) { item in
                  PerformanceRow(rowData: item, method: self.engine.getMethod(for: item.methodName)!)
               }
            }
            Button(action: {
               self.engine.stop()
            }) {
               Text("Back to start")
            }
         }
      }
      .frame(alignment: .top)
      .navigationBarTitle("Sorting speed in secs")
   }
}

struct ResultsView_Previews: PreviewProvider {
   static var previews: some View {
      let engine = SortCoordinator()
      return ResultsView(engine: engine)
   }
}
