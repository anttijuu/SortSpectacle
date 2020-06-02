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
 by the indexes *first* and *second*. Or you can *move* the *value* in *first* variable to the *index*
 specified by the *second* index value.
 */
struct SwappedItems {
   /// The swap operations
   enum Operation {
      /// Swap the values of first and second indexes in the array.
      case swap
      /// Move the *value* in the *first* to the place indicated by the *second* *index*.
      case moveValue
   }
   /// The operation to perform, default is swap.
   var operation: Operation = .swap
   /// The index to swap or move values from. Value less than zero means that no move should be performed.
   var first = -1
   /// The index to swap or move values to. Value less than zero means that no move should be performed.
   var second = -1
}

/**
 A common protocol for all sorting methods.
 
 Note that the array to be sorted is hosted in an external object, and provided
 to the sorting methods as a parameter to the `nextStep()` method.
 
 The protocol is implemented by the `SortBase`, which provides common functionality for further
 sorting methods. Implementations of SortMethod do not have to inherit from SortBase.
 */
protocol SortMethod {

   /**
    Initializes the sortmethod to sort an array with specific number of elements.
    - parameter arraySize: The size of the array to initialize.
    */
   init(arraySize: Int)

   /**
    The name of the sorting method. Should return a short descriptive name, like "BubbleSort".
    */
   var name: String { get }

   /**
    A 2-3 sentence description of the sorting method.
    */
   var description: String { get }

   /**
    Restarts the sorting by resetting all loop counters, etc.
    */
   func restart()

   /**
    Does the next step in the sort, moving or switching two values in the array.
    Caller will do the actual swapping of values in the array.
    
    This method is called repeatedly until it returns true. After each step, the UI is updated to
    visualize the process of sorting.
    - parameter array: The array containing the elements to sort.
    - parameter swappedItems: The two items to swap or move, if any. Method sets the values and caller does the moving.
    - returns: Returns true if the array is sorted. Caller should stop sorting (calling nextStep).
    */
   func nextStep(array: [Int], swappedItems : inout SwappedItems) -> Bool

   /**
    Implementation of the sorting method without any steps, sorting the data in one go in a loop/loops.
    Usually the implementations copy the array to a temporary and sort that, since the caller does not
    have to have the sorted array.
    - parameter arrayCopy: The array to sort.
    - returns: Returns true if the array was successfully sorted.
    */
   func realAlgorithm(arrayCopy: [Int]) -> Bool
}

/**
 A helper base class for sort methods. Base class includes the common features (nearly) all sorting methods use.
 Subclasses must override these methods and then call `init()`, `restart()` and `nextStep()` methods in their
 implementations first, then execute subclass specific code.
 
 If the base class is not needed or conflicts with your sort method implementation, just implement your method on the `SortMethod` protocol. The `SortCoordinator` instantiates the methods on an array of SortMethods so inheriting from SortBase is not compulsory.
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
    Base class version of the step of the sorting algorithm on the array. Subclasses must always first call the baseclass implementation and then execute their own step code.
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
