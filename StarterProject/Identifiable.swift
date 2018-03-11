//
//  Identifiable.swift
//  StarterProject
//
//  Created by Strat Aguilar on 11/6/17.
//  Copyright © 2017 Strat Aguilar. All rights reserved.
//

import Foundation

protocol Identifiable: class{
}

extension Identifiable{
  static var identifier: String{
    get{
      return String(describing: self)
    }
  }
}
