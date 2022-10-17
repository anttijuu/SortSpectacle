//
//  MergeSort.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 21.5.2022.
//  Copyright © 2022 Antti Juustila. All rights reserved.
//

import Foundation

/**
 Block sort, or block merge sort, is a sorting algorithm combining at least two merge operations with an insertion sort to arrive at O(n log n) in-place stable sorting. It gets its name from the observation that merging two sorted lists, A and B, is equivalent to breaking A into evenly sized blocks, inserting each A block into B under special rules, and merging AB pairs.

 WikiSort by Mike McFadden is an implementation of "block merge sort", which is a stable merge sort based on the work described in "Ratio based stable in-place merging", by Pok-Son Kim and Arne Kutzner. It's generally as fast as a standard merge sort while using O(1) memory, and can be modified to use additional memory optionally provided to it which can further improve its speed.

 The implementation here is a Swift port of Java implementation by Mike McFadden in  https://github.com/BonzaiThePenguin/WikiSort/blob/master/WikiSort.java

 For details and commented code, see the original Java version.

 Note that the Java version has a `Range` class, here we are using the Swift `Range<Int>` instead.
 */
struct MergeSort: SortMethod {
   /**
    Initializes the Heapsort with the size of the array to sort.
    - parameter arraySize The size of the array
    */
   init(arraySize: Int) {
      size = arraySize
      cache = []
      cache!.reserveCapacity(Self.cacheSize)
      cache!.prepare(count: Self.cacheSize)
   }

   /// The array size.
   let size: Int

   /// Name of the sorting method.
   var name: String {
      "Block Sort"
   }

   /// Description of the sorting method.
   var description: String {
      """
      Merge sort is a divide-and-conquer algorithm that was invented by John von Neumann in 1945. A detailed description and analysis of bottom-up merge sort appeared in a report by Goldstine and von Neumann as early as 1948.

      Block sort, or block merge sort, is a sorting algorithm combining at least two merge operations with an insertion sort to arrive at O(n log n) in-place stable sorting. It gets its name from the observation that merging two sorted lists, A and B, is equivalent to breaking A into evenly sized blocks, inserting each A block into B under special rules, and merging AB pairs.

      The implementation here is a Swift port of Java implementation of Block sort by Mike McFadden.

      WikiSort by Mike McFadden is an implementation of "block merge sort", which is a stable merge sort based on the work described in "Ratio based stable in-place merging", by Pok-Son Kim and Arne Kutzner. It's generally as fast as a standard merge sort while using O(1) memory, and can be modified to use additional memory optionally provided to it which can further improve its speed.
      """
   }

   /// Weblinks to read more information.
   var webLinks: [(String, String)] {
      [
         ("Wikipedia on Block sort", "https://en.wikipedia.org/wiki/Block_sort"),
         ("Wikipedia on Merge sort", "https://en.wikipedia.org/wiki/Merge_sort"),
         ("WikiSort by Mike McFadden", "https://github.com/BonzaiThePenguin/WikiSort")
      ]
   }

   /// Restarts the sorting method by giving intial values to member variables.
   mutating func restart() {
      // Nada
   }

   /// Executes a step of the sorting.
   /// - parameter array The array that is sorted.
   /// - parameter swappedItems The structure to put the indexes to sort, sorting is done elsewhere.
   /// - returns Returns true if the sorting is done.
   mutating func nextStep(array: [Int], swappedItems: inout SwappedItems) -> Bool {
      // TODO: Implement the phased version (good luck in that...)
     return true
   }

   // MARK: - Helper types
   /// Helper data type
   /// For details, see the original Java version linked in the comments/docs.
   struct Pull {
      var from: Int = 0
      var to: Int = 0
      var count: Int = 0
      var range: Range<Int> = 0..<0

      mutating func reset() {
         from = 0
         to = 0
         count = 0
         range = 0..<0
      }
   }

   /// Helper data type
   /// For details, see the original Java version linked in the comments/docs.
   struct Iterator {
      let size: Int
      var powerOfTwo: Int
      var numerator: Int = 0
      var decimal: Int = 0

      var denominator: Int
      var decimalStep: Int
      var numeratorStep: Int

      init(size: Int, minLevel: Int) {
         self.size = size
         powerOfTwo = MergeSort.Iterator.floorPowerOfTwo(of: size)
         denominator = powerOfTwo / minLevel
         numeratorStep = size % denominator
         decimalStep = size / denominator
         begin()
      }

      mutating func begin() {
         numerator = 0
         decimal = 0
      }

      mutating func nextRange() -> Range<Int> {
         let start = decimal
         decimal += decimalStep
         numerator += numeratorStep
         if numerator >= denominator {
            numerator -= denominator
            decimal += 1
         }
         return start..<decimal
      }

      var finished: Bool {
         decimal >= size
      }

      var length: Int {
         decimalStep
      }

      mutating func nextLevel() -> Bool {
         decimalStep += decimalStep
         numeratorStep += numeratorStep
         if numeratorStep >= denominator {
            numeratorStep -= denominator
            decimalStep += 1
         }
         return decimalStep < size
      }

      static func floorPowerOfTwo(of value: Int) -> Int {
         var x = value
         x = x | (x >> 1)
         x = x | (x >> 2)
         x = x | (x >> 4)
         x = x | (x >> 8)
         x = x | (x >> 16)
//         x = x | (x >> 32)
         return x - (x >> 1)
      }

   } // struct Iterator

   private static var cacheSize: Int = 512
   private var cache: [Int]?

   private func binaryFirst(array: [Int], value: Int, range: Range<Int>) -> Int {
      var start = range.lowerBound
      var end = range.upperBound - 1
      while start < end {
         let mid = start + (end - start)/2
         if array[mid] < value {
            start = mid + 1
         } else {
            end = mid
         }
      }
      if start == range.upperBound - 1 && array[start] < value {
         start += 1
      }
      return start
   }

   private func binaryLast(array: [Int], value: Int, range: Range<Int>) -> Int {
      var start = range.lowerBound
      var end = range.upperBound - 1
      while start < end {
         let mid = start + (end - start)/2
         if value >= array[mid] {
            start = mid + 1
         } else {
            end = mid
         }
      }
      if start == range.upperBound - 1 && value >= array[start] {
         start += 1
      }
      return start
   }

   private func findFirstForward(array: [Int], value: Int, range: Range<Int>, unique: Int) -> Int {
      guard range.count > 0 else {
         return range.lowerBound
      }
      let skip: Int = max(range.count/unique, 1)
      var index: Int = range.lowerBound + skip
      while array[index - 1] < value {
         if index >= range.upperBound - skip {
            return binaryFirst(array: array, value: value, range: index..<range.upperBound)
         }
         index += skip
      }
      return binaryFirst(array: array, value: value, range: index-skip..<index)
   }

   private func findLastForward(array: [Int], value: Int, range: Range<Int>, unique: Int) -> Int {
      guard range.count > 0 else {
         return range.lowerBound
      }
      let skip: Int = max(range.count/unique, 1)
      var index: Int = range.lowerBound + skip
      while value >= array[index - 1] {
         if index >= range.upperBound - skip {
            return binaryLast(array: array, value: value, range: index..<range.upperBound)
         }
         index += skip
      }
      return binaryLast(array: array, value: value, range: index-skip..<index)
   }

   private func findFirstBackward(array: [Int], value: Int, range: Range<Int>, unique: Int) -> Int {
      guard range.count > 0 else {
         return range.lowerBound
      }
      let skip: Int = max(range.count/unique, 1)
      var index: Int = range.upperBound - skip
      while index > range.lowerBound && array[index - 1] >= value {
         if index < range.lowerBound + skip {
            return binaryFirst(array: array, value: value, range: range.lowerBound..<index)
         }
         index -= skip
      }
      return binaryFirst(array: array, value: value, range: index..<index+skip)
   }

   private func findLastBackward(array: [Int], value: Int, range: Range<Int>, unique: Int) -> Int {
      guard range.count > 0 else {
         return range.lowerBound
      }
      let skip: Int = max(range.count/unique, 1)
      var index: Int = range.upperBound - skip
      while index > range.lowerBound && value < array[index - 1] {
         if index < range.lowerBound + skip {
            return binaryLast(array: array, value: value, range: range.lowerBound..<index)
         }
         index -= skip
      }
      return binaryFirst(array: array, value: value, range: index..<index+skip)
   }

   private func reverse(_ array: inout [Int], in range: Range<Int>) {
      var index = range.count/2 - 1
      while index >= 0 {
         array.swapAt(range.lowerBound + index, range.upperBound - index - 1)
         index -= 1
      }
      assert(size == array.count)
   }

   private func blockSwap(array: inout [Int], start1: Int, start2: Int, blockSize: Int) {
      var index = 0
      while index < blockSize {
         array.swapAt(start1 + index, start2 + index)
         index += 1
      }
      assert(size == array.count)
   }

   private mutating func rotate(array: inout [Int], amount: Int, range: Range<Int>, useCache: Bool) {
      guard range.count > 0 else {
         return
      }

      var split: Int
      if amount >= 0 {
         split = range.lowerBound + amount
      } else {
         split = range.upperBound + amount
      }

      let range1 = range.lowerBound..<split
      let range2 = split..<range.upperBound

      if useCache {
         if range1.count <= range2.count {
            if range1.count <= Self.cacheSize {
               if var cache = cache {
                  // cache!.removeAll()
                  cache.replace(from: array[range1], to: 0)
                  array.replace(from: array[range2], to: range1.lowerBound)
                  array.replace(from: cache[0..<range1.count], to: range1.lowerBound+range2.count)
               }
               return
            }
         }
      } else {
         if range2.count < Self.cacheSize {
            if var cache = cache {
               cache.replace(from: array[range1], to: 0)
               array.replace(from: array[range2], to: range1.lowerBound)
               array.replace(from: cache[0..<range1.count], to: range1.lowerBound+range2.count)
            }
            return
         }
      }
      assert(size == array.count)
      reverse(&array, in: range1)
      reverse(&array, in: range2)
      reverse(&array, in: range)
   }

   private func merge(from: [Int], a: Range<Int>, b: Range<Int>, into: inout [Int], atIndex: Int) {
      var aIndex = a.lowerBound
      var bIndex = b.lowerBound
      var insertIndex = atIndex
      let aLast = a.upperBound
      let bLast = b.upperBound

      while true {
         if from[bIndex] >= from[aIndex] {
            into[insertIndex] = from[aIndex]
            aIndex += 1
            insertIndex += 1
            if aIndex == aLast {
               // copy the remainder of B into the final array
               into.replace(from: from[bIndex..<bLast], to: insertIndex)
               break
            }
         } else {
            into[insertIndex] = from[bIndex]
            bIndex += 1
            insertIndex += 1
            if bIndex == bLast {
               into.replace(from: from[aIndex..<aLast], to: insertIndex)
               break
            }
         }
      }
   }

   // The MergeExternal in Java implementation.
   private func mergeExternal(_ array: inout [Int], a: Range<Int>, b: Range<Int>) {
      guard cache != nil else {
         return
      }
      var aIndex = 0
      var bIndex = b.lowerBound
      var insertIndex = a.lowerBound
      let aLast = a.count
      let bLast = b.upperBound

      if a.count > 0 && b.count > 0 {
         while true {
            if array[bIndex] >= cache![aIndex] {
               array[insertIndex] = cache![aIndex]
               aIndex += 1
               insertIndex += 1
               if aIndex == aLast {
                  break
               }
            } else {
               array[insertIndex] = array[bIndex]
               bIndex += 1
               insertIndex += 1
               if bIndex == bLast {
                  break
               }
            }
         }
      }
      array.replace(from: cache![aIndex..<aLast], to: insertIndex)
      assert(size == array.count)
   }

   private func mergeInternal(_ array: inout [Int], a: Range<Int>, b: Range<Int>, buffer: Range<Int>) {
      var aCount = 0
      var bCount = 0
      var insert = 0

      if b.count > 0 && a.count > 0 {
         while true {
            if array[b.lowerBound + bCount] >= array[buffer.lowerBound + aCount] {
               array.swapAt(a.lowerBound + insert, buffer.lowerBound + aCount)
               aCount += 1
               insert += 1
               if aCount >= a.count {
                  break
               }
            } else {
               array.swapAt(a.lowerBound + insert, b.lowerBound + bCount)
               bCount += 1
               insert += 1
               if bCount >= b.count {
                  break
               }
            }
         }
      }
      assert(size == array.count)
      blockSwap(array: &array, start1: buffer.lowerBound + aCount, start2: a.lowerBound + insert, blockSize: a.count - aCount)
   }

   private mutating func mergeInPlace(array: inout [Int], a: Range<Int>, b: Range<Int>) {
      guard a.count > 0 && b.count > 0 else {
         return
      }
      var aRange = a
      var bRange = b
      while true {
         let mid = binaryFirst(array: array, value: array[aRange.lowerBound], range: bRange)
         let amount = mid - aRange.upperBound
         rotate(array: &array, amount: -amount, range: aRange.lowerBound..<mid, useCache: true)
         if aRange.upperBound == mid {
            break
         }
         bRange = mid..<bRange.upperBound
         aRange = aRange.lowerBound + amount..<bRange.upperBound
         let index = binaryLast(array: array, value: array[aRange.lowerBound], range: aRange)
         aRange = index..<aRange.upperBound
         if aRange.count == 0 {
            break
         }
      }
      assert(size == array.count)
   }

   private func netSwap(array: inout [Int], order: inout [Int], range: Range<Int>, x: Int, y: Int) {
      let distance = array[range.lowerBound + x] - array[range.lowerBound + y]
      if distance > 0 || (order[x] > order[y] && distance == 0) {
         array.swapAt(range.lowerBound + x, range.lowerBound + y)
         order.swapAt(x, y)
      }
   }

   private func insertionSort(_ array: inout [Int], range: Range<Int>) {
      for i in stride(from: range.lowerBound + 1, to: range.upperBound, by: 1) {
         let temp = array[i]
         var j = i
         while j > range.lowerBound && temp < array[j - 1] {
            array[j] = array[j - 1]
            j -= 1
         }
         array[j] = temp
      }
   }

   // bottom-up merge sort combined with an in-place merge algorithm for O(1) memory use
   mutating func sort(_ array: inout [Int]) {
      if size < 4 {
         if size == 3 {
            if array[1] < array[0] {
               array.swapAt(1, 0)
            }
            if array[2] < array[1] {
               array.swapAt(2, 1)
               if array[1] < array[0] {
                  array.swapAt(1, 0)
               }
            }
         } else if size == 2 {
            if array[1] < array[0] {
               array.swapAt(1, 0)
            }
         }
         return
      }
      var iterator = Iterator(size: size, minLevel: 4)
      while !iterator.finished {
         var order = [0, 1, 2, 3, 4, 5, 6, 7]
         let range = iterator.nextRange()
         switch range.count {
         case 8:
            netSwap(array: &array, order: &order, range: range, x: 0, y: 1)
            netSwap(array: &array, order: &order, range: range, x: 2, y: 3)
            netSwap(array: &array, order: &order, range: range, x: 4, y: 5)
            netSwap(array: &array, order: &order, range: range, x: 6, y: 7)
            netSwap(array: &array, order: &order, range: range, x: 0, y: 2)
            netSwap(array: &array, order: &order, range: range, x: 1, y: 3)
            netSwap(array: &array, order: &order, range: range, x: 4, y: 6)
            netSwap(array: &array, order: &order, range: range, x: 5, y: 7)
            netSwap(array: &array, order: &order, range: range, x: 1, y: 2)
            netSwap(array: &array, order: &order, range: range, x: 5, y: 6)
            netSwap(array: &array, order: &order, range: range, x: 0, y: 4)
            netSwap(array: &array, order: &order, range: range, x: 3, y: 7)
            netSwap(array: &array, order: &order, range: range, x: 1, y: 5)
            netSwap(array: &array, order: &order, range: range, x: 2, y: 6)
            netSwap(array: &array, order: &order, range: range, x: 1, y: 4)
            netSwap(array: &array, order: &order, range: range, x: 3, y: 6)
            netSwap(array: &array, order: &order, range: range, x: 2, y: 4)
            netSwap(array: &array, order: &order, range: range, x: 3, y: 5)
            netSwap(array: &array, order: &order, range: range, x: 3, y: 4)
         case 7:
            netSwap(array: &array, order: &order, range: range, x: 1, y: 2)
            netSwap(array: &array, order: &order, range: range, x: 3, y: 4)
            netSwap(array: &array, order: &order, range: range, x: 5, y: 6)
            netSwap(array: &array, order: &order, range: range, x: 0, y: 2)
            netSwap(array: &array, order: &order, range: range, x: 3, y: 5)
            netSwap(array: &array, order: &order, range: range, x: 4, y: 6)
            netSwap(array: &array, order: &order, range: range, x: 0, y: 1)
            netSwap(array: &array, order: &order, range: range, x: 4, y: 5)
            netSwap(array: &array, order: &order, range: range, x: 2, y: 6)
            netSwap(array: &array, order: &order, range: range, x: 0, y: 4)
            netSwap(array: &array, order: &order, range: range, x: 1, y: 5)
            netSwap(array: &array, order: &order, range: range, x: 0, y: 3)
            netSwap(array: &array, order: &order, range: range, x: 2, y: 5)
            netSwap(array: &array, order: &order, range: range, x: 1, y: 3)
            netSwap(array: &array, order: &order, range: range, x: 2, y: 4)
            netSwap(array: &array, order: &order, range: range, x: 2, y: 3)
         case 6:
            netSwap(array: &array, order: &order, range: range, x: 1, y: 2)
            netSwap(array: &array, order: &order, range: range, x: 4, y: 5)
            netSwap(array: &array, order: &order, range: range, x: 0, y: 2)
            netSwap(array: &array, order: &order, range: range, x: 3, y: 5)
            netSwap(array: &array, order: &order, range: range, x: 0, y: 1)
            netSwap(array: &array, order: &order, range: range, x: 3, y: 4)
            netSwap(array: &array, order: &order, range: range, x: 2, y: 5)
            netSwap(array: &array, order: &order, range: range, x: 0, y: 3)
            netSwap(array: &array, order: &order, range: range, x: 1, y: 4)
            netSwap(array: &array, order: &order, range: range, x: 2, y: 4)
            netSwap(array: &array, order: &order, range: range, x: 1, y: 3)
            netSwap(array: &array, order: &order, range: range, x: 2, y: 3)
         case 5:
            netSwap(array: &array, order: &order, range: range, x: 0, y: 1)
            netSwap(array: &array, order: &order, range: range, x: 3, y: 4)
            netSwap(array: &array, order: &order, range: range, x: 2, y: 4)
            netSwap(array: &array, order: &order, range: range, x: 2, y: 3)
            netSwap(array: &array, order: &order, range: range, x: 1, y: 4)
            netSwap(array: &array, order: &order, range: range, x: 0, y: 3)
            netSwap(array: &array, order: &order, range: range, x: 0, y: 2)
            netSwap(array: &array, order: &order, range: range, x: 1, y: 3)
            netSwap(array: &array, order: &order, range: range, x: 1, y: 2)
         case 4:
            netSwap(array: &array, order: &order, range: range, x: 0, y: 1)
            netSwap(array: &array, order: &order, range: range, x: 2, y: 3)
            netSwap(array: &array, order: &order, range: range, x: 0, y: 2)
            netSwap(array: &array, order: &order, range: range, x: 1, y: 3)
            netSwap(array: &array, order: &order, range: range, x: 1, y: 2)
         default:
            break
         }
      }
      if size < 8 {
         return
      }
      var buffer1: Range<Int>
      var buffer2: Range<Int>
      var blockA: Range<Int>
      var blockB: Range<Int>
      var lastA: Range<Int>
      var lastB: Range<Int>
      var firstA: Range<Int>
      var A: Range<Int>
      var B: Range<Int>

      var pull = [Pull]()
      pull.append(Pull())
      pull.append(Pull())

      // then merge sort the higher levels, which can be 8-15, 16-31, 32-63, 64-127, etc.
      while true {
         // if every A and B block will fit into the cache, use a special branch specifically for merging with the cache
         // (we use < rather than <= since the block size might be one more than iterator.count)
         if iterator.length < Self.cacheSize {
            // if four subarrays fit into the cache, it's faster to merge both pairs of subarrays into the cache,
            // then merge the two merged subarrays from the cache back into the original array
            if (iterator.length + 1) * 4 <= Self.cacheSize && iterator.length * 4 <= size {
               iterator.begin()
               while !iterator.finished {
                  var a1 = iterator.nextRange()
                  let b1 = iterator.nextRange()
                  var a2 = iterator.nextRange()
                  let b2 = iterator.nextRange()

                  if array[b1.upperBound - 1] < array[a1.lowerBound] {
                     // the two ranges are in reverse order, so copy them in reverse order into the cache
                     cache!.replace(from: array[a1], to: b1.count)
                     cache!.replace(from: array[b1], to: 0)
                  } else if array[b1.lowerBound] < array[a1.upperBound - 1] {
                     // these two ranges weren't already in order, so merge them into the cache
                     merge(from: array, a: a1, b: b1, into: &cache!, atIndex: 0)
                  } else {
                     // if A1, B1, A2, and B2 are all in order, skip doing anything else
                     if array[b2.lowerBound] >= array[a2.upperBound - 1] && array[a2.lowerBound] >= array[b1.upperBound - 1] {
                        continue
                     }
                     // copy A1 and B1 into the cache in the same order
                     cache!.replace(from: array[a1], to: 0)
                     cache!.replace(from: array[b1], to: a1.count)
                  }
                  a1 = a1.lowerBound..<b1.upperBound

                  if array[b2.upperBound - 1] < array[a2.lowerBound] {
                     // the two ranges are in reverse order, so copy them in reverse order into the cache
                     cache!.replace(from: array[a2], to: a1.count + b2.count)
                     cache!.replace(from: array[b2], to: a1.count)
                  } else if array[b2.lowerBound] < array[a2.upperBound - 1] {
                     // these two ranges weren't already in order, so merge them into the cache
                     merge(from: array, a: a2, b: b2, into: &cache!, atIndex: a1.count)
                  } else {
                     // copy A1 and B1 into the cache in the same order
                     // the two ranges are in reverse order, so copy them in reverse order into the cache
                     cache!.replace(from: array[a2], to: a1.count)
                     cache!.replace(from: array[b2], to: a1.count + a2.count)
                  }
                  a2 = a2.lowerBound..<b2.upperBound

                  let a3 = 0..<a1.count
                  let b3 = a1.count..<a1.count + a2.count

                  if cache![b3.upperBound - 1] < cache![a3.lowerBound] {
                     array.replace(from: cache![a3], to: a1.lowerBound + a2.count)
                     array.replace(from: cache![b3], to: a1.lowerBound)
                  } else if cache![b3.lowerBound] < cache![b3.upperBound - 1] {
                     merge(from: cache!, a: a3, b: b3, into: &array, atIndex: a1.lowerBound)
                  } else {
                     array.replace(from: cache![a3], to: a1.lowerBound)
                     array.replace(from: cache![b3], to: a1.lowerBound + a1.count)
                  }
               }
               _ = iterator.nextLevel()
            } else {
               iterator.begin()
               while !iterator.finished {
                  let a = iterator.nextRange()
                  let b = iterator.nextRange()

                  if array[b.upperBound - 1] < array[a.lowerBound] {
                     rotate(array: &array, amount: a.count, range: a.lowerBound..<b.upperBound, useCache: true)
                  } else if array[b.lowerBound] < array[a.upperBound - 1] {
                     cache!.replace(from: array[a], to: 0)
                     mergeExternal(&array, a: a, b: b)
                  }
               }
            }
         } else {
            // this is where the in-place merge logic starts!
            // 1. pull out two internal buffers each containing √A unique values
            //     1a. adjust block_size and buffer_size if we couldn't find enough unique values
            // 2. loop over the A and B subarrays within this level of the merge sort
            //     3. break A and B into blocks of size 'block_size'
            //     4. "tag" each of the A blocks with values from the first internal buffer
            //     5. roll the A blocks through the B blocks and drop/rotate them where they belong
            //     6. merge each A block with any B values that follow, using the cache or the second internal buffer
            // 7. sort the second internal buffer if it exists
            // 8. redistribute the two internal buffers back into the array
            var blockSize = Int(sqrt(Double(iterator.length)))
            var bufferSize = iterator.length / blockSize + 1

            var index = 0
            var last = 0
            var count = 0
            var pullIndex = 0
            buffer1 = 0..<0
            buffer2 = 0..<0

            pull[0].reset()
            pull[1].reset()

            var find = bufferSize + bufferSize
            var findSeparately = false

            if blockSize <= Self.cacheSize {
               find = bufferSize
            } else if find > iterator.length {
               find = bufferSize
               findSeparately = true
            }

            iterator.begin()
            while !iterator.finished {
               let a = iterator.nextRange()
               let b = iterator.nextRange()

               last = a.lowerBound
               count = 1
               while count < find {
                  index = findLastForward(array: array, value: array[last], range: last + 1..<a.upperBound, unique: find - count)
                  if index == a.upperBound {
                     break
                  }
                  last = index
                  count += 1
               }
               index = last
               if count >= bufferSize {
                  pull[pullIndex].range = a.lowerBound..<b.upperBound
                  pull[pullIndex].count = count
                  pull[pullIndex].from = index
                  pull[pullIndex].to = a.lowerBound
                  pullIndex = 1

                  if count == bufferSize + bufferSize {
                     buffer1 = a.lowerBound..<a.lowerBound + bufferSize
                     buffer2 = a.lowerBound + bufferSize..<a.lowerBound + count
                     break // while !iterator.finished
                  } else if find == bufferSize + bufferSize {
                     buffer1 = a.lowerBound..<a.lowerBound + count
                     find = bufferSize
                  } else if blockSize <= Self.cacheSize {
                     buffer1 = a.lowerBound..<a.lowerBound + count
                     break
                  } else if findSeparately {
                     buffer1 = a.lowerBound..<a.lowerBound + count
                     findSeparately = false
                  } else {
                     buffer2 = a.lowerBound..<a.lowerBound + count
                     break
                  }
               } else if pullIndex == 0 && count > buffer1.count {
                  buffer1 = a.lowerBound..<a.lowerBound + count
                  pull[pullIndex].range = a.lowerBound..<b.upperBound
                  pull[pullIndex].count = count
                  pull[pullIndex].from = index
                  pull[pullIndex].to = a.lowerBound
               }

               last = b.upperBound - 1
               count = 1
               while count < find {
                  index = findFirstBackward(array: array, value: array[last], range: b.lowerBound..<last, unique: find - count)
                  if index == b.lowerBound {
                     break
                  }
                  last = index - 1
                  count += 1
               }
               index = last

               if count >= bufferSize {
                  pull[pullIndex].range = a.lowerBound..<b.upperBound
                  pull[pullIndex].count = count
                  pull[pullIndex].from = index
                  pull[pullIndex].to = b.upperBound
                  pullIndex = 1

                  if count == bufferSize + bufferSize {
                     buffer1 = b.upperBound-count..<b.upperBound-bufferSize
                     buffer2 = b.upperBound-bufferSize..<b.upperBound
                     break
                  } else if find == bufferSize + bufferSize {
                     buffer1 = b.upperBound-count..<b.upperBound
                     find = bufferSize
                  } else if blockSize <= Self.cacheSize {
                     buffer1 = b.upperBound-count..<b.upperBound
                     break
                  } else if findSeparately {
                     buffer1 = b.upperBound-count..<b.upperBound
                     findSeparately = false
                  } else {
                     if pull[0].range.lowerBound == a.lowerBound {
                        let upperBound = pull[0].range.upperBound - pull[1].count
                        pull[0].range = pull[0].range.lowerBound..<upperBound
                     }
                     buffer2 = b.upperBound-count..<b.upperBound
                     break
                  }
               } else if pullIndex == 0 && count > buffer1.count {
                  buffer1 = b.upperBound-count..<b.upperBound
                  pull[pullIndex].range = a.lowerBound..<b.upperBound
                  pull[pullIndex].count = count
                  pull[pullIndex].from = index
                  pull[pullIndex].to = b.upperBound
               }
            }
            for pullIndex in stride(from: 0, to: 2, by: 1) {
               let length = pull[pullIndex].count

               if pull[pullIndex].to < pull[pullIndex].from {
                  index = pull[pullIndex].from
                  for count in stride(from: 1, to: length, by: 1) {
                     index = findFirstBackward(array: array, value: array[index - 1], range: pull[pullIndex].to..<pull[pullIndex].from - (count - 1), unique: length - count)
                     let range = index + 1..<pull[pullIndex].from + 1
                     rotate(array: &array, amount: range.count - count, range: range, useCache: true)
                     pull[pullIndex].from = index + count
                  }
               } else if pull[pullIndex].to > pull[pullIndex].from {
                  index = pull[pullIndex].from + 1
                  for count in stride(from: 1, to: length, by: 1) {
                     index = findLastForward(array: array, value: array[index], range: index..<pull[pullIndex].to, unique: length - count)
                     let range = pull[pullIndex].from..<index - 1
                     rotate(array: &array, amount: count, range: range, useCache: true)
                     pull[pullIndex].from = index - 1 - count
                  }
               }
            }
            bufferSize = buffer1.count
            blockSize = iterator.length/bufferSize + 1

            iterator.begin()
            while !iterator.finished {
               A = iterator.nextRange()
               B = iterator.nextRange()

               let start = A.lowerBound
               if start == pull[0].range.lowerBound {
                  if pull[0].from > pull[0].to {
                     A = A.lowerBound+pull[0].count..<A.upperBound
                     if A.count == 0 {
                        continue
                     }
                  } else if pull[0].from < pull[0].to {
                     B = B.lowerBound..<B.upperBound-pull[0].count
                     if B.count == 0 {
                        continue
                     }
                  }
               }
               if start == pull[1].range.lowerBound {
                  if pull[1].from > pull[1].to {
                     A = A.lowerBound+pull[1].count..<A.upperBound
                     if A.count == 0 {
                        continue
                     }
                  } else if pull[1].from < pull[1].to {
                     B = B.lowerBound..<B.upperBound-pull[1].count
                     if B.count == 0 {
                        continue
                     }
                  }
               }

               if array[B.upperBound-1] < array[A.lowerBound] {
                  rotate(array: &array, amount: A.count, range: A.lowerBound..<B.upperBound, useCache: true)
               } else if array[A.upperBound] < array[A.upperBound-1] {
                  blockA = A.lowerBound..<A.upperBound
                  firstA = A.lowerBound..<A.lowerBound + blockA.count % blockSize
                  var indexA = buffer1.lowerBound
                  index = firstA.upperBound
                  while index < blockA.upperBound {
                     array.swapAt(indexA, index)
                     indexA += 1
                     index += blockSize
                  }

                  lastA = firstA
                  lastB = 0..<0
                  blockB = B.lowerBound..<B.lowerBound+min(blockSize, B.count)
                  blockA = blockA.lowerBound+firstA.count..<blockA.upperBound
                  indexA = buffer1.lowerBound

                  if lastA.count <= Self.cacheSize && cache != nil {
                     cache!.replace(from: array[lastA], to: 0)
                  } else if buffer2.count > 0 {
                     blockSwap(array: &array, start1: lastA.lowerBound, start2: buffer2.lowerBound, blockSize: lastA.count)
                  }

                  if blockA.count > 0 {
                     while true {
                        if (lastB.count > 0 && array[lastB.upperBound - 1] >= array[indexA]) || blockB.count == 0 {
                           let bSplit = binaryFirst(array: array, value: array[indexA], range: lastB)
                           let bRemaining = lastB.upperBound - bSplit

                           var minA = blockA.lowerBound
                           var findA = minA + blockSize
                           while findA < blockA.upperBound {
                              if array[findA] < array[minA] {
                                 minA = findA
                              }
                              findA += blockSize
                           }
                           blockSwap(array: &array, start1: blockA.lowerBound, start2: minA, blockSize: blockSize)

                           array.swapAt(blockA.lowerBound, indexA)
                           indexA += 1

                           if lastA.count <= Self.cacheSize {
                              mergeExternal(&array, a: lastA, b: lastA.upperBound..<bSplit)
                           } else if buffer2.count > 0 {
                              mergeInternal(&array, a: lastA, b: lastA.upperBound..<bSplit, buffer: buffer2)
                           } else {
                              mergeInPlace(array: &array, a: lastA, b: lastA.upperBound..<bSplit)
                           }
                           if buffer2.count > 0 || blockSize <= Self.cacheSize {
                              if blockSize <= Self.cacheSize {
                                 cache!.replace(from: array[blockA.lowerBound..<blockA.lowerBound+blockSize], to: 0)
                              } else {
                                 blockSwap(array: &array, start1: blockA.lowerBound, start2: buffer2.lowerBound, blockSize: blockSize)
                              }
                              blockSwap(array: &array, start1: bSplit, start2: blockA.lowerBound + blockSize - bRemaining, blockSize: bRemaining)
                           } else {
                              rotate(array: &array, amount: blockA.lowerBound - bSplit, range: bSplit..<blockA.lowerBound + blockSize, useCache: true)
                           }
                           lastA = blockA.lowerBound - bRemaining..<blockA.lowerBound - bRemaining + blockSize
                           lastB = lastA.upperBound..<lastA.upperBound + bRemaining

                           blockA = blockA.lowerBound + blockSize..<blockA.upperBound
                           if blockA.isEmpty {
                              break
                           }
                        } else if blockB.count < blockSize {
                           rotate(array: &array, amount: -blockB.count, range: blockA.lowerBound..<blockB.upperBound, useCache: false)
                           lastB = blockA.lowerBound..<blockA.lowerBound + blockB.count
                           blockA = blockA.lowerBound+blockB.count..<blockA.upperBound + blockB.count
                           blockB = blockB.lowerBound..<blockB.lowerBound
                        } else {
                           blockSwap(array: &array, start1: blockA.lowerBound, start2: blockB.lowerBound, blockSize: blockSize)
                           lastB = blockA.lowerBound..<blockA.lowerBound + blockSize

                           blockA = blockA.lowerBound + blockSize..<blockA.upperBound + blockSize
                           blockB = blockB.lowerBound + blockSize..<blockB.upperBound + blockSize
                           if blockB.upperBound > B.upperBound {
                              blockB = blockB.lowerBound..<B.upperBound
                           }
                        }
                     }
                  }
                  if lastA.count <= Self.cacheSize {
                     mergeExternal(&array, a: lastA, b: lastA.upperBound..<B.upperBound)
                  } else if buffer2.count > 0 {
                     mergeInternal(&array, a: lastA, b: lastA.upperBound..<B.upperBound, buffer: buffer2)
                  } else {
                     mergeInPlace(array: &array, a: lastA, b: lastA.upperBound..<B.upperBound)
                  }
               }
            }
            insertionSort(&array, range: buffer2)

            for pullIndex in stride(from: 0, to: 2, by: 1) {
               var unique = pull[pullIndex].count * 2
               if pull[pullIndex].from > pull[pullIndex].to {
                  var buffer = pull[pullIndex].range.lowerBound..<pull[pullIndex].range.lowerBound + pull[pullIndex].count
                  while buffer.count > 0 {
                     index = findFirstForward(array: array, value: array[buffer.lowerBound], range: buffer.upperBound..<pull[pullIndex].range.upperBound, unique: unique)
                     let amount = index - buffer.upperBound
                     rotate(array: &array, amount: buffer.count, range: buffer.lowerBound..<index, useCache: true)
                     buffer = buffer.lowerBound + amount + 1..<buffer.upperBound + amount
                     unique -= 2
                  }
               } else if pull[pullIndex].from < pull[pullIndex].to {
                  var buffer = pull[pullIndex].range.upperBound - pull[pullIndex].count..<pull[pullIndex].range.upperBound
                  while buffer.count > 0 {
                     index = findLastBackward(array: array, value: array[buffer.upperBound - 1], range: pull[pullIndex].range.lowerBound..<buffer.lowerBound, unique: unique)
                     let amount = buffer.lowerBound - index
                     rotate(array: &array, amount: amount, range: index..<buffer.upperBound, useCache: true)
                     buffer = buffer.lowerBound - amount..<buffer.upperBound - amount + 1
                     unique -= 2
                  }
               }
            }
            // MARK: - HERE I AM
         }
         if !iterator.nextLevel() {
            break
         }
      }
   }

   /// The real algorithm without step-by-step execution.
   /// - parameter array The array to sort.
   mutating func realAlgorithm(array: inout [Int]) {
      if array.count < 2 {
         return
      }
      sort(&array)
//      let powerOfTwo = Iterator.floorPowerOfTwo(of: size)
//      let scale = size/powerOfTwo // 1.0 ≤ scale < 2.0
//
//      // insertion sort 16–31 items at a time
//      for merge in stride(from: 0, to: powerOfTwo - 1, by: 16) {
//         let start = merge * scale
//         let end = start + 16 * scale
//         insertionSort(&array, start: start, end: end)
//      }
//      var length = 16
//      while length < powerOfTwo {
//         var merge = 0
//         while merge < powerOfTwo {
//            let start = merge * scale
//            let mid = (merge + length) * scale
//            let end = (merge + length * 2) * scale
//            if array[end - 1] < array[start] {
//               rotate(&array, amount: mid-start, rangeStart: start, rangeEnd: end - 1)
//            } else if array[mid - 1] > array[mid] {
//
//            }
//            merge += length * 2
//         }
//         length += length
//      }
   }

   // https://en.wikipedia.org/wiki/Insertion_sort
//   private func insertionSort(_ array: inout [Int], start: Int, end: Int) {
//      var i = start
//      while i < end {
//         let x = array[i]
//         var j = i - 1
//         while j >= 0 && array[j] > x {
//            array[j + 1] = array[j]
//            j -= 1
//         }
//         array[j + 1] = x
//         i += 1
//      }
//   }
//
//   private func rotate(_ array: inout [Int], amount: Int, rangeStart: Int, rangeEnd: Int) {
//      reverseInPlace(&array, from: rangeStart, to: rangeEnd)
//      reverseInPlace(&array, from: rangeStart, to: rangeStart + amount - 1)
//      reverseInPlace(&array, from: rangeStart + amount, to: rangeEnd - 1)
//   }
//
//   private func reverseInPlace(_ array: inout [Int], from: Int, to: Int) {
//      for index in stride(from: from, to: Int(Double((to - 2)/2).rounded(.down)), by: 1) {
//         let tmp = array[index]
//         array[index] = array[to - 1 - index]
//         array[to - 1 - index] = tmp
//      }
//   }
}
