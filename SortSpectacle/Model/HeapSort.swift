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
      bla bla
      """
   }

   var webLinks: [(String, String)] {
      [("Wikipedia on HeapSort", "https://en.wikipedia.org/wiki/Heapsort")]
   }

   mutating func restart() {

   }

   mutating func nextStep(array: [Int], swappedItems: inout SwappedItems) -> Bool {
      return true
   }

   mutating func realAlgorithm(array: inout [Int]) {
      heapify(array: &array, array.count)
      var end = array.count - 1
      while end > 0 {
         let tmp = array[0]
         array[0] = array[end]
         array[end] = tmp
         end -= 1
         siftDown(array: &array, start: 0, end: end)
      }
   }

   private func heapify(array: inout [Int], _ count: Int) {
      var start = parent(count - 1)
      while start >= 0 {
         siftDown(array: &array, start: start, end: count - 1)
         start -= 1
      }
   }

   private func siftDown(array: inout [Int], start: Int, end: Int) {
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
      return 2 * index + 2;
   }

}
