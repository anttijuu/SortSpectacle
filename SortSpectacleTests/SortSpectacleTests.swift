//
//  SortSpectacleTests.swift
//  SortSpectacleTests
//
//  Created by Antti Juustila on 19.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import XCTest

@testable import SortSpectacle

class SortSpectacleCollectionTests: XCTestCase {
   
   private var intArray = [Int] ()
   private var range = 0...10
   private var count = 10
   
   override func setUp() {
      super.setUp()
      range = Int.random(in: -1000...0)...Int.random(in: 0...1000)
      if range.isEmpty {
         range = -100...100
      }
      count = Int.random(in: 2...1000)
   }
   
   override func tearDown() {
      intArray.removeAll()
   }
   
   func testNumbersSetupRandomRange() {
      intArray.prepare(range: range, count: count)
      XCTAssertEqual(intArray.count, count)
      XCTAssertNotNil(intArray.max())
      XCTAssertNotNil(intArray.min())
      if let maxValue = intArray.max() {
         XCTAssertLessThan(maxValue, range.upperBound+1)
      }
      if let minValue = intArray.min() {
         XCTAssertGreaterThan(minValue, range.lowerBound-1)
      }
   }
   
   func testNumbersSetupLinearRange() {
      intArray.prepare(range: range)
      XCTAssertEqual(intArray.count, range.count)
      XCTAssertNotNil(intArray.max())
      XCTAssertNotNil(intArray.min())
      if let maxValue = intArray.max() {
         XCTAssertEqual(maxValue, range.upperBound)
      }
      if let minValue = intArray.min() {
         XCTAssertEqual(minValue, range.lowerBound)
      }
   }
   
   func testNumbersSetupLinearFromOne() {
      intArray.prepare(count : count)
      XCTAssertEqual(intArray.count, count)
      XCTAssertNotNil(intArray.max())
      XCTAssertNotNil(intArray.min())
      if let maxValue = intArray.max() {
         XCTAssertEqual(maxValue, count)
      }
      if let minValue = intArray.min() {
         XCTAssertEqual(minValue, 1)
      }
   }
   
   func testBubbleSort() {
      intArray.prepare(count: 1000)
      intArray.shuffle()
      let bubbleSort = BubbleSort(arraySize: intArray.count)
      self.measure {
         doSortTest(sortAlgorithm: bubbleSort)
      }
      XCTAssertTrue(checkArrayIsSorted(), "Array was not sorted correctly")
   }
   
   func testLampSort() {
      intArray.prepare(count: 1000)
      intArray.shuffle()
      let lampSort = LampSort(arraySize: intArray.count)
      self.measure {
         doSortTest(sortAlgorithm: lampSort)
      }
      XCTAssertTrue(checkArrayIsSorted(), "Array was not sorted correctly")
   }
   
   func testShellSort() {
      intArray.prepare(range: -10...10)
      let copy = intArray
      intArray.shuffle()
      let shellSort = ShellSort(arraySize: intArray.count)
      self.measure {
         doSortTest(sortAlgorithm: shellSort)
      }
      XCTAssertTrue(checkArrayIsSorted(), "Array was not sorted correctly")
      print(intArray)
      print(copy)
   }
   
   //   func testLampSortReal() {
   //      intArray.prepare(count: 10)
   //      let lampSort = LampSort(arraySize: intArray.count)
   //      self.measure {
   //         intArray.shuffle()
   //         XCTAssertTrue(lampSort.realAlgorithm(arrayCopy: intArray), "Array was not sorted correctly")
   //      }
   //   }
   
   func testBubbleSortReal() {
      intArray.prepare(range: -100...100)
      let sort = BubbleSort(arraySize: intArray.count)
      self.measure {
         intArray.shuffle()
         XCTAssertTrue(sort.realAlgorithm(arrayCopy: intArray), "realAlgorithm did not manage to sort correctly.")
      }
   }
   
   func testShellSortReal() {
      intArray.prepare(range: -100...100)
      let sort = ShellSort(arraySize: intArray.count)
      self.measure {
         intArray.shuffle()
         XCTAssertTrue(sort.realAlgorithm(arrayCopy: intArray), "realAlgorithm did not manage to sort correctly.")
      }
   }
   
   func doSortTest(sortAlgorithm : SortMethod) {
      var swappedItems = SwappedItems(first: -1, second: -1)
      while true {
         let finished = sortAlgorithm.nextStep(array: intArray, swappedItems: &swappedItems)
         intArray.handleSortOperation(operation: swappedItems)
         if finished {
            break
         }
      }
   }
   
   func checkArrayIsSorted() -> Bool {
      var index = 0
      for number in intArray {
         if index < intArray.count - 1 {
            if number >= intArray[index+1] {
               return false
            }
         }
         index += 1
      }
      return true
   }
}
