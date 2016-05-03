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
    return neighbors (position).lazy.map { generation($0) }.lazy.filter { isAlive($0) }.lazy.count
}


func evolution (generation: Generation) -> Generation {
    return { position in
        let result = aliveNeighbors(generation, position: position)
        switch result {
        case 2:
            return generation(position)
        case 3:
            return .Alive
        default:
            return .Dead
        }
    }
    
}


// Visualizing


// Represents a generation
func blinker (startingPoint: Int) -> (Position -> CellState) {
    return { (position: Position) -> CellState in
        let s = startingPoint
        switch position {
        case .Position(s + 1, s + 2):
            return .Alive
        case .Position(s + 2, s + 2):
            return .Alive
        case .Position(s + 3, s + 2):
            return .Alive
        default:
            return .Dead
        }
    }
}

// Represents a generation aka Position -> CellState
func glider (startingPoint: Int, position: Position) -> CellState {
    let s = startingPoint
    
    switch position {
    case .Position(s - 1,s - 3):
        return .Alive
    case .Position(s - 2,s - 3):
        return .Alive
    case .Position(s - 3,s - 3):
        return .Alive
    case .Position(s - 3,s - 2):
        return .Alive
    case .Position(s - 2,s - 1):
        return .Alive
    default:
        return .Dead
    }
}

class Time {
    var previous: Generation
    
    var current: Generation {
        return evolution (previous)
    }
    
    func next() {
        previous = current
    }
    
    init (generation: Generation) {
        previous = generation
    }
    
}

typealias Row = [CellState]
typealias Space = [Row]

class World {
    // Create a 90 by 90 Grid
    var space = Space (count: 90, repeatedValue:
        Row (count: 90, repeatedValue: .Dead))
    
    var time: Time
    
    private func visualizeCell (generation: Generation, x: Int, y: Int) {
        switch (generation (Position (x: x, y: y))) {
        case .Alive:
            space[x][y] = .Alive
            print("#", terminator:"")
            
        case .Dead:
            print(" ", terminator:"")
        }
    }
    
    private func visualizeLine (generation: Generation, y: Int) {
        for x in space.startIndex ... space.endIndex {
            self.visualizeCell (generation, x: x, y: y)
        }
        print(" ")
    }
    
    func render () {
        for y in space.startIndex ... space.endIndex {
            visualizeLine (time.previous, y: y)
        }
    }
    
    init(generation: Generation) {
        time = Time (generation: generation)
    }
    
}

var world = World() { blinker(0)($0) }

while true {
    world.time.next()
    world.render()
}
