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
   
}
