//
//  ItemData.swift
//  Todoey
//
//  Created by Volodymyr Kryvytskyi on 23.09.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation

struct Item: Encodable {
    var title: String = ""
    var done: Bool = false
}
