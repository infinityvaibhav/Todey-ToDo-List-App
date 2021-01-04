//
//  Category.swift
//  Todey
//
//  Created by 1389028 on 04/01/21.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
