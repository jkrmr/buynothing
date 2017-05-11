//
//  UIResponder.swift
//  buynothing
//
//  Created by Jake Romer on 4/14/17.
//  Copyright © 2017 Jake Romer. All rights reserved.
//

import UIKit

extension UIResponder {
  static var reuseID: String {
    return String(describing: self)
  }
}
