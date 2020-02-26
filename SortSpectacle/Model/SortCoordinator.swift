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
   
   enum TimerIntervals : Double {
      case waitingForNextSortMethod = 1.0
      case waitingForNextSortStep = 0.001
   }
   
   private var currentMethod : SortMethod? = nil
   private var timer : Timer?
   private var timerInterval = TimerIntervals.waitingForNextSortStep
   private var running = false
   
   private var swappedItems = SwappedItems(first: -1, second: -1)
   
   private var currentMethodIndex = 0
   private var sortingMethods = [SortMethod]()
   
   required init() {
      array = [Int]()
      prepare(range: -150...150)
      array.shuffle()
      sortingMethods.append(BubbleSort(arraySize: array.count))
      sortingMethods.append(LampSort(arraySize: array.count))
      currentMethodIndex = 0
      currentMethod = sortingMethods[currentMethodIndex]
      methodName = "Next: \(currentMethod!.name)"
   }
   
   func getName() -> String {
      return currentMethod!.name
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
      currentMethod!.restart()
      methodName = "Now sorting with \(currentMethod!.name)"
      
      print("Starting the sorting...")
      
      timer = Timer.scheduledTimer(withTimeInterval: timerInterval.rawValue, repeats: true) { _ in
         self.timerInterval = TimerIntervals.waitingForNextSortStep
         if self.nextStep() {
            if self.currentMethodIndex < self.sortingMethods.count - 1 {
               self.currentMethodIndex += 1
               self.currentMethod = self.sortingMethods[self.currentMethodIndex]
               self.array.shuffle()
               self.currentMethod?.restart()
            } else {
               self.timer?.invalidate()
               self.running = false
               self.currentMethodIndex = 0
               self.currentMethod = self.sortingMethods[self.currentMethodIndex]
            }
            let method = self.currentMethod?.name ?? "No method selected"
            self.methodName = "Next: \(method)"
            self.timerInterval = TimerIntervals.waitingForNextSortMethod
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
      var returnValue = false
      returnValue = currentMethod!.nextStep(array: array, swappedItems: &swappedItems)
      if self.swappedItems.first >= 0 && self.swappedItems.second >= 0 {
         self.array.swapAt(self.swappedItems.first, self.swappedItems.second)
         self.swappedItems.first = -1
         self.swappedItems.second = -1
      }
      return returnValue
   }
   
   func getArray() -> [Int] {
      return array
   }
   
   
   
}


//// Dispatch queues
//let dispatchGroup = DispatchGroup()
//let dispatchQueue = DispatchQueue(label: "com.juustila.antti.SortCoordinator", qos: .userInitiated, attributes: .concurrent)
//let dispatchSemafore = DispatchSemaphore(value: 0)


// Sync works but does not update display while sorting
//            dispatchQueue.sync {
//               if self.nextStep() {
//                  self.running = false
//               }
//            }

// Trying out async
//            dispatchQueue.asyncAfter(deadline: .now() + .milliseconds(10), qos: .userInitiated, flags: .barrier) {
//               print("Async task initiated")
//               self.dispatchGroup.enter()
//
//               if self.nextStep() {
//                  self.running = false
//               }
//               self.dispatchGroup.leave()
//               self.dispatchSemafore.wait()
//            }
//            print("After asyncAfter")
//            self.dispatchSemafore.signal()
//
//            dispatchGroup.notify(queue: dispatchQueue) {
//               print("At dispatchGroup.notify")
//
//               print("At DispatchQueue.main.async block")
//               if self.swappedItems.first >= 0 && self.swappedItems.second >= 0 {
//                  print("Decided to swap items")
//                  DispatchQueue.main.async(execute: {
//                     print(">> Actually swapping here")
//                     self.array.swapAt(self.swappedItems.first, self.swappedItems.second)
//                  })
//                  self.swappedItems.first = -1
//                  self.swappedItems.second = -1
//               }
//
//            }

