//
//  Stack.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 26.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

//See https://stackoverflow.com/questions/31462272/stack-implementation-in-swift
protocol Stackable {
   associatedtype Element
   func peek() -> Element?
   mutating func push(_ element: Element)
   @discardableResult mutating func pop() -> Element?
}

extension Stackable {
   var isEmpty: Bool { peek() == nil }
}

struct Stack<Element>: Stackable where Element: Equatable {
   private var storage = [Element]()
   func peek() -> Element? { storage.first }
   mutating func push(_ element: Element) { storage.append(element)  }
   mutating func pop() -> Element? { storage.popLast() }
}

extension Stack: Equatable {
   static func == (lhs: Stack<Element>, rhs: Stack<Element>) -> Bool { lhs.storage == rhs.storage }
}

extension Stack: CustomStringConvertible {
   var description: String { "\(storage)" }
}

extension Stack: ExpressibleByArrayLiteral {
   init(arrayLiteral elements: Self.Element...) { storage = elements }
}
