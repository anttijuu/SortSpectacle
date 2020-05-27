//
//  SortCoordinator.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

class SortCoordinator : ObservableObject {
   
   //TODO: Two arrays, one original and one for sorters to use -- all methods start from the same shuffled data.
   // That way results are comparable between sorters.
   //TODO: Each method has an implementation with "original" loops that is used in performance testing.
   //TODO: After showing animations of methods, comes a summary view where results of performance are shown.
   
   @Published var array : [Int]!
   @Published var methodName = String("Start sorting")
   
   private var originalArray : [Int]!
   
   enum TimerIntervals : Double {
      case waitingForNextSortMethod = 1.0
      case waitingForNextSortStep = 0.0005
   }
   
   private var currentMethod : SortMethod? = nil
   private var timer : Timer?
   private var timerInterval = TimerIntervals.waitingForNextSortStep
   private var running = false
   
   private var swappedItems = SwappedItems(first: -1, second: -1)
   
   private var currentMethodIndex = 0
   private var sortingMethods = [SortMethod]()
   
   required init() {
      originalArray = [Int]()
      originalArray.prepare(range: -170...170)
      originalArray.shuffle()
      array = originalArray
      sortingMethods.append(BubbleSort(arraySize: array.count))
      sortingMethods.append(ShellSort(arraySize: array.count))
      sortingMethods.append(LampSort(arraySize: array.count))
      currentMethodIndex = 0
      currentMethod = sortingMethods[currentMethodIndex]
      methodName = "Next sort method: \(currentMethod!.name)"
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
      array = originalArray
      currentMethod!.restart()
      methodName = "Now sorting with \(currentMethod!.name)"
            
      timerInterval = TimerIntervals.waitingForNextSortStep
      timer = Timer.scheduledTimer(withTimeInterval: timerInterval.rawValue, repeats: true) { _ in
         if self.nextStep() {
            if self.currentMethodIndex < self.sortingMethods.count - 1 {
               self.nextMethod()
            } else {
               self.stop()
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
      }
      running = false
      self.currentMethodIndex = 0
      self.currentMethod = self.sortingMethods[self.currentMethodIndex]
      let method = self.currentMethod?.name ?? "No method selected"
      self.methodName = "Next sort method: \(method)"
   }
   
   func nextStep() -> Bool {
      var returnValue = false
      returnValue = currentMethod!.nextStep(array: array, swappedItems: &swappedItems)
      self.array.handleSortOperation(operation: swappedItems)
      return returnValue
   }
   
   func nextMethod() -> Void {
      if let clock = timer {
         clock.invalidate()
      }
      self.currentMethodIndex += 1
      self.currentMethod = self.sortingMethods[self.currentMethodIndex]
      self.currentMethod?.restart()
      let method = self.currentMethod?.name ?? "No method selected"
      self.methodName = "Next method: \(method)"
      timer = Timer.scheduledTimer(withTimeInterval: TimerIntervals.waitingForNextSortMethod.rawValue, repeats: false) { _ in
         self.start()
      }
      

   }
   
   func getArray() -> [Int] {
      return array
   }
   
   
   
}
