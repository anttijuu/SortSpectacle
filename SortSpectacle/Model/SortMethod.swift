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
   var operation : Operation = .swap
   var first = -1
   var second = -1
}

/**
 A common protocol for all sorting methods.
 TODO: Interface also includes a method for the "original" algorithm to implement for perf tests/comparisons.
 */
protocol SortMethod {
   
   init(arraySize : Int)

   var name : String { get }

   func restart() -> Void
   func nextStep(array: [Int], swappedItems : inout SwappedItems) -> Bool
   func realAlgorithm(arrayCopy : [Int]) -> Bool
}

/**
 A base class for sort methods. Base class includes the common features all sorting methods use.
 Subclasses must call *init()*, *restart()* and *nextStep()* methods in their implementations first, then
 execute subclass specific code.
 */
class SortBase : SortMethod {
   
   /**
    Each sort method has a name, shown on the screen. Specify a name for a method, overriding this property.
    */
   var name: String {
      get {
         "Unnamed"
      }
   }
   
   var size : Int = 0
   var innerIndex : Int = 0
   var outerIndex : Int = 0

   required init(arraySize : Int) {
      size = arraySize
      restart()
   }
   
   func restart() -> Void {
      innerIndex = 0;
      outerIndex = 0;
   }
   
   @discardableResult func nextStep(array: [Int], swappedItems : inout SwappedItems) -> Bool {
      swappedItems.first = -1
      swappedItems.second = -1
      swappedItems.operation = .swap
      return false
   }
   
   func testArrayOrder(array : [Int]) -> Bool {
      var index = 0
      for number in array {
         if index < array.count - 1 {
            if number >= array[index+1] {
               return false
            }
         }
         index += 1
      }
      return true
   }
   
   func realAlgorithm(arrayCopy : [Int]) -> Bool {
      size = arrayCopy.count
      return true
   }
   
}
