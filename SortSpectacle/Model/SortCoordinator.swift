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
      prepare(range: -170...170)
      currentMethod = BubbleSort()
      methodName = (currentMethod?.getName())!
   }
   
   func getName() -> String {
      if let method = currentMethod {
         return method.getName()
      }
      return "No sort method selected"
   }

   
   func prepare(count : Int) {
      array.prepare(count: count)
   }
   
   func prepare(range : ClosedRange<Int>) {
      array.prepare(range: range)
   }
   
   func start() -> Void {
      running = true
      array.shuffle()
      if let method = currentMethod {
         method.restart()
         methodName = method.getName()
         //TODO: Replace timer with GCD async queue, then implement quicksort
         timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
            if self.nextStep() {
               self.timer?.invalidate()
               self.running = false
            }
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
         if method.nextStep(&array) {
            return true
         }
      }
      return false
   }
   
   func getArray() -> [Int] {
      return array
   }
   
   
   
}
