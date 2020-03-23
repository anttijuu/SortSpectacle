//
//  BubbleSort.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

class BubbleSort : SortBase {
   
   private var done : Bool = false
   private var swappedInInnerLoop : Bool = false

   override var name : String {
      get {
         "BubbleSort"
      }
   }
   
   required init(arraySize : Int) {
      super.init(arraySize: arraySize)
   }
   
   override func restart() -> Void {
      super.restart()
      done = size < 2 ? true : false
      swappedInInnerLoop = false
   }
      
   override func nextStep(array: [Int], swappedItems : inout SwappedItems) -> Bool {
      super.nextStep(array: array, swappedItems: &swappedItems)
      
      if done {
         return true
      }
      if array[innerIndex] > array[innerIndex+1] {
         swappedItems.first = innerIndex
         swappedItems.second = innerIndex+1
         swappedInInnerLoop = true
      }
      innerIndex += 1
      if innerIndex >= size-outerIndex-1 {
         innerIndex = 0
         outerIndex += 1
         if outerIndex >= size - 1 {
            done = true
         }
      }
      return done
   }
 
   override func realAlgorithm(arrayCopy : [Int]) -> Bool {
      if !super.realAlgorithm(arrayCopy: arrayCopy) {
         return false
      }
      var array = arrayCopy
      repeat {
         var newSize = 0
         for index in 1...size-1 {
            if array[index-1] > array[index] {
               array.swapAt(index-1, index)
               newSize = index
            }
         }
         size = newSize
      } while size > 1
      /*
       procedure bubbleSort(A : list of sortable items)
          n := length(A)
          repeat
             newn := 0
             for i := 1 to n - 1 inclusive do
                if A[i - 1] > A[i] then
                   swap(A[i - 1], A[i])
                   newn := i
                end if
             end for
             n := newn
          until n ≤ 1
       end procedure
       */
      return testArrayOrder(array: array)
   }
}
