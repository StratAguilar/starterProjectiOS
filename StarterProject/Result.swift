//
//  Result.swift
//  StarterProject
//
//  Created by Strat Aguilar on 4/15/18.
//  Copyright © 2018 Strat Aguilar. All rights reserved.
//

import Foundation

enum Result<Value, Err: Error>{
  case success(Value)
  case failure(Error)
}

struct StringError: Error{
  
}

let result = Result<String, StringError>.success("sdfsd")
