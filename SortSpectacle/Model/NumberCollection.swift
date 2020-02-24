//
//  NumberCollection.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 19.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

/**
 Declare an extension to Int array to be able to easily prepare an array either
 - with integers from a specified range and count of numbers, or
 - with sequence of integers from 1 to count of numbers.
 
 - Author:
   Antti Juustila
 - Version:
   0.2.0
 - Copyright:
   © 2020 Antti Juustila, all rights reserved.
 */
extension Array where Element == Int {
   
   /**
    Prepare an array with a count of random numbers from a specified range.
    - parameter range: The range of values the array is holding, e.g. -10..-10.
    - parameter count: The count of numbers to generate to the array, randomly.
    */
   mutating func prepare(range : ClosedRange<Int>, count : Int) {
      precondition(!range.isEmpty)
      removeAll()
      reserveCapacity(count)
      for _ in 0..<count {
         append(Int.random(in: range))
      }
   }
   
   /**
    Prepare an array from a specified range sequentially.
    - parameter range: The range of values the array is holding, e.g. -10..-10.
    */
   mutating func prepare(range : ClosedRange<Int>) {
      precondition(!range.isEmpty)
      removeAll()
      reserveCapacity(range.count)
      for number in range {
         append(number)
      }
   }
   
   /**
    Prepare an array of numbers from 1 to `count` sequentially.
    - parameter count: The count of numbers to generate.
    */
   mutating func prepare(count : Int) {
      removeAll()
      reserveCapacity(count)
      for number in 1...count {
         append(number)
      }
   }
   
}
