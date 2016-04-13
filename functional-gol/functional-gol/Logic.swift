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

import AppKit

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
func isAlive (cell: CellState) -> Bool {
    switch cell {
    case .Alive:
        return true
    case .Dead:
        return false
    }
}

func neighbors (pos: Position) -> NeighborsArray {
    switch pos {
    case let .Position(x,y):
        return [Position (x: x+1, y: y+1), Position (x: x, y: y-1), Position (x: x+1, y: y),
                Position (x: x+1, y: y-1), Position (x: x-1, y: y), Position (x: x-1, y: y-1),
                Position (x: x-1, y: y+1), Position (x: x, y: y+1)]
    }
}

// Composing

func aliveNeighbors (generation: Generation, position: Position) -> Int {
    return neighbors (position).map { generation($0) } .filter { isAlive($0) } .count
}


func evolution (generation: Generation) -> Generation {
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


// Represents a generation
func blinker (position: Position) -> CellState {
    switch position {
    case .Position(1,2):
        return .Alive
    case .Position(2,2):
        return .Alive
    case .Position(3,2):
        return .Alive
    default:
        return .Dead
    }
}

// Represents a generation aka Position -> CellState
func glider (position: Position) -> CellState {
    switch position {
    case .Position(1,3):
        return .Alive
    case .Position(2,3):
        return .Alive
    case .Position(3,3):
        return .Alive
    case .Position(3,2):
        return .Alive
    case .Position(2,1):
        return .Alive
    default:
        return .Dead
    }
}

struct Time {
    // Used for pausing
    var frozen = false
    
    var previous: Generation
    
    var current: Generation {
        return evolution (previous)
    }
    
    mutating func next () {
        previous = current
    }
    
    mutating func pause () {
        frozen = !frozen
    }
    
    init (generation: Generation) {
        previous = generation
    }
    
}

typealias Row = [CellState]
typealias Space = [Row]

struct World {
    // Create a 90 by 90 Grid
    var space = Space (count: 90, repeatedValue:
        Row (count: 90, repeatedValue: .Dead))
    
    var time: Time
    
    private mutating func visualizeCell (generation: Generation, x: Int, y: Int) {
        switch (generation (Position (x: x, y: y))) {
        case .Alive:
            space[x][y] = .Alive
            print("#", terminator:"")
            
        case .Dead:
            print(" ", terminator:"")
        }
    }
    
    private mutating func visualizeLine (generation: Generation, y: Int) {
        Array (space.startIndex ... space.endIndex).map {
            x in visualizeCell (generation, x: x, y: y)
        }
        print(" ")
    }
    
    mutating func render () {
        Array (space.startIndex ... space.endIndex).map {
            y in visualizeLine (time.previous, y: y) }
    }
    
    init(generation: Generation) {
        time = Time (generation: generation)
    }
    
}

var world = World() { blinker($0) }

world.time.next()
world.render()

