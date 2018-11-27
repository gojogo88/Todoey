//
//  Category.swift
//  Todoey
//
//  Created by Jonathan Go on 2018/11/26.
//  Copyright © 2018 Appdelight. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  @objc dynamic var name = ""
  @objc dynamic var colour: String = ""
  let items = List<Item>()
}
