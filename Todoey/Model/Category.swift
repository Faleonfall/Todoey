//
//  Category.swift
//  Todoey
//
//  Created by Volodymyr Kryvytskyi on 03.12.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<Item>()
}
