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
 */
protocol SortMethod {
   
   init(arraySize : Int)

   var name : String { get }

   func restart() -> Void
   func nextStep(array: [Int], swappedItems : inout SwappedItems) -> Bool
   
}
