//
//  GoLColorGrid.swift
//  LifeGenSwift
//
//  Created by Gregory D. Stula on 9/8/15.
//  Copyright (c) 2015 Gregory D. Stula. All rights reserved.
//

import UIKit

class GoLColorGrid: GoLGrid {

    override var cellGrid = LiteMatrix<GoLColorCell>

    enum newCellColor {
        case Blue(UIColor)
        case Red(UIColor)
    }
}
