//
//  main.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 8/30/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

import Foundation

let rl = 99999
let cl = 99999
//var mat = LiteMatrix<GoLCell>(row: rl, column: cl, withRepeatedValue: GoLCell())
var arr = [[GoLCell]](map(0..<rl){ _ in [GoLCell](map(0..<cl){ _ in GoLCell()})})


for array in arr {
    for thing in array {
        println("\(thing.nextAction)")
    }
}