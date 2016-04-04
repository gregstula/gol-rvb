//: Playground - noun: a place where people can play

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
    return neighbors(position).map { generation($0) } .filter { isAlive($0) }.count
}


