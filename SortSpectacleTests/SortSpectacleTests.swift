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

   private var intArray = [Int]()
   private var range = 0...10
   private var count = 10

   override func setUp() {
      super.setUp()
      range = Int.random(in: -1000...0)...Int.random(in: 0...1000)
      if range.isEmpty {
         range = -100...100
      }
      count = Int.random(in: 2...1000)
      print("Testing with \(count) elements from range \(range)")
      intArray.prepare(range: range, count: count)
   }

   override func tearDown() {
      intArray.removeAll()
   }

   func testNumbersSetupRandomRange() {
      // intArray.prepare(range: range, count: count)
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
      intArray.prepare(count: count)
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

   func testEmptyArray() {
      intArray.removeAll()
      var sort: SortMethod
      sort = BubbleSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: &sort)
      sort = LampSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: &sort)
      sort = ShellSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: &sort)
   }

   func testOneElementArray() {
      intArray.removeAll()
      intArray.append(1)
      var sort: SortMethod
      sort = BubbleSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: &sort)
      sort = LampSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: &sort)
      sort = ShellSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: &sort)
   }

   func testTwoElementArray() {
      intArray.removeAll()
      intArray.append(2)
      intArray.append(1)
      var sort: SortMethod
      sort = BubbleSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: &sort)
      intArray.removeAll()
      intArray.append(2)
      intArray.append(1)
      sort = LampSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: &sort)
      intArray.removeAll()
      intArray.append(2)
      intArray.append(1)
      sort = ShellSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: &sort)
   }

   func testBubbleSort() {
      // intArray.prepare(range: -10...10)
      intArray.shuffle()
      var bubbleSort: SortMethod = BubbleSort(arraySize: intArray.count)
      self.measure {
         doSortTest(sortAlgorithm: &bubbleSort)
      }
   }

   func testLampSort() {
      // intArray.prepare(range: -10...10)
      intArray.shuffle()
      var lampSort: SortMethod = LampSort(arraySize: intArray.count)
      self.measure {
         doSortTest(sortAlgorithm: &lampSort)
      }
   }

   func testShellSort() {
      // intArray.prepare(range: -10...10)
      intArray.shuffle()
      var shellSort: SortMethod = ShellSort(arraySize: intArray.count)
      self.measure {
         doSortTest(sortAlgorithm: &shellSort)
      }
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
      // intArray.prepare(range: -100...100)
      var sort = BubbleSort(arraySize: intArray.count)
      intArray.shuffle()
      self.measure {
         XCTAssertTrue(sort.realAlgorithm(arrayCopy: intArray), "realAlgorithm BubbleSort did not manage to sort correctly.")
      }
   }

   func testShellSortReal() {
      // intArray.prepare(range: -100...100)
      var sort = ShellSort(arraySize: intArray.count)
      intArray.shuffle()
      self.measure {
         XCTAssertTrue(sort.realAlgorithm(arrayCopy: intArray), "realAlgorithm ShellSort did not manage to sort correctly.")
      }
   }

   func testLampSortReal() {
      // intArray.prepare(range: -100...100)
      var sort = LampSort(arraySize: intArray.count)
      intArray.shuffle()
      self.measure {
         XCTAssertTrue(sort.realAlgorithm(arrayCopy: intArray), "realAlgorithm LampSort did not manage to sort correctly.")
      }
   }

   func doSortTest(sortAlgorithm: inout SortMethod) {
      var swappedItems = SwappedItems()
      while true {
         let finished = sortAlgorithm.nextStep(array: intArray, swappedItems: &swappedItems)
         if finished {
            break
         }
         intArray.handleSortOperation(operation: swappedItems)
      }
      XCTAssertTrue(intArray.isSorted(), "Algorithm \(sortAlgorithm.name) failed to sort correctly.")
   }

}
