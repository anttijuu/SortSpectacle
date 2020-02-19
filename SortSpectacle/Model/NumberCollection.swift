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
 
 A number collection has a certain *count* of numbers from a certain value *range*.
 For example, if the range is from -50...50 and count is 10, the collection has ten numbers having values
 between -50 to 50. To create such a NumberCollection would happen like this:
 ```
 var numbers = NumberCollection(range: -50...50)
 numbers.generateNumbers(count: 10)
 ```
 
 - Author:
   Antti Juustila
 - Version:
   0.1.0
 */
class NumberCollection : NSCopying {

   var numberRange = 0...50
   var numbers : [Int] = []
   
   /**
    Initializes the number collection to handle integer values between the range provided.
    - parameter range: The range of values the integers will have in the collection, from the range.
    */
   init(range : ClosedRange<Int>) {
      precondition(!range.isEmpty)
      numberRange = range
   }
   
   //MARK: NSCopying
   func copy(with zone: NSZone? = nil) -> Any {
      let prototype = NumberCollection(range: numberRange)
      prototype.numbers = numbers
      return prototype
   }
   
   /**
    Fills the collection with random integers from the range specified when the collection was initialized.
     - parameter count: The count of random numbers to add to the collection.
    */
   func generateNumbers(count : Int) -> Void {
      precondition(count > 1)
      numbers = []
      numbers.reserveCapacity(count)
      for _ in 0..<count {
         numbers.append(Int.random(in: numberRange))
      }
   }
   
   /**
    Empties the number container.
    */
   func clear() -> Void {
      numbers = []
   }
   
   /**
    Queries the count of numbers the container has.
    - returns: The number of integers in the container.
    */
   func count() -> Int {
      numbers.count
   }
   
   /**
    Query the value of a number in the specified location in the container.
     - parameter index: The location index of the number to query.
     - returns: The value of the number in the index.
    */
   func number(index : Int) -> Int {
      precondition(index >= 0 && index < count())
      return numbers[index]
   }
   
   /**
    Get the largest value stored in the collection.
    - returns: The largest number found, nil if collection is empty.
    */
   func max() -> Int? {
      if numbers.isEmpty {
         return nil
      }
      var largest = numberRange.min()!
      for number in numbers {
         if number > largest {
            largest = number
         }
      }
      return largest
   }

   /**
    Get the smallest value stored in the collection.
    - returns: The smallest number found, zero if collection is empty.
    */
   func min() -> Int? {
      if numbers.isEmpty {
         return nil
      }
      var smallest = numberRange.max()!
      for number in numbers {
         if number < smallest {
            smallest = number
         }
      }
      return smallest
   }

   /**
    Swaps the values in the specified indexes.
    - parameters:
       - index1 : The index of the first number to swap
       - index2 : The index of the second number to swap.
    */
   func swap(from index1 : Int, to index2 : Int) -> Void {
      precondition(index1 >= 0 && index1 < count() && index2 >= 0 && index2 < count() && index1 != index2)
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
