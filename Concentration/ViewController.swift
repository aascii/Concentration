//
//  ViewController.swift
//  Concentration
//
//  Created by Jason Hayes on 1/16/18.
//  Copyright © 2018 aasciiworks. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var game: Concentration! = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)

    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }

    private(set) var flipCount: Int {
        get {
            return game.flipCount
        }
        set {
            game.flipCount = newValue
        }
    }

    @IBOutlet private weak var flipCountLabel: UILabel!

    private var gameScore: Int {
        return game.score
    }

    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet private var cardButtons: [UIButton]!

    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            flipCount += 1
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Error: chosen card was not in cardButtons")
        }
    }

    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let card = game.cards[index]
            let button = cardButtons[index]
            if card.isFaceUp {
                button.setTitle(getEmoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
        scoreLabel.text = "Score: \(gameScore)"
        flipCountLabel.text = "Flips: \(flipCount)"
    }

    private let emojiStartChoices: [String: [String]] =
        ["Spooky": ["👻", "🎃", "🍬", "🙀", "🦇", "😱", "🍭", "🍌", "😈"] ,
        "Animals": ["🐶", "🐰", "🐨", "🦊", "🐯", "🐷", "🐭", "🐻", "🦁"] ,
        "Sports": ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏓", "🏒", "🏹"] ,
        "Flags": ["🏴", "🏁", "🇨🇦", "🇮🇪", "🇨🇭", "🇰🇷", "🇳🇿", "🇺🇸", "🎌"] ,
        "Vehicles": ["🏎", "🚲", "🏍", "🚑", "🚒", "🚁", "🚂", "⛵️", "🚀"] ,
        "Food": ["🥑", "🍒", "🍉", "🍯", "🥜", "🥐", "🧀", "🥓", "🌶", "🍳"]]

    private var themeChoice: [String] {
        let themeKeys = Array(emojiStartChoices.keys)
        let emojiTheme = themeKeys[themeKeys.count.arc4random]
        return emojiStartChoices[emojiTheme]!
    }

    private lazy var emojiChoices = themeChoice

    private var emoji = [Int: String]()

    private func getEmoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }

        return emoji[card.identifier] ?? "?"
    }

    @IBAction private func startNewGame() {
        game = nil
        emojiChoices = themeChoice
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        updateViewFromModel()
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
