//
//  Sections.swift
//  MovieApp
//
//  Created by Francisco Garcia on 29/07/21.
//

struct Sections {
    var header: String
    var items: [String]
    
    init(title: String, objs: [String]) {
        header = title
        items = objs
    }
    
    mutating func update(objs: [String]) {
        for i in 0..<objs.count {
            items.append(objs[i])
        }
    }
}
