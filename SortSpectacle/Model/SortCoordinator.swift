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
   
   private var swappedItems = SwappedItems(first: -1, second: -1)
   
   // Dispatch queues
   let dispatchGroup = DispatchGroup()
   let dispatchQueue = DispatchQueue(label: "com.juustila.antti.SortCoordinator", qos: .userInitiated, attributes: .concurrent)
   let dispatchSemafore = DispatchSemaphore(value: 0)
   
   required init() {
      array = [Int]()
      prepare(range: -10...10)
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
         
         print("Starting the sorting...")
         
         while running {
            print("Still running...")
            
            dispatchQueue.asyncAfter(deadline: .now() + .milliseconds(10), qos: .userInitiated, flags: .barrier) {
               print("Async task initiated")
               self.dispatchGroup.enter()
               
               if self.nextStep() {
                  self.running = false
               }
               self.dispatchGroup.leave()
               self.dispatchSemafore.wait()
            }
            print("After asyncAfter")
            self.dispatchSemafore.signal()
            
            dispatchGroup.notify(queue: dispatchQueue) {
               print("At dispatchGroup.notify")
               
               print("At DispatchQueue.main.async block")
               if self.swappedItems.first >= 0 && self.swappedItems.second >= 0 {
                  print("Decided to swap items")
                  DispatchQueue.main.async(execute: {
                     print(">> Actually swapping here")
                     self.array.swapAt(self.swappedItems.first, self.swappedItems.second)
                  })
                  self.swappedItems.first = -1
                  self.swappedItems.second = -1
               }
               
            }

            
         }
         //TODO: Replace timer with GCD async queue, then implement quicksort
//         timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) { _ in
//            if self.nextStep() {
//               self.timer?.invalidate()
//               self.running = false
//            }
//         }
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
         if method.nextStep(array: array, swappedItems: &swappedItems) {
            return true
         }
      }
      return false
   }
   
   func getArray() -> [Int] {
      return array
   }
   
   
   
}
