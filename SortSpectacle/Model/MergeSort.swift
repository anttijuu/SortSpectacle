//
//  MergeSort.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 21.5.2022.
//  Copyright © 2022 Antti Juustila. All rights reserved.
//


import Foundation

/**
 Mergesort is an i...

 See https://en.wikipedia.org/wiki/Merge_sort

 Based on https://github.com/BonzaiThePenguin/WikiSort/blob/master/WikiSort.java
 */
struct MergeSort: SortMethod {
   /**
    Initializes the Heapsort with the size of the array to sort.
    - parameter arraySize The size of the array
    */
   init(arraySize: Int) {
      size = arraySize
      cache = []
      cache?.reserveCapacity(Self.cacheSize)
   }

   /// The array size.
   var size: Int

   /// Name of the sorting method.
   var name: String {
      "MergeSort"
   }

   /// Description of the sorting method.
   var description: String {
      """
      Merge sort is an...
      """
   }

   /// Weblinks to read more information.
   var webLinks: [(String, String)] {
      [("Wikipedia on Mege sort", "https://en.wikipedia.org/wiki/Merge_sort")]
   }

   /// Restarts the sorting method by giving intial values to member variables.
   mutating func restart() {

   }

   /// Executes a step of the sorting.
   /// - parameter array The array that is sorted.
   /// - parameter swappedItems The structure to put the indexes to sort, sorting is done elsewhere.
   /// - returns Returns true if the sorting is done.
   mutating func nextStep(array: [Int], swappedItems: inout SwappedItems) -> Bool {

     return false
   }

   // MARK: - Helper types
   struct Pull {
      var from: Int = 0
      var to: Int = 0
      var count: Int = 0
      var range: ClosedRange<Int> = 0...0

      mutating func reset() {
         from = 0
         to = 0
         count = 0
         range = 0...0
      }
   }

   struct Iterator {

      var size: Int
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
         decimal = 0;
      }

      mutating func nextRange() -> ClosedRange<Int> {
         let start = decimal
         decimal += decimalStep
         numerator += numeratorStep
         if (numerator >= denominator) {
            numerator -= denominator
            decimal += 1
         }
         return start...decimal
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
         if (numeratorStep >= denominator) {
            numeratorStep -= denominator
            decimalStep += 1
         }
         return (decimalStep < size)
      }

      static func floorPowerOfTwo(of value: Int) -> Int {
         var x = value
         x = x | (x >> 1)
         x = x | (x >> 2)
         x = x | (x >> 4)
         x = x | (x >> 8)
         x = x | (x >> 16)
         x = x | (x >> 32)
         return x - (x >> 1)
      }

   }

   private static var cacheSize: Int = 512
   private var cache: [Int]?

   private func binaryFirst(array: [Int], value: Int, range: ClosedRange<Int>) -> Int {
      var start = range.lowerBound
      var end = range.upperBound - 1
      while (start < end) {
         let mid = start + (end - start)/2
         if array[mid] < value {
            start = mid + 1
         } else {
            end = mid
         }
      }
      if start == range.upperBound - 1 && array[start] < 0 {
         start += 1
      }
      return start
   }

   private func binaryLast(array: [Int], value: Int, range: ClosedRange<Int>) -> Int {
      var start = range.lowerBound
      var end = range.upperBound - 1
      while (start < end) {
         let mid = start + (end - start)/2
         if array[mid] >= 0 {
            start = mid + 1
         } else {
            end = mid
         }
      }
      if start == range.upperBound - 1 && value > array[start] {
         start += 1
      }
      return start
   }

   private func findFirstForward(array: [Int], value: Int, range: ClosedRange<Int>, unique: Int) -> Int {
      guard range.count > 0 else {
         return range.lowerBound
      }
      let skip: Int = max(range.count/unique, 1)
      var index: Int = range.lowerBound + skip
      while array[index - 1] < value {
         if index >= range.upperBound - skip {
            return binaryFirst(array: array, value: value, range: index...range.upperBound)
         }
         index += skip
      }
      return binaryFirst(array: array, value: value, range: index-skip...index)
   }

   private func findLastForward(array: [Int], value: Int, range: ClosedRange<Int>, unique: Int) -> Int {
      guard range.count > 0 else {
         return range.lowerBound
      }
      let skip: Int = max(range.count/unique, 1)
      var index: Int = range.lowerBound + skip
      while array[index - 1] >= value {
         if index >= range.upperBound - skip {
            return binaryLast(array: array, value: value, range: index...range.upperBound)
         }
         index += skip
      }
      return binaryLast(array: array, value: value, range: index-skip...index)
   }

   private func findFirstBackward(array: [Int], value: Int, range: ClosedRange<Int>, unique: Int) -> Int {
      guard range.count > 0 else {
         return range.lowerBound
      }
      let skip: Int = max(range.count/unique, 1)
      var index: Int = range.upperBound - skip
      while index > range.lowerBound && array[index - 1] >= value {
         if index < range.lowerBound + skip {
            return binaryFirst(array: array, value: value, range: range.lowerBound...index)
         }
         index -= skip
      }
      return binaryFirst(array: array, value: value, range: index...index+skip)
   }

   private func findLastBackward(array: [Int], value: Int, range: ClosedRange<Int>, unique: Int) -> Int {
      guard range.count > 0 else {
         return range.lowerBound
      }
      let skip: Int = max(range.count/unique, 1)
      var index: Int = range.upperBound - skip
      while index > range.lowerBound && array[index - 1] < value {
         if index < range.lowerBound + skip {
            return binaryLast(array: array, value: value, range: range.lowerBound...index)
         }
         index -= skip
      }
      return binaryFirst(array: array, value: value, range: index...index+skip)
   }

   private func reverse(_ array: inout [Int], in range: ClosedRange<Int>) {
      var index = range.count/2 - 1
      while index >= 0 {
         array.swapAt(range.lowerBound + index, range.upperBound - index - 1)
         index -= 1
      }
   }

   private func blockSwap(array: inout [Int], start1: Int, start2: Int, blockSize: Int) {
      var index = 0
      while index < blockSize {
         array.swapAt(start1 + index, start2 + index)
         index += 1
      }
   }


   // void Rotate(T array[], int amount, Range range, boolean use_cache) {
   private mutating func rotate(array: inout [Int], amount: Int, range: ClosedRange<Int>, useCache: Bool) {
      guard range.count > 0 else {
         return
      }

      var split: Int
      if amount >= 0 {
         split = range.lowerBound + amount
      } else {
         split = range.upperBound + amount
      }

      let range1 = range.lowerBound...split
      let range2 = split...range.upperBound

      if useCache {
         if range1.count < range2.count {
            if range1.count <= Self.cacheSize {
               if cache != nil {
                  cache!.removeAll()
                  cache!.append(contentsOf: array[range1])
                  array.replaceSubrange(range1, with: array[range2])
                  array.replaceSubrange(range2, with: cache!)
               }
               return
            }
         }
      } else {
         if range2.count < Self.cacheSize {
            if cache != nil {
               cache!.removeAll()
               cache!.append(contentsOf: array[range2])
               array.replaceSubrange(range2, with: array[range1])
               array.replaceSubrange(range1, with: cache!)
            }
            return
         }
      }

      reverse(&array, in: range1);
      reverse(&array, in: range2);
      reverse(&array, in: range);
   }

   private func merge(from: [Int], a: ClosedRange<Int>, b: ClosedRange<Int>, into: inout [Int], atIndex: Int) {
      var aIndex = a.lowerBound
      var bIndex = b.lowerBound
      var insertIndex = atIndex
      let aLast = a.upperBound
      let bLast = b.upperBound

      while (true) {
         if from[bIndex] >= from[aIndex] {
            into[insertIndex] = from[aIndex]
            aIndex += 1
            insertIndex += 1
            if aIndex == aLast {
               // copy the remainder of B into the final array
               into.append(contentsOf: from[bIndex...bLast-bIndex]) // Just from[bIndex...] ??
               break
            }
         } else {
            into[insertIndex] = from[bIndex]
            bIndex += 1
            insertIndex += 1
            if bIndex == bLast {
               // copy the remainder of A into the final array
               into.append(contentsOf: from[aIndex...aLast-aIndex]) // Just from[aIndex...] ??
               break
            }
         }
      }
   }

   // The MergeExternal in Java implementation.
   private func mergeFromCache(a: ClosedRange<Int>, b: ClosedRange<Int>, into: inout [Int]) {
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
            if into[bIndex] > cache![aIndex] {
               into[insertIndex] = cache![aIndex]
               aIndex += 1
               insertIndex += 1
               if aIndex == aLast {
                  break;
               }
            } else {
               into[insertIndex] = into[bIndex]
               bIndex += 1
               insertIndex += 1
               if bIndex == bLast {
                  break
               }
            }
         }
      }
      into.append(contentsOf: cache![aIndex...])
   }

   private func mergeInternal(array: inout [Int], a: ClosedRange<Int>, b: ClosedRange<Int>, buffer: ClosedRange<Int>) {
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
      blockSwap(array: &array, start1: buffer.lowerBound + aCount, start2: a.lowerBound + insert, blockSize: a.count - aCount)
   }

   private mutating func mergeInPlace(array: inout [Int], a: ClosedRange<Int>, b: ClosedRange<Int>) {
      guard a.count > 0 && b.count > 0 else {
         return
      }
      var aRange = a
      var bRange = b
      while true {
         let mid = binaryFirst(array: array, value: array[aRange.lowerBound], range: bRange)
         let amount = mid - aRange.upperBound
         rotate(array: &array, amount: -amount, range: aRange.lowerBound...mid, useCache: true)
         if aRange.upperBound == mid {
            break
         }
         bRange = mid...bRange.upperBound
         aRange = aRange.lowerBound + amount...bRange.upperBound
         let index = binaryLast(array: array, value: array[aRange.lowerBound], range: aRange)
         aRange = index...aRange.upperBound
      }
   }

   private func netSwap(array: inout [Int], order: inout [Int], range: ClosedRange<Int>, x: Int, y: Int) {
      let distance = array[range.lowerBound + x].distance(to: array[range.lowerBound + y])
      if (distance > 0 || (order[x] > order[y] && distance == 0)) {
         array.swapAt(range.lowerBound + x, range.lowerBound + y)
         order.swapAt(x, y)
      }
   }

   // bottom-up merge sort combined with an in-place merge algorithm for O(1) memory use
   mutating func sort(array: inout [Int]) {
      let size = array.count

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
      var buffer1: ClosedRange<Int>
      var buffer2: ClosedRange<Int>
      var blockA: ClosedRange<Int>
      var blockB: ClosedRange<Int>
      var lastA: ClosedRange<Int>
      var lastB: ClosedRange<Int>
      var firstA: ClosedRange<Int>
      var A: ClosedRange<Int>
      var B: ClosedRange<Int>

      var pull = [Pull]()
      pull[0] = Pull()
      pull[1] = Pull()

      // then merge sort the higher levels, which can be 8-15, 16-31, 32-63, 64-127, etc.
      while true {
         // if every A and B block will fit into the cache, use a special branch specifically for merging with the cache
         // (we use < rather than <= since the block size might be one more than iterator.length())
         if iterator.length < Self.cacheSize {
            // if four subarrays fit into the cache, it's faster to merge both pairs of subarrays into the cache,
            // then merge the two merged subarrays from the cache back into the original array
            if (iterator.length + 1) * 4 <= Self.cacheSize && iterator.length * 4 <= size {
               iterator.begin();
               while !iterator.finished {
                  var a1 = iterator.nextRange()
                  let b1 = iterator.nextRange()
                  var a2 = iterator.nextRange()
                  let b2 = iterator.nextRange()

                  if array[b1.upperBound - 1] < array[a1.lowerBound] {
                     // the two ranges are in reverse order, so copy them in reverse order into the cache
                     cache!.insert(contentsOf: array[a1.lowerBound...a1.upperBound], at: b1.count)
                     cache!.insert(contentsOf: array[b1.lowerBound...b1.upperBound], at: 0)
                  } else if array[b1.lowerBound] < array[a1.upperBound - 1] {
                     // these two ranges weren't already in order, so merge them into the cache
                     merge(from: array, a: a1, b: b1, into: &cache!, atIndex: 0)
                  } else {
                     // if A1, B1, A2, and B2 are all in order, skip doing anything else
                     if array[b2.lowerBound] >= array[a2.upperBound - 1] && array[a2.lowerBound] >= array[b1.upperBound - 1] {
                        continue;
                     }
                     // copy A1 and B1 into the cache in the same order
                     // the two ranges are in reverse order, so copy them in reverse order into the cache
                     cache!.insert(contentsOf: array[a1.lowerBound...a1.upperBound], at: 0)
                     cache!.insert(contentsOf: array[b1.lowerBound...b1.upperBound], at: a1.count)
                  }
                  a1 = a1.lowerBound...b1.upperBound


                  if array[b2.upperBound - 1] < array[a2.lowerBound] {
                     // the two ranges are in reverse order, so copy them in reverse order into the cache
                     cache!.insert(contentsOf: array[a2.lowerBound...a2.upperBound], at: a1.count + b2.count)
                     cache!.insert(contentsOf: array[b2.lowerBound...b2.upperBound], at: a1.count)
                  } else if array[b2.lowerBound] < array[a2.upperBound - 1] {
                     // these two ranges weren't already in order, so merge them into the cache
                     merge(from: array, a: a2, b: b2, into: &cache!, atIndex: a1.count)
                  } else {
                     // copy A1 and B1 into the cache in the same order
                     // the two ranges are in reverse order, so copy them in reverse order into the cache
                     cache!.insert(contentsOf: array[a2.lowerBound...a2.upperBound], at: a1.count)
                     cache!.insert(contentsOf: array[b2.lowerBound...b2.upperBound], at: a1.count + a2.count)
                  }
                  a2 = a2.lowerBound...b2.upperBound

                  let a3 = 0...a1.count
                  let b3 = a1.count...a1.count + a2.count

                  if cache![b3.upperBound - 1] < cache![a3.lowerBound] {
                     array.insert(contentsOf: cache![a2.lowerBound...a3.upperBound], at: a1.lowerBound + a2.count)
                     array.insert(contentsOf: cache![b3.lowerBound...b3.upperBound], at: a1.lowerBound)
                  } else if cache![b3.lowerBound] < cache![b3.upperBound - 1] {
                     merge(from: cache!, a: a3, b: b3, into: &array, atIndex: a1.lowerBound)
                  } else {
                     array.insert(contentsOf: cache![a3.lowerBound...a3.upperBound], at: a1.lowerBound)
                     array.insert(contentsOf: cache![b3.lowerBound...b3.upperBound], at: a1.lowerBound+a1.count)
                  }
               }
               iterator.nextLevel()
            } else {
               iterator.begin()
               while !iterator.finished {
                  let a = iterator.nextRange()
                  let b = iterator.nextRange()

                  if array[b.upperBound - 1] < array[a.lowerBound] {
                     rotate(array: &array, amount: a.count, range: a.lowerBound...b.upperBound, useCache: true)
                  } else if array[b.lowerBound] < array[a.upperBound - 1] {
                     cache!.insert(contentsOf: array[a.lowerBound...a.upperBound], at: 0)
                     mergeFromCache(a: a, b: b, into: &array)
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
            let blockSize = Int(sqrt(Double(iterator.length)))
            let bufferSize = iterator.length / blockSize + 1

            var index = 0
            var last = 0
            var count = 0
            var pullIndex = 0
            buffer1 = 0...0
            buffer2 = 0...0

            pull[0].reset()
            pull[1].reset()

            var find = bufferSize + bufferSize
            var findSeparately = false

            if blockSize < Self.cacheSize {
               find = bufferSize
            } else if find > iterator.length {
               find = bufferSize
               findSeparately = true
            }

            while !iterator.finished {
               let a = iterator.nextRange()
               let b = iterator.nextRange()

               //MARK: - HERE I AM

            }

         }
      }
   }


   /// The real algorithm without step-by-step execution.
   /// - parameter array The array to sort.
   mutating func realAlgorithm(array: inout [Int]) {
      if array.count < 2 {
         return
      }
      let powerOfTwo = Iterator.floorPowerOfTwo(of: size)
      let scale = size/powerOfTwo // 1.0 ≤ scale < 2.0

      // insertion sort 16–31 items at a time
      for merge in stride(from: 0, to: powerOfTwo, by: 16) {
         let start = merge * scale
         let end = start + 16 * scale
         insertionSort(&array, start: start, end: end)
      }
      var length = 16
      while length < powerOfTwo {
         var merge = 0
         while merge < powerOfTwo {
            var start = merge * scale
            let mid = (merge + length) * scale
            let end = (merge + length * 2) * scale
            if array[end - 1] < array[start] {
               rotate(&array, amount: mid-start, rangeStart: start, rangeEnd: end - 1)
            } else if array[mid - 1] > array[mid] {

            }
            merge += length * 2
         }
         length += length
      }

//                                  for (length = 16; length < power_of_two; length += length)
//                                  for (merge = 0; merge < power_of_two; merge += length * 2)
//                                  start = merge * scale
//                                  mid = (merge + length) * scale
//                                  end = (merge + length * 2) * scale
//
//                                  if (array[end − 1] < array[start])
//                                  // the two ranges are in reverse order, so a rotation is enough to merge them
//                                  Rotate(array, mid − start, [start, end))
//                                                              else if (array[mid − 1] > array[mid])
//                                                              Merge(array, A = [start, mid), B = [mid, end))
//                                                                                                  // else the ranges are already correctly ordered

   }


   // https://en.wikipedia.org/wiki/Insertion_sort
   private func insertionSort(_ array: inout [Int], start: Int, end: Int) {
      var i = start
      while i < end {
         let x = array[i]
         var j = i - 1
         while j >= 0 && array[j] > x {
            array[j + 1] = array[j]
            j -= 1
         }
         array[j + 1] = x
         i += 1
      }
   }

   private func rotate(_ array: inout [Int], amount: Int, rangeStart: Int, rangeEnd: Int) {
      reverseInPlace(&array, from: rangeStart, to: rangeEnd)
      reverseInPlace(&array, from: rangeStart, to: rangeStart + amount - 1)
      reverseInPlace(&array, from: rangeStart + amount, to: rangeEnd - 1)
   }

   private func reverseInPlace(_ array: inout [Int], from: Int, to: Int) {
      for index in stride(from: from, to: Int(Double((to - 2)/2).rounded(.down)), by: 1) {
         let tmp = array[index]
         array[index] = array[to - 1 - index]
         array[to - 1 - index] = tmp
      }
   }
}
