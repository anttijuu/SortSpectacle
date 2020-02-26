//
//  QuickSortIterative.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 26.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

class LampSort : SortMethod {
   
   let size : Int
   var innerIndex = 0
   var outerIndex = 0
   var done = false
   
   var lows = Stack<Int>()
   var highs = Stack<Int>()

   var low : Int = 0
   var high : Int = 0
   var span : Int = 0
   var innerForLoopIndex = -1
   var pivotIndex = -1
   var pivot = 0
   
   enum State {
      case repeatFirstPart
      case innerForLoop
      case repeatSecondPart
      case spanIsOne
      case finished
   }
   var state = State.repeatFirstPart
   
   var inRepeatLoop = true
   var inInnerLoop = false

   var name : String {
      get {
         "LampSort"
      }
   }
   
   
   required init(arraySize: Int) {
      size = arraySize
      self.restart()
   }
   
   func restart() {
      innerIndex = 0;
      outerIndex = 0;
      done = false
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
      state = .repeatFirstPart
   }
   
   func nextStep(array : [Int], swappedItems: inout SwappedItems) -> Bool {
      
      if state == .repeatFirstPart && lows.isEmpty {
         state = .finished
         return true
      }
      
      switch state {
         case .repeatFirstPart:
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
               state = .spanIsOne
            }

         case .innerForLoop:
            if array[innerForLoopIndex] < pivot {
               swappedItems.first = pivotIndex
               swappedItems.second = innerForLoopIndex
               pivotIndex += 1;
            }
            innerForLoopIndex += 1
            if innerForLoopIndex == high {
               state = .repeatSecondPart
            }
         
         case .repeatSecondPart:
            swappedItems.first = pivotIndex
            swappedItems.second = high
            
            // Create the next two intervals.
            lows.push(low)
            highs.push(max(low, pivotIndex - 1))
            lows.push(min(pivotIndex + 1, high))
            highs.push(high)
            state = .repeatFirstPart
         
         case .spanIsOne:
            if array[low] > array[high] {
               swappedItems.first = low
               swappedItems.second = high
            }
            state = .repeatFirstPart
         
         case .finished:
            return true
      }
      
      return false
   }
   
   
   func realAlgorithm(arrayCopy : [Int], swappedItems : inout SwappedItems) -> Bool {
      var array = arrayCopy
      var low : Int
      var high : Int
      var span : Int
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
                  swappedItems.first = pivotIndex
                  swappedItems.second = index
                  array.swapAt(swappedItems.first, swappedItems.second)
                  pivotIndex += 1;
               }
            }
            
            // Swap the pivot at hi in at the right index.
            swappedItems.first = pivotIndex
            swappedItems.second = high
            array.swapAt(swappedItems.first, swappedItems.second)
            // Create the next two intervals.
            lows.push(low)
            highs.push(max(low, pivotIndex - 1))
            lows.push(min(pivotIndex + 1, high))
            highs.push(high)
            
         } else if span == 1 {
            if array[low] > array[high] {
               swappedItems.first = low
               swappedItems.second = high
               array.swapAt(swappedItems.first, swappedItems.second)
            }
         }
         
      } while !lows.isEmpty
      print(array)
      return true
   }
   
}
