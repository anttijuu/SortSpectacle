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
   
   private var numbers : NumberCollection!
   private var range = 0...10
   private var count = 10
   
   override func setUp() {
      super.setUp()
      range = Int.random(in: -1000...0)...Int.random(in: 0...1000)
      if range.isEmpty {
         range = -10...10
      }
      count = Int.random(in: 2...1000)
      numbers = NumberCollection(range: range)
      numbers.generateNumbers(count: count)
   }
   
   override func tearDown() {
      numbers = nil
   }
   
   func testEmptyCollection() {
      numbers.clear()
      XCTAssertEqual(numbers.count(), 0)
      XCTAssertNil(numbers.max())
      XCTAssertNil(numbers.min())
   }
   
   func testNumbersSetup() {
      XCTAssertEqual(numbers.count(), count)
      XCTAssertNotNil(numbers.max())
      XCTAssertNotNil(numbers.min())
      if let maxValue = numbers.max() {
         XCTAssertLessThan(maxValue, range.upperBound+1)
      }
      if let minValue = numbers.min() {
         XCTAssertGreaterThan(minValue, range.lowerBound-1)
      }
      let max = numbers.max()!
      let min = numbers.min()!
      XCTAssertLessThanOrEqual(min, max)
   }
   
   func testSwappingValues() {
      let randomIndex1 = Int.random(in: 0..<numbers.count())
      var randomIndex2 = 0
      repeat {
         randomIndex2 = Int.random(in: 0..<numbers.count())
      } while randomIndex1 == randomIndex2
      
      let value1 = numbers.number(index: randomIndex1)
      let value2 = numbers.number(index: randomIndex2)
      numbers.swap(from: randomIndex1, to: randomIndex2)
      XCTAssertEqual(numbers.number(index: randomIndex2), value1)
      XCTAssertEqual(numbers.number(index: randomIndex1), value2)
   }
   
   func testCopying() {
      var copy : NumberCollection? = nil
      self.measure {
         copy = numbers.copy() as? NumberCollection
      }
      for _ in 1...copy!.count() / 5 {
         let random = Int.random(in: 0..<numbers.count())
         XCTAssertEqual(copy!.number(index: random), numbers.number(index: random))
      }
   }
   
   func testPerformanceExample() {
      // This is an example of a performance test case.
      self.measure {
         _ = numbers.max()
         _ = numbers.min()
      }
   }
   
}
