//: Playground - noun: a place where people can play

import UIKit

// The basic types
enum CellState {
    case Alive
    case Dead
}

// TODO: Add initializer
enum Coordinates {
    case Position (Int, Int)
    
    init(x:Int, y:Int) {
        case
    }
}

typealias Generation = (Coordinates) -> CellState
typealias NeighborsArray = [Coordinates]

// Leaf functions
func isAlive(cell: CellState) -> Bool {
    switch cell {
    case .Alive:
        return true
    case .Dead:
        return false
    }
}

func neighbors(pos: Coordinates) -> NeighborsArray {
    switch pos {
    case let .Position(x,y):
        return [Coordinates((x, y-1)), (x+1, y+1), (x+1, y), (x+1, y-1),
                (x-1, y), (x-1, y-1), (x, y+1), (x-1, y+1)]
    }
}

// Composing

func aliveNeighbors (generation: Generation, cellPosition: Coordinates) -> Int {
    return neighbors(cellPosition).map { generation($0) } .filter { pos in isAlive(pos) }.count
}


