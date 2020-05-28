//
//  QuickSortIterative.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 26.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

class LampSort : SortBase {
   
   var lows = Stack<Int>()
   var highs = Stack<Int>()

   var low : Int = 0
   var high : Int = 0
   var span : Int = 0
   var innerForLoopIndex = -1
   var pivotIndex = -1
   var pivot = 0
   
   enum State {
      case outerLoopFirstPart
      case innerForLoop
      case outerLoopSecondPart
      case finished
   }
   var state = State.outerLoopFirstPart
   
   var inRepeatLoop = true
   var inInnerLoop = false

   override var name : String {
      get {
         "LampSort"
      }
   }
   
   
   override var description: String {
      get {
         """
          Quick sort is a recursive sorting algorithm. The recursion is not fundamental to the algorithm. Lamp sort is an implementation of Quick sort without recursion.
         """
      }
   }
   
   required init(arraySize: Int) {
      super.init(arraySize: arraySize)
   }
   
   override func restart() {
      super.restart()
      while !lows.isEmpty {
         _ = lows.pop()
      }
      while !highs.isEmpty {
         _ = highs.pop()
      }
      low = 0
      high = 0
      span = 0
      innerForLoopIndex = -1
      pivotIndex = -1
      inRepeatLoop = true
      lows.push(0)
      highs.push(size-1)
      state = .outerLoopFirstPart
   }
   
   override func nextStep(array : [Int], swappedItems: inout SwappedItems) -> Bool {
      super.nextStep(array: array, swappedItems: &swappedItems)

      if size < 2 || (state == .outerLoopFirstPart && lows.isEmpty) {
         state = .finished
         return true
      }

      switch state {
         case .outerLoopFirstPart:
            low = lows.pop()!
            high = highs.pop()!
            
            span = high - low

            precondition((low >= 0) && (low < size));
            precondition((high >= 0) && (high < size));
            precondition(low <= high);

            if span >= 2 {
               pivotIndex = low;
               pivot = array[high];
               innerForLoopIndex = low
               state = .innerForLoop
            } else if span == 1 {
               if low != high && array[low] > array[high] {
                  swappedItems.first = low
                  swappedItems.second = high
               }
            }

         case .innerForLoop:
            if array[innerForLoopIndex] < pivot {
               if pivotIndex != innerForLoopIndex {
                  swappedItems.first = pivotIndex
                  swappedItems.second = innerForLoopIndex
               }
               pivotIndex += 1;
            }
            innerForLoopIndex += 1
            if innerForLoopIndex == high {
               state = .outerLoopSecondPart
            }
         
         case .outerLoopSecondPart:
            swappedItems.first = pivotIndex
            swappedItems.second = high
            
            // Create the next two intervals.
            lows.push(low)
            highs.push(max(low, pivotIndex - 1))
            lows.push(min(pivotIndex + 1, high))
            highs.push(high)
            state = .outerLoopFirstPart
         
         case .finished:
            return true
      }
      
      return false
   }
   
   
   override func realAlgorithm(arrayCopy : [Int]) -> Bool {
      var array = arrayCopy
      var low : Int
      var high : Int
      var span : Int
      let size = array.count
      
      if size < 2 { return true }
      
      lows.push(0)
      highs.push(size-1)

      var swappedItems = SwappedItems(first: -1, second: -1)
      
      repeat {
         low = lows.pop()!
         high = highs.pop()!
         
         span = high - low
         
         assert ((low >= 0) && (low < size));
         assert ((high >= 0) && (high < size));
         assert (low <= high);
         
         if span >= 2 {
            pivotIndex = low;
            let pivot = array[high];
            
            for index in low..<high {
               if array[index] < pivot {
                  if pivotIndex != index {
                     swappedItems.first = pivotIndex
                     swappedItems.second = index
                     array.swapAt(swappedItems.first, swappedItems.second)
                  }
                  pivotIndex += 1;
               }
            }
            
            // Swap the pivot at hi in at the right index.
            if pivotIndex != high {
               swappedItems.first = pivotIndex
               swappedItems.second = high
               array.swapAt(swappedItems.first, swappedItems.second)
            }
            // Create the next two intervals.
            lows.push(low)
            highs.push(max(low, pivotIndex - 1))
            lows.push(min(pivotIndex + 1, high))
            highs.push(high)
            
         } else if span == 1 {
            if low != high && array[low] > array[high] {
               swappedItems.first = low
               swappedItems.second = high
               array.swapAt(swappedItems.first, swappedItems.second)
            }
         }
      } while !lows.isEmpty
      return array.isSorted()
   }
   
}
