//
//  BubbleSort.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

class BubbleSort : SortMethod {   
   
   let size : Int
   var innerIndex : Int = 0
   var outerIndex : Int = 0
   private var done : Bool = false
   private var swappedInInnerLoop : Bool = false

   var name : String {
      get {
         "BubbleSort"
      }
   }
   
   required init(arraySize : Int) {
      size = arraySize
      self.restart()
   }
   
   func restart() -> Void {
      innerIndex = 0;
      outerIndex = 0;
      done = size < 2 ? true : false
      swappedInInnerLoop = false
   }
      
   func nextStep(array: [Int], swappedItems : inout SwappedItems) -> Bool {
      if done {
         return true
      }
      swappedItems.first = -1
      swappedItems.second = -1
      //TODO: loop until you find something to swap, that is one step (I guess?)
      if array[innerIndex] > array[innerIndex+1] {
         swappedItems.first = innerIndex
         swappedItems.second = innerIndex+1
         // array.swapAt(innerIndex, innerIndex+1)
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
