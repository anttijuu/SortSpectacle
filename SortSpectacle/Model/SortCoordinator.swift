//
//  SortCoordinator.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

class SortCoordinator : ObservableObject {
   
   @Published var array : [Int]!
   @Published var methodName = String("Start sorting")
   
   private var currentMethod : SortMethod?
   private var timer : Timer?
   private var running = false

   required init() {
      array = [Int]()
      prepare(count: 20)
      currentMethod = BubbleSort(array: &self.array)
      methodName = (currentMethod?.getName())!
   }
   
   func getName() -> String {
      if let method = currentMethod {
         return method.getName()
      }
      return "Start sorting"
   }

   
   func prepare(count : Int) {
      array.prepare(count: count)
   }
   
   func start() -> Void {
      running = true
      array.shuffle()
      timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
         if self.nextStep() {
            print("=== Sorter finished")
            self.timer?.invalidate()
            self.running = false
         }
      }
   }
   
   func isRunning() -> Bool {
      return running
   }
   
   func stop() -> Void {
      if let clock = timer {
         clock.invalidate()
         running = false
      }
   }
   
   func nextStep() -> Bool {
      if let method = currentMethod {
         if method.nextStep() {
            print("Coordinator array: \(array ?? [])")
            return true
         }
      }
      return false
   }
   
   func getArray() -> [Int] {
      return array
   }
   
   
   
}
