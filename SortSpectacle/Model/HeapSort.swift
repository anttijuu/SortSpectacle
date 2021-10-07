//
//  HeapSort.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 6.10.2021.
//  Copyright © 2021 Antti Juustila. All rights reserved.
//

import Foundation

struct HeapSort: SortMethod {
   init(arraySize: Int) {
      size = arraySize
   }

   var size: Int

   var name: String {
      "HeapSort"
   }

   var description: String {
      """
      Heapsort is an improved selection sort: like selection sort, heapsort divides its input into a sorted and an unsorted region, and it iteratively shrinks the unsorted region by extracting the largest element from it and inserting it into the sorted region.

      Unlike selection sort, heapsort does not waste time with a linear-time scan of the unsorted region; rather, heap sort maintains the unsorted region in a heap data structure (binary tree) to more quickly find the largest element in each step.

      Although somewhat slower in practice on most machines than a well-implemented quicksort, it has the advantage of a more favorable worst-case O(n log n) runtime. Heapsort is an in-place algorithm, but it is not a stable sort.
      """
   }

   var webLinks: [(String, String)] {
      [("Wikipedia on HeapSort", "https://en.wikipedia.org/wiki/Heapsort")]
   }

   mutating func restart() {
      state = .heapifying
      startIndex = parent(size - 1)
      endIndex = size - 1
      rootIndex = startIndex
      state = .siftingDown
   }

   mutating func nextStep(array: [Int], swappedItems: inout SwappedItems) -> Bool {

      if size < 2 {
         return true
      }
      
      switch state {
      case .finished:
         return true
      case .heapifying:
         if startIndex > 0 {
            state = .siftingDown
            stateBeforeSifting = .heapifying
            startIndex -= 1
            rootIndex = startIndex
            state = .siftingDown
            swappedItems.currentIndex1 = startIndex
            swappedItems.currentIndex2 = endIndex
         } else {
            endIndex = size - 1
            swappedItems.currentIndex2 = endIndex
            state = .mainWhileLoop
            // rootIndex = startIndex
         }
      case .mainWhileLoop:
         if endIndex > 0 {
            swappedItems.first = 0
            swappedItems.second = endIndex
            endIndex -= 1
            startIndex = 0
            swappedItems.currentIndex1 = startIndex
            swappedItems.currentIndex2 = endIndex
            rootIndex = startIndex
            state = .siftingDown
            stateBeforeSifting = .mainWhileLoop
         } else {
            state = .finished
         }
      case .siftingDown:
         // do sift down while loop and ...
         if leftChild(rootIndex) <= endIndex {
            let child = leftChild(rootIndex)
            var swap = rootIndex
            if array[swap] < array[child] {
               swap = child
            }
            if child + 1 <= endIndex && array[swap] < array[child+1] {
               swap = child + 1
            }
            if swap == rootIndex {
               state = stateBeforeSifting // Back to caller
            } else {
               swappedItems.first = rootIndex
               swappedItems.second = swap
               rootIndex = swap
            }
         } else {
            // after sifting is done do:
            state = stateBeforeSifting
         }
      }
      return state == .finished
   }

   private var startIndex: Int = 0
   private var endIndex: Int = 0
   private var rootIndex: Int = 0
   
   private enum State {
      case heapifying
      case mainWhileLoop
      case siftingDown
      case finished
   }
   private var state: State = .heapifying
   private var stateBeforeSifting: State = .heapifying

   mutating func realAlgorithm(array: inout [Int]) {
      if array.count < 2 {
         return
      }
      heapify(&array, array.count)
      var end = array.count - 1
      while end > 0 {
         let tmp = array[0]
         array[0] = array[end]
         array[end] = tmp
         end -= 1
         siftDown(&array, start: 0, end: end)
      }
   }

   private func heapify( _ array: inout [Int], _ count: Int) {
      var start = parent(count - 1)
      while start >= 0 {
         siftDown(&array, start: start, end: count - 1)
         start -= 1
      }
   }

   private func siftDown(_ array: inout [Int], start: Int, end: Int) {
      var root = start
      while leftChild(root) <= end {
         let child = leftChild(root)
         var swap = root
         if array[swap] < array[child] {
            swap = child
         }
         if child + 1 <= end && array[swap] < array[child+1] {
            swap = child + 1
         }
         if swap == root {
            return
         } else {
            let tmp = array[root]
            array[root] = array[swap]
            array[swap] = tmp
            root = swap
         }
      }
   }

   private func parent(_ index: Int) -> Int {
      return Int(floor((Double(index - 1))/2.0))
   }

   private func leftChild(_ index: Int) -> Int {
      return 2 * index + 1
   }

   private func rightChild(_ index: Int) -> Int {
      return 2 * index + 2
   }

}
