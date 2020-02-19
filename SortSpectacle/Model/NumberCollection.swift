//
//  NumberCollection.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 19.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation


class NumberCollection {

   var numberRange = 0...500
   var numbers : [Int] = []
   
   init(range : Int) {
      numberRange = 0...range
   }
   
   func generateNumbers(count : Int) -> Void {
      numbers = []
      numbers.reserveCapacity(count)
      for _ in 0..<count {
         numbers.append(Int.random(in: numberRange))
      }
   }
   
   func clear() -> Void {
      numbers = []
   }
   
   func count() -> Int {
      numbers.count
   }
   
   func number(index : Int) -> Int {
      precondition(index >= 0 && index < count())
      return numbers[index]
   }
   
   func max() -> Int {
      var largest : Int = 0;
      for number in numbers {
         if number > largest {
            largest = number
         }
      }
      return largest
   }
   
   func swap(from index1 : Int, to index2 : Int) -> Void {
      precondition(index1 >= 0 && index1 < count() && index2 >= 0 && index2 < count())
      let temp = numbers[index1]
      numbers[index1] = numbers[index2]
      numbers[index2] = temp
   }
   
   func shuffle() -> Void {
      numbers.shuffle()
   }
}
