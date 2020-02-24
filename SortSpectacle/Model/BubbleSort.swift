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
   var array : [Int]
   private let size : Int
   private var done : Bool
   private var swappedInInnerLoop : Bool
   
   func getName() -> String {
      return "BubbleSort"
   }
   
   required init(array : inout [Int]) {
      self.array = array
      innerIndex = 0;
      outerIndex = 0;
      size = array.count
      done = false
      swappedInInnerLoop = false
      self.array.shuffle()
   }
      
   func nextStep() -> Bool {
      if done {
         return true
      }
      /*
       bool swapped;
        for (i = 0; i < n-1; i++)
        {
          swapped = false;
          for (j = 0; j < n-i-1; j++)
          {
             if (arr[j] > arr[j+1])
             {
                swap(&arr[j], &arr[j+1]);
                swapped = true;
             }
          }
       
          // IF no two elements were swapped by inner loop, then break
          if (swapped == false)
             break;
        }
       */
      //TODO: loop until you find something to swap, that is one step (I guess?)
      if array[innerIndex] > array[innerIndex+1] {
         print(" >> [\(outerIndex),\(innerIndex)] Swapped \(array[innerIndex]) with \(array[innerIndex+1])")
         array.swapAt(innerIndex, innerIndex+1)
         swappedInInnerLoop = true
      }
      innerIndex += 1
      if innerIndex >= size-outerIndex-1 {
         innerIndex = 0
         outerIndex += 1
         if outerIndex >= size - 1 {
            done = true
            print(array)
         }
      }
      return done
   }
   
   func getArray() -> [Int] {
      return array
   }
   
}
