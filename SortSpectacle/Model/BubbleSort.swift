//
//  BubbleSort.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

/**
 Implementation of the Bubble sort algorithm.
 
 Bubble sort performs poorly in real world use and is used primarily as an educational tool. Note that using very large
 arrays slows down the sorting using BubbleSort considerably.
 
 See https://en.wikipedia.org/wiki/Bubble_sort
 */
struct BubbleSort: SortMethod {

   /// Name of the BubbleSort is "BubbleSort".
   var name: String {
      "BubbleSort"
   }

   /// A short description of the Bubblesort.
   var description: String {
      """
      Bubble sort is a simple sorting algorithm that repeatedly steps through the list, compares adjacent elements and swaps them if they are in the wrong order.
      The pass through the list is repeated until the list is sorted. Bubble sort performs poorly in real world use and is used primarily as an educational tool.
      Do not use large arrays (>1000) elements unless you have time to wait and see how the sorting goes.
      """
   }

   /// Implements the size property declared in the `SortMethod` protocol. This is the size of the array to sort.
   let size: Int

   /// A varible to address the sortable (not yet sorted) size of the array.
   private var sortSize: Int = 0

   /// A variable to keep track where sorting has advanced to.
   private var newSize: Int = 0

   /// Loop index variable for sorting the array.
   private var innerIndex: Int = 1

   /// Initializes the BubbleSort by calling base class implementation. Nothing else is needed here.
   init(arraySize: Int) {
      size = arraySize
      sortSize = size
   }

   /// Restarts the bubble sort, calls super.restart() and resets the inner index. Note that array is not modified, caller must do that if necessary.
   mutating func restart() {
      innerIndex = 1
      sortSize = size
   }

   /** Implements the SortMethod protocol and overrides the base class implementation.
    Note that the algorithm modifies the array size member variable, and that will eventually
    cause the method returning true. Until that, false is always returned at the end of the method.
    See base class and protocol documentation for details of the method.
    */
   mutating func nextStep(array: [Int], swappedItems : inout SwappedItems) -> Bool {
      if sortSize <= 1 {
         return true
      }

      if array[innerIndex-1] > array[innerIndex] {
         swappedItems.first = innerIndex-1
         swappedItems.second = innerIndex
         newSize = innerIndex
      }
      if innerIndex >= sortSize - 1 {
         sortSize = newSize
         innerIndex = 1
         newSize = 0
      } else {
         innerIndex += 1
      }
      return false
   }

   /**
    Implementation of the BubbleSort in two tight loops.
    */
   mutating func realAlgorithm(arrayCopy: [Int]) -> Bool {
      var array = arrayCopy
      sortSize = array.count
      repeat {
         newSize = 0
         for index in 1...sortSize-1 where array[index-1] > array[index] {
            array.swapAt(index-1, index)
            newSize = index
         }
         sortSize = newSize
      } while sortSize > 1
      return array.isSorted()
   }
}
