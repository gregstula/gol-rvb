//
//  Logic.swift
//  functional-gol
//
//  Created by Gregory Stula on 4/5/16.
//  Copyright © 2016 Gregory Stula. All rights reserved.
//

import Foundation

// functional.playground
//
//  Created by Gregory Stula on 4/4/16.
//  Copyright (c) 2016 Gregory Stula. All rights reserved.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as
// published by the Free Software Foundation, either version 3 of the
// License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

import UIKit

// The basic types
enum CellState {
    case Alive
    case Dead
}

enum Position {
    case Position (Int, Int)
    
    init(x:Int, y:Int) {
        self = .Position(x,y)
    }
}

typealias Generation = (Position) -> CellState
typealias NeighborsArray = [Position]

// Leaf functions
func isAlive(cell: CellState) -> Bool {
    switch cell {
    case .Alive:
        return true
    case .Dead:
        return false
    }
}

func neighbors(pos: Position) -> NeighborsArray {
    switch pos {
    case let .Position(x,y):
        return [Position(x: x+1, y: y+1), Position(x: x, y: y-1), Position(x: x+1, y: y),
                Position(x: x+1, y: y-1), Position(x: x-1, y: y), Position(x: x-1, y: y-1),
                Position(x: x-1, y: y+1), Position(x: x, y: y+1)]
    }
}

// Composing

func aliveNeighbors (generation: Generation, position: Position) -> Int {
    return neighbors(position).map { generation($0) } .filter { isAlive($0) } .count
}


func evolution(generation: Generation) -> Generation {
    return { position in
        switch aliveNeighbors(generation, position: position) {
        case 2:
            if isAlive(generation(position)) {
                return .Alive
            } else {
                return .Dead
            }
        case 3:
            return .Alive
        default:
            return .Dead
        }
    }
}


// Visualizing

func visualizeCell(generation: Generation, x: Int, y: Int) {
    switch (generation(Position(x: x, y: y))) {
    case .Alive:
        print("#", terminator:"")
    case .Dead:
        print(" ", terminator:"")
    }
}

func visualizeLine(generation: Generation, y: Int) {
    Array(1...10).map { x in visualizeCell(generation, x: x, y: y) }
}

func visualizeGeneration(generation: Generation) {
    Array(1...10).map { y in visualizeLine(generation, y: y) }
}

