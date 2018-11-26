//
//  Item.swift
//  Todoey
//
//  Created by Jonathan Go on 2018/11/26.
//  Copyright © 2018 Appdelight. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
  @objc dynamic var title = ""
  @objc dynamic var done = false
  @objc dynamic var dateCreated: Date?
  var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
