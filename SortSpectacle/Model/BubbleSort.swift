//
//  BubbleSort.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation
import Combine

class BubbleSort : SortMethod {   
   
   var innerIndex : Int
   var outerIndex : Int
   private var done : Bool
   private var swappedInInnerLoop : Bool
   
   func getName() -> String {
      return "BubbleSort"
   }
   
   required init() {
      innerIndex = 0;
      outerIndex = 0;
      done = false
      swappedInInnerLoop = false
   }
   
   func restart() -> Void {
      innerIndex = 0;
      outerIndex = 0;
      done = false
      swappedInInnerLoop = false
   }
      
   func nextStep(_ array : inout [Int]) -> Bool {
      let size = array.count
      if done {
         return true
      }
      //TODO: loop until you find something to swap, that is one step (I guess?)
      if array[innerIndex] > array[innerIndex+1] {
         //print(" >> [\(outerIndex),\(innerIndex)] Swapped \(array[innerIndex]) with \(array[innerIndex+1])")
         array.swapAt(innerIndex, innerIndex+1)
         swappedInInnerLoop = true
      }
      innerIndex += 1
      if innerIndex >= size-outerIndex-1 {
         innerIndex = 0
         outerIndex += 1
         if outerIndex >= size - 1 {
            done = true
            //print(array)
         }
      }
      return done
   }
   
}
