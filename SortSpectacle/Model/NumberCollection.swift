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
      for _ in 0...count {
         numbers.append(Int.random(in: numberRange))
      }
   }
   
   func numberCount() -> Int {
      numbers.count
   }
   
   func number(index : Int) -> Int {
      numbers[index]
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
   
}
