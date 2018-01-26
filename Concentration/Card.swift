//
//  Card.swift
//  Concentration
//
//  Created by Jason Hayes on 1/18/18.
//  Copyright © 2018 aasciiworks. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var hashValue: Int { return identifier }

    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    var isFaceUp = false
    var isMatched = false
    var wasTouched = false
    private var identifier: Int

    private static var uniqueNumberFactory = 0

    private static func getUniqueNumber() -> Int {
        uniqueNumberFactory += 1
        return uniqueNumberFactory
    }

    init() {
        self.identifier = Card.getUniqueNumber()
    }
}
