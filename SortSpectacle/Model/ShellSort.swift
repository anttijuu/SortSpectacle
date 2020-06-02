//
//  ShellSort.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 18.3.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

class ShellSort: SortBase {

   private var gap = 0
   private var movableValue = 0

   private enum State {
      case inLevel2LoopStart
      case inLevel3Loop
      case inLevel2LoopEnd
      case gapUpdate
   }
   private var state: State = .inLevel2LoopStart

   override var name: String {
      "ShellSort"
   }

   override var description: String {
      """
      Shell sort is an in-place comparison sort. The method starts by sorting pairs of elements far apart from each other, then progressively reducing the gap between elements to be compared. Donald Shell published the first version of this sort in 1959.
      """
   }

   required init(arraySize: Int) {
      super.init(arraySize: arraySize)
   }

   override func restart() {
      super.restart()
      gap = size / 2
      outerIndex = gap
      innerIndex = outerIndex
      state = .inLevel2LoopStart
      movableValue = 0
   }

   override func nextStep(array: [Int], swappedItems : inout SwappedItems) -> Bool {
      super.nextStep(array: array, swappedItems: &swappedItems)

      if gap == 0 {
         return true
      }

      switch state {
      case .gapUpdate:
         gap /= 2
         if gap == 0 {
            return true
         }
         outerIndex = gap
         state = .inLevel2LoopStart

      case .inLevel2LoopStart:
         movableValue = array[outerIndex]
         innerIndex = outerIndex
         state = .inLevel3Loop

      case .inLevel3Loop:
         if innerIndex >= gap && array[innerIndex-gap] > movableValue {
            swappedItems.first = array[innerIndex-gap]
            swappedItems.second = innerIndex
            swappedItems.operation = .moveValue
            innerIndex -= gap
         } else {
            state = .inLevel2LoopEnd
         }

      case .inLevel2LoopEnd:
         swappedItems.first = movableValue
         swappedItems.second = innerIndex
         swappedItems.operation = .moveValue
         outerIndex += 1
         if outerIndex >= size {
            state = .gapUpdate
         } else {
            state = .inLevel2LoopStart
         }
      }
      return false
   }

   override func realAlgorithm(arrayCopy: [Int]) -> Bool {
      var array = arrayCopy
      var gap = array.count / 2
      repeat {
         for index2 in gap..<array.count {
            let temp = array[index2]
            var index3 = index2

            while index3 >= gap && array[index3-gap] > temp {
               array[index3] = array[index3-gap]
               index3 -= gap
            }
            array[index3] = temp
         }
         gap /= 2
      } while gap > 0
      return array.isSorted()
   }
}
