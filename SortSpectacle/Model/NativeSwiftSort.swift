//
//  NativeSwiftSort.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 7.6.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

struct NativeSwiftSort: SortMethod {
      
   init(arraySize: Int) {
      size = arraySize
   }
   
   let size: Int
   
   var name: String {
      "Native Swift sort"
   }
   
   var description: String {
      """
      The sorting method implemented in Swift. This is Timsort.
      """
   }
   
   mutating func restart() {
      // Nada
   }
   
   mutating func nextStep(array: [Int], swappedItems: inout SwappedItems) -> Bool {
      return true
   }
   
   mutating func realAlgorithm(arrayCopy: [Int]) -> Bool {
      var array = arrayCopy
      array.sort()
      return true
   }

}
