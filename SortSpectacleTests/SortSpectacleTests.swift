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
         range = -10...10
      }
      count = Int.random(in: 2...1000)
   }
   
   override func tearDown() {
      intArray.removeAll()
   }
      
   func testNumbersSetupRandomRange() {
      intArray.prepare(range: range, count: count)
      print(intArray)
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
      print(intArray)
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
      print(intArray)
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
}
