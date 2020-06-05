//
//  SortMethod.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

let debug = false

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

   /// The size of the array to sort.
   var size: Int { get }

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
   mutating func restart()

   /**
    Does the next step in the sort, moving or switching two values in the array.
    Caller will do the actual swapping of values in the array.
    
    This method is called repeatedly until it returns true. After each step, the UI is updated to
    visualize the process of sorting.
    
    Note that caller should have swappedItems as a local variable *within* a loop so that it is resetted before each
    call to nextStep.
    
    - parameter array: The array containing the elements to sort.
    - parameter swappedItems: The two items to swap or move, if any. Method sets the values and caller does the moving.
    - returns: Returns true if the array is sorted. Caller should stop sorting (calling nextStep).
    */
   mutating func nextStep(array: [Int], swappedItems : inout SwappedItems) -> Bool

   /**
    Implementation of the sorting method without any steps, sorting the data in one go in a loop/loops.
    Usually the implementations copy the array to a temporary and sort that, since the caller does not
    have to have the sorted array.
    - parameter arrayCopy: The array to sort.
    - returns: Returns true if the array was successfully sorted.
    */
   mutating func realAlgorithm(arrayCopy: [Int]) -> Bool
}
