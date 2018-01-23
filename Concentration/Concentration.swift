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

    var flipCount = 0
    private(set) var score = 0

    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in cards.")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check for match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    score += 2
                } else {
                    if cards[index].wasTouched {
                        score -= 1
                    } else {
                        cards[index].wasTouched = true
                    }
                    if cards[matchIndex].wasTouched {
                        score -= 1
                    } else {
                        cards[matchIndex].wasTouched = true
                    }
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        } else {
            flipCount -= 1
        }
    }

    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards): must have at least 1 pair.")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards.shuffle()
    }
}

extension MutableCollection {
    /// Shuffles the elements of this collection
    mutating func shuffle() {
        let shuffleCount = count
        guard shuffleCount > 1 else {return}

        for (firstUnShuffled, unShuffledCount) in zip(indices, stride(from: shuffleCount, to: 1, by: -1)) {
            let distanceToMove = Int(unShuffledCount).arc4random
            let swapIndex = index(firstUnShuffled, offsetBy: IndexDistance(distanceToMove))
            swapAt(firstUnShuffled, swapIndex)
        }
    }
}
