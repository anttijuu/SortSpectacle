//
//  NumberCollection.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 19.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

/**
 NumberCollection class is a wrapper around a collection of integers. It helps
 easy creation of number arrays for sorting them step by step, using different SortAlgorithms.
 */
class NumberCollection {

   var numberRange = 0...500
   var numbers : [Int] = []
   
   /**
    Initializes the number collection.
    - parameter range: The range of values the integers will have in the collection, from 0...range.
    */
   init(range : Int) {
      numberRange = 0...range
   }
   
   /**
    Fills the collection with numbers.
     - parameter count: The count of numbers the collection is filled using random numbers.
    */
   func generateNumbers(count : Int) -> Void {
      numbers = []
      numbers.reserveCapacity(count)
      for _ in 0..<count {
         numbers.append(Int.random(in: numberRange))
      }
   }
   
   /**
    Clears the number container.
    */
   func clear() -> Void {
      numbers = []
   }
   
   /**
    Use to query the count of numbers the container has.
    - returns: The number of integers in the container.
    */
   func count() -> Int {
      numbers.count
   }
   
   /**
    Use to query the value of a number in the container using index.
     - parameter index: The index of the number to query.
     - returns: The value of the number in the index.
    */
   func number(index : Int) -> Int {
      precondition(index >= 0 && index < count())
      return numbers[index]
   }
   
   /**
    Get the value of the number with maximum value among the collection.
    - returns: The number with the maximum value, zero if collection is empty.
    */
   func max() -> Int {
      var largest : Int = 0;
      for number in numbers {
         if number > largest {
            largest = number
         }
      }
      return largest
   }
   
   /**
    Swaps the values in the specified indexes.
    - parameter index1 : The index of the first number to swap
    - parameter index2 : The index of the second number to swap.
    */
   func swap(from index1 : Int, to index2 : Int) -> Void {
      precondition(index1 >= 0 && index1 < count() && index2 >= 0 && index2 < count())
      let temp = numbers[index1]
      numbers[index1] = numbers[index2]
      numbers[index2] = temp
   }
   
   /**
    Shuffles the values in the collection to a random order.
    */
   func shuffle() -> Void {
      numbers.shuffle()
   }
}
