//
//  SortMethod.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

/**
 Structure defining the operation when sorting an Int array.
 There are two kinds of operations. You can either *swap* the values, indicated
 by the *indexes* first and second. Or you can *move* the *value* in *first* variable to the *index*
 specified by the second *index* value.
 */
struct SwappedItems {
   enum Operation {
      case swap
      case moveValue
   }
   var operation: Operation = .swap
   var first = -1
   var second = -1
}

/**
 A common protocol for all sorting methods.
 TODO: add a description property to show a longer description of the sort method in the UI.
 */
protocol SortMethod {

   init(arraySize: Int)

   var name: String { get }
   var description: String { get }

   func restart()
   func nextStep(array: [Int], swappedItems : inout SwappedItems) -> Bool
   func realAlgorithm(arrayCopy: [Int]) -> Bool
}

/**
 A base class for sort methods. Base class includes the common features all sorting methods use.
 Subclasses must call *init()*, *restart()* and *nextStep()* methods in their implementations first, then
 execute subclass specific code.
 */
class SortBase: SortMethod {

   /**
    Each sort method has a name, shown on the screen. Specify a name for a method, overriding this property.
    */
   var name: String {
      "Unnamed"
   }

   var description: String {
      "No description"
   }

   /// Size of the array
   var size: Int = 0
   /// Current inner loop index to the array, used by some sorting methods.
   var innerIndex: Int = 0
   /// Current outer loop index to the array, used by some sorting methods.
   var outerIndex: Int = 0

   /** Initializes the array with the specified size and resets the loop counters to zero.
    - parameter arraySize: The size of the array to sort.
   */
   required init(arraySize: Int) {
      size = arraySize
      restart()
   }

   /// Restarts the sort by setting the loop counters to zero.
   func restart() {
      innerIndex = 0
      outerIndex = 0
   }

   /**
    Base class version of the step of the sorting algorithm on the array. Subclasses must always first call the baseclass
    implementation and then execute their own step code.
    - parameter array: The array being sorted
    - parameter swappedItems: Contains the result of the sort step, which elements to swap in the array
    - returns: Returns true if items were swapped, base class returns false always.
    */
   @discardableResult func nextStep(array: [Int], swappedItems : inout SwappedItems) -> Bool {
      swappedItems.first = -1
      swappedItems.second = -1
      swappedItems.operation = .swap
      return false
   }

   /**
    Sorts the array with the same method as the steppable version but in a tight loop without stepping.
    This is to demonstrate the "real" speed of the sorting algorithm, compared to the others.
    Base class implementation just stores the size to a member variable, subclasses must implement the actual
    sorting algorithm.
    - parameter arrayCopy: The array that is to be sorted.
    - returns: Base class implementation always returns true.
    */
   func realAlgorithm(arrayCopy: [Int]) -> Bool {
      size = arrayCopy.count
      return true
   }

}
