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

/**
 Records the timing of sort methods executed in a tight loop. The results are shown
 in the UI after animating the results.
 */
struct TimingResult: Hashable {
   /// The name of the sorting algorithm.
   let methodName: String
   /// The amount of seconds the algorithm took to sort the array.
   let timing: Double
}

/// Minimum default value of elements to generate to the array for sorting.
let defaultMaxMinValueOfElements = 100

/**
 SortCoordinator coordinates, as the name implies, sorting of arrays using different sorting methods.
 It is an `ObservableObject`, being observerd by a `View` that holds the coordinator as an `@ObservedObject`
 to show the state of the sorting in the UI.
 
 SortCoordinator:
  - holds the array to be sorted, giving it to each sort method by calling SortMethod.nextStep().
  - times the sorting process using a `Timer`
  - publishes the array to the Views so that when the array is updated, view is redrawn.
  - collects the timing results using `SortMethod.realAlgorithm(...)`, to show to the user the time the algoritms
 take to sort the array without any animations.
 
 SortCoordinator is to be used so that the client (a SwiftUI View):
 
 1. creates the SortCoordinator object
 1. calls `execute()` when user is tapping some element in the UI
 1. reacts to the events in the SortCoordinator when the array within changes, by updating the UI
 1. calls `stop()` if user wants to stop the sorting by tapping in the View.
 
 For details, see the properties and methods in this class as well as the `SortMethod` protocol which all the sorting methods implement.
 
 */
class SortCoordinator: ObservableObject {

   /** The data to be sorted is generated to `originalArray` first, then copied to
    the array member. This is to make sure that all sorting methods start from exactly the
    same data. This produces comparable performance metrics, since how the data is organized
    in the array influences the sorting methods' performance.
   */
   var originalArray: [Int]!

   /// The array that is actually used in the sorting. This is also displayed in the UI, the reason why it is @Published.
   @Published var array: [Int]!
   /// The (current) sorting methods used. Value changes when execution moves from one method to another.
   @Published var methodName = String("Start sorting")
   /// This table will include the real time performance metrics of the sorting methods after the measuring phase.
   @Published var performanceTable = [TimingResult]()

   /// These timer interval values are used in different phases of the sorting to control timing the execution.
   enum TimerIntervals: Double {
      /// A longer gap in between the sorting methods is used.
      case waitingForNextSortMethod = 1.0
      /// A very short gap is used in between the steps of the sorting methods to keep the animation going swiftly.
      case waitingForNextSortStep = 0.0005
   }

   /// The currently executing sorthing method reference.
   private var currentMethod: SortMethod?
   /// A timer is used to control the execution of the sorting.
   private var timer: Timer?
   /// Holds the current interval used in the timing.
   private var timerInterval = TimerIntervals.waitingForNextSortStep
   /// Is true, if sorting is ongoing, otherwise false.
   private var executing = false

   /// Sorting methods indicate which array elements (if any) are to be swapped or moved with each step of the sorting method.
   private var swappedItems = SwappedItems(first: -1, second: -1)

   /// Which of the sorting methods in the sortingMethod array is currently executed.
   private var currentMethodIndex = 0
   /// All the supported sorting methods are placed in the array before starting the execution.
   private var sortingMethods = [SortMethod]()

   /// The different states of the execution of the sort coordinator.
   enum State {
      /// Starting phase, where preparation for the execution is done
      case atStart
      /// The animating phase, where sorting methods are executed one by one, step by step, by calling the nextStep() method.
      case animating
      /// After animation, all sorting methods are executed using the realAlgorithm() method to time the "actual" perfomance of the methods.
      case measuring
      /// End phase, where the exection is finished.
      case atEnd
   }
   /// The state variable, holding the execution state.
   var state = State.atStart

   /// Initializes the coordinator by preparing the arrays with data and appending all the supported methods to the sorting array.
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

   /**
    Gets the name of the currently executing sorting method.
    - returns: The name of the currently executing sorting method.
    */
   func getName() -> String {
      return currentMethod!.name
   }

   /**
    Prepares the coordinator for sorting. Currently not used, so consider removing.
    - parameter count: The number of elements to hold in the array to be sorted.
    */
   func prepare(count: Int) {
      array.prepare(count: count)
   }

   /**
    Prepares the coordinator for sorting. Check that if not actually called, remove this.
    - parameter range: The range of numbers to populate the array with.
    */
   func prepare(range: ClosedRange<Int>) {
      array.prepare(range: range)
   }

   /**
    Executes the different sorting methods, using a repeating timer within a closure.
    
    See also `nextStep()` and `nextMethod()` as well as `stop()`, which all contribute to the state manamement of
    the coordinator.
    
    See the State enum values, coordinating the execution of the sorting in different phases.
    */
   func execute() {
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
            self.executing = true

         case .animating:
            // If nextStep returns true, array is sorted and it is time to switch to the next supported method, if any.
            if self.nextStep() {
               self.nextMethod()
            }

         case .measuring:
            // Measure the time performance of each of the methods, without animation and loops.
            // 1. Take timestamp
            let now = Date()
            // 2. Do sorting with real algo
            let success = self.currentMethod?.realAlgorithm(arrayCopy: self.array)
            if success! {
               // 3. Take timestamp
               // 4. Calculate duration
               let duration = Date().timeIntervalSince(now)
               // 5. Add to performanceTable
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

   /**
    Is the coordinator executing or not
    - returns: True if the coordinator is executing the sorting methods.
    */
   func isExecuting() -> Bool {
      return executing
   }

   /**
    Stops the execution of the sorthing methods and resets the sorting to the start state.
    */
   func stop() {
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
            self.execute()
         }

      case .measuring:
         self.state = .atEnd
         originalArray.prepare(range: -defaultMaxMinValueOfElements...defaultMaxMinValueOfElements)
         originalArray.shuffle()
         array = originalArray
         executing = false

      default:
         break
      }
   }

   /**
    Executes the next step of any sorting method when animating the methods.
    - returns: Returns true if the sort method finished sorting and the array is now sorted.
    */
   private func nextStep() -> Bool {
      var returnValue = false
      returnValue = currentMethod!.nextStep(array: array, swappedItems: &swappedItems)
      self.array.handleSortOperation(operation: swappedItems)
      return returnValue
   }

   private func nextMethod() {
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
            self.execute()
         }
      } else {
         stop()
      }
   }

}
