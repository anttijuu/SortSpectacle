//
//  RadixSort.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 25.9.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

/**
 Radix sort is a non-comparative sorting algorithm. It avoids comparison by creating and distributing elements into buckets according to their radix.

 For elements with more than one significant digit, this bucketing process is repeated for each digit, while preserving the ordering of the prior step, until all digits have been considered.

 For this reason, radix sort has also been called bucket sort and digital sort.

 This method implements the LSD algorithm (Least Significant Digit). Implementation has places for optimization, exercise left for the reader.

 The algorithm is a port from a python code from Stackoverflow. See comment on realAlgorithm() for details.
 */
struct RadixSort: SortMethod {
   
   private var groups: [[Int]] = [[Int]]()
   private let numRadix: Int = 8
   private var radixCounter: Int = 0
   private var shift: Int = 0
   private var outerLoopCounter: Int = 0
   private var groupCounter: Int = 0
   private var groupArrayCounter: Int = 0
   private var arrayPos: Int = 0
   private var radixGroupSplittingCounter: Int = 0

   /**
    The states of the algorithm. Basically, as with other methods, the realAlgorigthm was sliced
    into pieces where no loops exist within nextStep. Well, in this case, one loop creating an
    array needed for the algo is, but the rest is not.
    */
   private enum State {
      case outerLoopReset
      case creatingRadixGroupsEnd
      case creatingRadixGroupsLoop
      case handlingRadixFrom0to6
      case handlingRadix7BeginningPart
      case handlingRadix7EndPart
      case increasingShift
      case finished
   }
   
   private var state: State = .outerLoopReset
   
   init(arraySize: Int) {
      size = arraySize
      if size < 2 {
         state = .finished
      }
      restart()
   }
   
   let size: Int
   
   var name: String {
      "RadixSort"
   }
   
   var description: String {
      """
      Radix sort is a non-comparative sorting algorithm. It avoids comparison by creating and distributing elements into buckets according to their radix.

      For elements with more than one significant digit, this bucketing process is repeated for each digit, while preserving the ordering of the prior step, until all digits have been considered.

      For this reason, radix sort has also been called bucket sort and digital sort.

      This method implements the LSD algorithm (Least Significant Digit). Implementation has places for optimization, exercise left for the reader.
      """
   }
   
   var webLinks: [(String, String)] {
      [("Wikipedia on Radix sort", "https://en.wikipedia.org/wiki/Radix_sort"),
      ("Stackoverflow discussion", "https://stackoverflow.com/questions/15306665/radix-sort-for-negative-integers")]
   }
   
   mutating func restart() {
      state = .outerLoopReset
      shift = 0
      outerLoopCounter = 0
      groupCounter = 0
      radixCounter = 0
      groupArrayCounter = 0
      radixGroupSplittingCounter = 0
   }
   
   //swiftlint:disable cyclomatic_complexity function_body_length
   mutating func nextStep(array: [Int], swappedItems: inout SwappedItems) -> Bool {
      switch state {
      case .outerLoopReset:
         // Added quick fix. Algo should somehow handle already sorted array, currently does not.
         if array.isSorted() {
            return true
         }
         if debug { print("case .outerLoopReset") }
         groups.removeAll()
         for _ in 0..<256 {
            groups.append([Int]())
         }
         state = .creatingRadixGroupsLoop
         radixGroupSplittingCounter = 0

      case .creatingRadixGroupsLoop:
         // Splitting items into radix groups
         if debug && radixGroupSplittingCounter == 0 { print("case .creatingRadixGroupsLoop") }
         if radixGroupSplittingCounter < size {
            let number = array[radixGroupSplittingCounter]
            groups[(number >> shift & 0xFF)].append(number)
            radixGroupSplittingCounter += 1
            swappedItems.currentIndex1 = radixGroupSplittingCounter
         } else {
            state = .creatingRadixGroupsEnd
         }

      case .creatingRadixGroupsEnd:
         if debug { print("case .creatingRadixGroupsEnd") }
         arrayPos = 0
         if radixCounter <= 6 {
            state = .handlingRadixFrom0to6
         } else {
            state = .handlingRadix7EndPart
            groupCounter = 128
         }

      case .handlingRadixFrom0to6:
         if debug && groupArrayCounter == 0 { print("case .handlingRadixFrom0to6") }
         if groupArrayCounter < groups[groupCounter].count {
            swappedItems.operation = .moveValue
            swappedItems.first = groups[groupCounter][groupArrayCounter]
            swappedItems.second = arrayPos
            swappedItems.currentIndex1 = swappedItems.first
            swappedItems.currentIndex2 = swappedItems.second
            arrayPos += 1
         }
         groupArrayCounter += 1
         if groupArrayCounter >= groups[groupCounter].count {
            groupArrayCounter = 0
            groupCounter += 1
            if groupCounter >= groups.count {
               groupCounter = 0
               state = .increasingShift
            }
         }

      case .handlingRadix7EndPart:
         if debug && groupArrayCounter == 0 { print("case .handlingRadix7EndPart") }
         if groupArrayCounter < groups[groupCounter].count {
            swappedItems.operation = .moveValue
            swappedItems.first = groups[groupCounter][groupArrayCounter]
            swappedItems.second = arrayPos
            swappedItems.currentIndex1 = swappedItems.first
            swappedItems.currentIndex2 = swappedItems.second
            arrayPos += 1
         }
         groupArrayCounter += 1
         if groupArrayCounter >= groups[groupCounter].count {
            groupArrayCounter = 0
            groupCounter += 1
            if groupCounter >= 256 {
               groupCounter = 0
               state = .handlingRadix7BeginningPart
            }
         }
         
      case .handlingRadix7BeginningPart:
         if debug && groupArrayCounter == 0 { print("case .handlingRadix7BeginningPart") }
         if groupArrayCounter < groups[groupCounter].count {
            swappedItems.operation = .moveValue
            swappedItems.first = groups[groupCounter][groupArrayCounter]
            swappedItems.second = arrayPos
            swappedItems.currentIndex1 = swappedItems.first
            swappedItems.currentIndex2 = swappedItems.second
            arrayPos += 1
         }
         groupArrayCounter += 1
         if groupArrayCounter >= groups[groupCounter].count {
            groupArrayCounter = 0
            groupCounter += 1
            if groupCounter >= 128 {
               groupCounter = 0
               state = .increasingShift
            }
         }
         
      case .increasingShift:
         if debug { print("case .increasingShift shift: \(shift) radixCounter: \(radixCounter)") }
         shift += 8
         radixCounter += 1
         if radixCounter < numRadix {
            state = .outerLoopReset
         } else {
            state = .finished
         }
         
      case .finished:
         return true
      }
      return false
   }

   /**
    Sorts a copy of the array in the paramenter using the sorting method in one go.
    Implementation is based on Python code by Alexander Shostak's comment from https://stackoverflow.com/questions/15306665/radix-sort-for-negative-integers discussion.
    - parameter arrayCopy The array to copy and sort.
    - returns Returns true if the array is sorted.
    */
   mutating func realAlgorithm(arrayCopy: [Int]) -> Bool {
      var arrayToSort = arrayCopy
      restart()
      let size = arrayToSort.count
      
      for tempCounter in 0..<numRadix {
         // Cleaning groups
         groups.removeAll()
         for _ in 0..<256 {
            groups.append([Int]())
         }
         
         // Splitting items into radix groups
         for splittingCounter in 0..<size {
            let number = arrayToSort[splittingCounter]
            groups[(number >> shift & 0xFF)].append(number)
         }
    
         // Copying sorted by radix items back into original array
         var tempArrayPos = 0
         // Treat the last radix with sign bit specially
         // Output signed groups (128..256 = -128..-1) first
         // other groups afterwards. No performance penalty, as compared to flipping sign bit
         if tempCounter == 7 {
            for groupCounter in 128..<256 {
               for number in groups[groupCounter] {
                  arrayToSort[tempArrayPos] = number
                  tempArrayPos += 1
               }
            }
            for groupCounter in 0..<128 {
               for number in groups[groupCounter] {
                  arrayToSort[tempArrayPos] = number
                  tempArrayPos += 1
               }
            }
         } else {
            for intArray in groups {
               for number in intArray {
                  arrayToSort[tempArrayPos] = number
                  tempArrayPos += 1
               }
            }
         }
         shift += 8
      } // for counter
      return arrayToSort.isSorted()
   } // realAlgorithm
   
} // Struct
