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
   private var range = 0
   private var count = 0
   
   
   override func setUp() {
      super.setUp()
      range = Int.random(in: 2...1000)
      count = Int.random(in: 2...5000)
      numbers = NumberCollection(range: range)
      numbers.generateNumbers(count: count)
   }
   
   override func tearDown() {
      numbers = nil
   }
   
   func test1EmptyCollection() {
      numbers.clear()
      XCTAssertEqual(numbers.count(), 0)
   }
   
   func testNumbersSetup() {
      XCTAssertEqual(numbers.count(), count)
      let maxValue = numbers.max()
      XCTAssertLessThan(maxValue, range+1)
   }
   
   func testSwappingValues() {
      let randomIndex1 = Int.random(in: 0...numbers.count())
      var randomIndex2 = 0
      repeat {
         randomIndex2 = Int.random(in: 0...numbers.count())
      } while randomIndex1 == randomIndex2
      
      let value1 = numbers.number(index: randomIndex1)
      let value2 = numbers.number(index: randomIndex2)
      numbers.swap(from: randomIndex1, to: randomIndex2)
      XCTAssertEqual(numbers.number(index: randomIndex2), value1)
      XCTAssertEqual(numbers.number(index: randomIndex1), value2)
   }
   
   func testPerformanceExample() {
      // This is an example of a performance test case.
      self.measure {
         _ = numbers.max()
      }
   }
   
}
