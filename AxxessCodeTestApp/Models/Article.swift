//
//  Article.swift
//  AxxessCodeTestApp
//
//  Created by Shailesh Gole on 13/08/20.
//  Copyright © 2020 ShaileshG. All rights reserved.
//

import Foundation

/// Create Model 
struct Article: Decodable {
  let id: String
  let type: String
  let date: String?
  let data: String?
}

/// Define Enum to model type
enum Type: String, Decodable, CaseIterable {
  case image = "image"
  case other = "other"
  case text = "text"
}

typealias Articles = [Article]
