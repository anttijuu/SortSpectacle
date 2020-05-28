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

   override var name : String {
      get {
         "BubbleSort"
      }
   }
   
   override var description: String {
      get {
         """
         Bubble sort is a simple sorting algorithm that repeatedly steps through the list, compares adjacent elements and swaps them if they are in the wrong order. The pass through the list is repeated until the list is sorted. Bubble sort performs poorly in real world use and is used primarily as an educational tool.
         """
      }
   }
   
   required init(arraySize : Int) {
      super.init(arraySize: arraySize)
   }
   
   override func restart() -> Void {
      super.restart()
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
         newSize = innerIndex
      }
      if innerIndex >= size-1 {
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
      return array.isSorted()
   }
}
