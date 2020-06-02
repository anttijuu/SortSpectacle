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
 
 Bubble sort performs poorly in real world use and is used primarily as an educational tool. Note that using very large arrays slows down the sorting using BubbleSort considerably.
 
 See https://en.wikipedia.org/wiki/Bubble_sort
 */
class BubbleSort: SortBase {

   /// A variable to keep track where sorting has advanced to.
   private var newSize: Int = 0

   /// Name of the BubbleSort is "BubbleSort".
   override var name: String {
      "BubbleSort"
   }

   /// A short description of the Bubblesort.
   override var description: String {
      """
      Bubble sort is a simple sorting algorithm that repeatedly steps through the list, compares adjacent elements and swaps them if they are in the wrong order. The pass through the list is repeated until the list is sorted. Bubble sort performs poorly in real world use and is used primarily as an educational tool. Do not use large arrays (>1000) elements unless you have time to wait and see how the sorting goes.
      """
   }

   /// Initializes the BubbleSort by calling base class implementation. Nothing else is needed here.
   required init(arraySize: Int) {
      super.init(arraySize: arraySize)
   }

   /// Restarts the bubble sort, calls super.restart() and resets the inner index.
   override func restart() {
      super.restart()
      innerIndex = 1
   }

   /** Implements the SortMethod protocol and overrides the base class implementation.
    Note that the algorithm modifies the array size member variable, and that will eventually
    cause the method returning true. Until that, false is always returned at the end of the method.
    See base class and protocol documentation for details of the method.
    */
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

   /**
    Implementation of the BubbleSort in two tight loops.
    */
   override func realAlgorithm(arrayCopy: [Int]) -> Bool {
      if !super.realAlgorithm(arrayCopy: arrayCopy) {
         return false
      }
      var array = arrayCopy
      repeat {
         var newSize = 0
         for index in 1...size-1 where array[index-1] > array[index] {
            array.swapAt(index-1, index)
            newSize = index
         }
         size = newSize
      } while size > 1
      return array.isSorted()
   }
}
