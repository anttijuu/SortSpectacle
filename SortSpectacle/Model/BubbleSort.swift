//
//  BubbleSort.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

class BubbleSort : SortMethod {
  
   private var innerIndex : Int
   private var outerIndex : Int
   private let size : Int
   private var array : [Int]!
   private var done : Bool
   private var swappedInInnerLoop : Bool
   private var timer : Timer?
   
   required init(array : inout [Int]) {
      self.array = array
      size = array.count
      innerIndex = 0;
      outerIndex = 0;
      done = false
      swappedInInnerLoop = false
   }
   
   func start() -> Void {
      timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
   }

   func stop() -> Void {
      if let clock = timer {
         clock.invalidate()
      }
   }
   
   @objc func fireTimer() {
       print("Timer fired!")
       if nextStep() {
          timer!.invalidate()
       }
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
      if array[innerIndex] > array[innerIndex+1] {
         array.swapAt(innerIndex, innerIndex+1)
         swappedInInnerLoop = true
      }
      innerIndex += 1
      if innerIndex >= size-outerIndex-1 {
         innerIndex = 0
         swappedInInnerLoop = false
         outerIndex += 1
         if outerIndex >= size - 1 || !swappedInInnerLoop {
            done = true
         }
      }
      return done
   }
   
   
}
