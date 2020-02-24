//
//  SortMethod.swift
//  SortSpectacle
//
//  Created by Antti Juustila on 24.2.2020.
//  Copyright © 2020 Antti Juustila. All rights reserved.
//

import Foundation

protocol SortMethod {
   
   init(array : inout [Int])
   func getName() -> String
   func nextStep() -> Bool
   
}
