//
//  SortMethod.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

struct SwappedItems {
   var first = -1
   var second = -1
}

/**
 A common protocol for all sorting methods.
 TODO: Prepare a base class with skeleton implementation of init, restart and nextStep.
 TODO: Interface also includes a method for the "original" algorithm to implement for perf tests/comparisons.
 */
protocol SortMethod {
   
   init(arraySize : Int)

   var name : String { get }

   func restart() -> Void
   func nextStep(array: [Int], swappedItems : inout SwappedItems) -> Bool
   
}
