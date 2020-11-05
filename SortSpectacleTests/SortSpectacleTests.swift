//
//  SortSpectacleTests.swift
//  SortSpectacleTests
//
//  Created by Antti Juustila on 19.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import XCTest

@testable import SortSpectacle

let timeout = 30.0
let maxArraySize = 2_000

class SortSpectacleTests: XCTestCase {

   private var intArray = [Int]()
   private var range = 0...10
   private var count = 10

   override func setUp() {
      super.setUp()
      range = Int.random(in: -(maxArraySize/2)...0)...Int.random(in: 0...(maxArraySize/2))
      if range.isEmpty {
         range = -100...100
      }
      count = Int.random(in: 2...maxArraySize)
      print("Testing with \(count) elements from range \(range)")
      intArray.prepare(range: range, count: count)
   }

   override func tearDown() {
      super.tearDown()
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
      doSortTest(sortAlgorithm: sort)
      sort = LampSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
      sort = ShellSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
      sort = RadixSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
   }

   func testOneElementArray() {
      intArray.removeAll()
      intArray.append(1)
      var sort: SortMethod
      sort = BubbleSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
      sort = LampSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
      sort = ShellSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
      sort = RadixSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
   }

   func testTwoElementArray() {
      intArray.removeAll()
      intArray.append(2)
      intArray.append(1)
      var sort: SortMethod
      sort = BubbleSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
      intArray.removeAll()
      intArray.append(2)
      intArray.append(1)
      sort = LampSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
      intArray.removeAll()
      intArray.append(2)
      intArray.append(1)
      sort = ShellSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
      intArray.removeAll()
      intArray.append(2)
      intArray.append(1)
      sort = RadixSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
   }

   func testAlreadySortedArray() {
      intArray.removeAll()
      intArray.prepare(count: count)
      var sort: SortMethod
      sort = BubbleSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
      sort = LampSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
      sort = ShellSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
      sort = RadixSort(arraySize: intArray.count)
      doSortTest(sortAlgorithm: sort)
   }

   func testBubbleSort() {
      // intArray.prepare(range: -10...10)
      intArray.shuffle()
      let bubbleSort: SortMethod = BubbleSort(arraySize: intArray.count)
      measure {
         doSortTest(sortAlgorithm: bubbleSort)
      }
   }

   func testLampSort() {
      // intArray.prepare(range: -10...10)
      intArray.shuffle()
      let lampSort: SortMethod = LampSort(arraySize: intArray.count)
      measure {
         doSortTest(sortAlgorithm: lampSort)
      }
   }

   func testShellSort() {
      // intArray.prepare(range: -10...10)
      intArray.shuffle()
      let shellSort: SortMethod = ShellSort(arraySize: intArray.count)
      measure {
         doSortTest(sortAlgorithm: shellSort)
      }
   }
   
   func testRadixSort() {
      //intArray.prepare(range: -20...20)
      intArray.shuffle()
      let radixSort: SortMethod = RadixSort(arraySize: intArray.count)
      measure {
         doSortTest(sortAlgorithm: radixSort)
      }
   }

//   func testLampSortReal() {
//      intArray.prepare(count: 10)
//      var lampSort = LampSort(arraySize: intArray.count)
//      self.measure {
//         intArray.shuffle()
//         XCTAssertTrue(lampSort.realAlgorithm(arrayCopy: intArray), "Array was not sorted correctly")
//      }
//   }

   func testBubbleSortReal() {
      var sort = BubbleSort(arraySize: intArray.count)
      let expectation = XCTestExpectation(description: "Sorting done using \(sort.name) in less than \(timeout) seconds")
      intArray.shuffle()
      DispatchQueue.global().sync {
         self.measure {
            sort.realAlgorithm(arrayCopy: self.intArray)
            expectation.fulfill()
         }
      }
      // wait(for: [expectation], timeout: timeout)
   }

   func testShellSortReal() {
      var sort = ShellSort(arraySize: intArray.count)
      let expectation = XCTestExpectation(description: "Sorting done using \(sort.name) in less than \(timeout) seconds")
      intArray.shuffle()
      DispatchQueue.global().sync {
         self.measure {
            sort.realAlgorithm(arrayCopy: self.intArray)
            expectation.fulfill()
         }
      }
      wait(for: [expectation], timeout: timeout)
   }

   func testLampSortReal() {
      var sort = LampSort(arraySize: intArray.count)
      let expectation = XCTestExpectation(description: "Sorting done using \(sort.name) in less than \(timeout) seconds")
      intArray.shuffle()
      DispatchQueue.global().sync {
         self.measure {
            sort.realAlgorithm(arrayCopy: self.intArray)
            expectation.fulfill()
         }
      }
      wait(for: [expectation], timeout: timeout)
   }

   func testRadixSortReal() {
      // intArray.prepare(range: -20...20)
      var sort = RadixSort(arraySize: intArray.count)
      let expectation = XCTestExpectation(description: "Sorting done using \(sort.name) in less than \(timeout) seconds")
      intArray.shuffle()
      DispatchQueue.global().sync {
         self.measure {
            sort.realAlgorithm(arrayCopy: self.intArray)
            expectation.fulfill()
         }
      }
      wait(for: [expectation], timeout: timeout)
   }
   
   func doSortTest(sortAlgorithm: SortMethod) {
      let expectation = XCTestExpectation(description: "Sorting done using \(sortAlgorithm.name) in less than \(timeout) seconds")
      var method = sortAlgorithm
      let backupArray = intArray
      DispatchQueue.global().async {
         while true {
            var swappedItems = SwappedItems()
            let finished = method.nextStep(array: self.intArray, swappedItems: &swappedItems)
            if finished && self.intArray.isSorted() {
               expectation.fulfill()
               break
            }
            self.intArray.handleSortOperation(operation: swappedItems)
         }
      }
      wait(for: [expectation], timeout: timeout)
      print("\(backupArray)")
      print("\(intArray)")
      XCTAssertTrue(backupArray.containsSameElements(as: intArray))
   }

}
