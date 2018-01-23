//
//  Concentration.swift
//  Concentration
//
//  Created by Jason Hayes on 1/18/18.
//  Copyright © 2018 aasciiworks. All rights reserved.
//

import Foundation

class Concentration {

    private(set) var cards = [Card]()

    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var countUpCards: Int?
            for index in cards.indices where cards[index].isFaceUp {
                if countUpCards == nil {
                    countUpCards = index
                } else {
                    return nil
                }
            }
            return countUpCards
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }

    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in cards.")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check for match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }

    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards): must have at least 1 pair.")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
            // TODO: shuffle cards
        }
    }
}
