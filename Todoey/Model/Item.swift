//
//  Item.swift
//  Todoey
//
//  Created by Vladimir Krivitskii on 03.12.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    let paretCategry = LinkingObjects(fromType: Category.self, property: "items")
}
