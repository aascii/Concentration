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

    /// Keeps track of whether we have only one face-up card (!nil), and if so, its identifier.
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
    private var startTime: Date?

    /// Turns chosen card face up if not already face up;  adjusts player score if second face up card.

    // currently this function is [complexity,length] = [12,42] and splitting would actually be less readable
    // swiftlint:disable:next cyclomatic_complexity function_body_length -
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in cards.")
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // player has just turned up a second face card
                // first record the current play clock value
                let currentTime = Date()
                let turnTime = currentTime.timeIntervalSince(startTime!)
                // check for match
                if cards[matchIndex].identifier == cards[index].identifier {
                    cards[index].isMatched = true
                    cards[matchIndex].isMatched = true
                    var scoreFactor: Int
                    switch turnTime {
                    case 0..<0.05:
                        scoreFactor = -1
                    case 0.05..<0.5:
                        scoreFactor = 4
                    case 0.5..<1.0:
                        scoreFactor = 2
                    default:
                        scoreFactor = 1
                    }
                    score += (2 * scoreFactor)
                } else {
                    // face up cards do not match
                    var scoreFactor: Int
                    switch turnTime {
                    case 0..<0.05:
                        scoreFactor = 4
                    case 0.05..<2.0:
                        scoreFactor = 1
                    default:
                        scoreFactor = 2
                    }
                    if cards[index].wasTouched {
                        score -= scoreFactor
                    } else {
                        cards[index].wasTouched = true
                    }
                    if cards[matchIndex].wasTouched {
                        score -= scoreFactor
                    } else {
                        cards[matchIndex].wasTouched = true
                    }
                }
                cards[index].isFaceUp = true
            } else {
                // player has just turned up a new unique face card
                indexOfOneAndOnlyFaceUpCard = index
                // start the turn clock
                startTime = Date()
            }
        } else {
            // player is clicking on a previously matched card, compensate for auto-increment
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
