//
//  SortCoordinator.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//


//TODO: Fix: at the end, cannot start from the beginning.
//TODO: After speed test, sort the array fastest > slowest

import Foundation

struct TimingResult: Hashable {
   let methodName : String
   let timing : Double
}

let defaultMaxMinValueOfElements = 100

class SortCoordinator : ObservableObject {
   
   //TODO: Each method has an implementation with "original" loops that is used in performance testing.
   //TODO: After showing animations of methods, comes a summary view where results of performance are shown.
   
   @Published var array : [Int]!
   @Published var methodName = String("Start sorting")
   @Published var performanceTable = [TimingResult]()
   
   var originalArray : [Int]!
   
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


   enum State {
      case atStart
      case animating
      case measuring
      case atEnd
   }
   var state = State.atStart
   
   required init() {
      originalArray = [Int]()
      originalArray.prepare(range: -defaultMaxMinValueOfElements...defaultMaxMinValueOfElements)
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
      timerInterval = TimerIntervals.waitingForNextSortStep
      timer = Timer.scheduledTimer(withTimeInterval: timerInterval.rawValue, repeats: true) { _ in
         switch self.state {
            case .atStart:
               self.state = .animating
               self.originalArray.prepare(range: -defaultMaxMinValueOfElements...defaultMaxMinValueOfElements)
               self.originalArray.shuffle()
               self.array = self.originalArray
               self.currentMethod!.restart()
               self.methodName = "Now sorting with \(self.currentMethod!.name)"
               self.running = true

            case .animating:
               if self.nextStep() {
                  self.nextMethod()
               }

            case .measuring:
               // Take timestamp
               let now = Date()
               // Do sorting with real algo
               let success = self.currentMethod?.realAlgorithm(arrayCopy: self.array)
               if success! {
                  // Take timestamp
                  // Calculate duration
                  let duration = Date().timeIntervalSince(now)
                  // Add to performanceTable
                  let result = TimingResult(methodName: self.currentMethod!.name, timing: duration)
                  self.performanceTable.append(result)
                  print(self.performanceTable)
               }
               self.nextMethod()

            case .atEnd:
               self.state = .atStart
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

      self.currentMethodIndex = 0
      self.currentMethod = self.sortingMethods[self.currentMethodIndex]
      let method = self.currentMethod?.name ?? "No method selected"
      self.methodName = "Next sort method: \(method)"

      switch state {
         case .animating:
            
            //TODO: use a really big array with real sorting.
            originalArray.prepare(range: -1000...1000)
            originalArray.shuffle()
            array = originalArray
            self.state = .measuring
            self.methodName = "Comparing algorithms in real time"
            self.performanceTable.removeAll(keepingCapacity: true)
            timer = Timer.scheduledTimer(withTimeInterval: TimerIntervals.waitingForNextSortMethod.rawValue, repeats: false) { _ in
               self.start()
            }

         case .measuring:
            self.state = .atEnd
            originalArray.prepare(range: -defaultMaxMinValueOfElements...defaultMaxMinValueOfElements)
            originalArray.shuffle()
            array = originalArray
            running = false

         default:
            break
      }
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
      array = originalArray
      currentMethodIndex += 1
      if self.currentMethodIndex < self.sortingMethods.count {
         currentMethod = sortingMethods[self.currentMethodIndex]
         currentMethod?.restart()
         if state != .measuring {
            let method = currentMethod?.name ?? "No method selected"
            methodName = "Next method: \(method)"
         }
         timer = Timer.scheduledTimer(withTimeInterval: TimerIntervals.waitingForNextSortMethod.rawValue, repeats: false) { _ in
            self.start()
         }
      } else {
         stop()
      }
   }
   
   func getArray() -> [Int] {
      return array
   }
   
}

