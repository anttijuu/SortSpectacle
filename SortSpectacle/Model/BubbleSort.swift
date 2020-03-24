//
//  BubbleSort.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

class BubbleSort : SortBase {
   
   private var newSize : Int = 0
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
      swappedInInnerLoop = false
      innerIndex = 1
   }
      
   override func nextStep(array: [Int], swappedItems : inout SwappedItems) -> Bool {
      super.nextStep(array: array, swappedItems: &swappedItems)
      
      if size <= 1 {
         return true
      }
      if array[innerIndex-1] > array[innerIndex] {
         swappedItems.first = innerIndex-1
         swappedItems.second = innerIndex
         swappedInInnerLoop = true
         newSize = innerIndex
      }
      if innerIndex >= size-1 {

         swappedInInnerLoop = false

         size = newSize
         innerIndex = 1
         newSize = 0
      } else {
         innerIndex += 1
      }
      return false
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
