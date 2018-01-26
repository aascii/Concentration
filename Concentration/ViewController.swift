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

    private var gameScore: Int {
        return game.score
    }

    @IBOutlet weak var scoreLabel: UILabel!

    @IBOutlet private var cardButtons: [UIButton]!

    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            flipCount += 1
        } else {
            print("Error: chosen card was not in cardButtons")
        }
    }

    private func updateViewFromModel() {
        view.backgroundColor = themeChoice.screenBackground
        scoreLabel.backgroundColor = themeChoice.screenBackground
        scoreLabel.textColor = themeChoice.cardBackground
        startNewGameButton.backgroundColor = themeChoice.cardBackground
        startNewGameButton.setTitleColor(themeChoice.screenBackground, for: UIControlState.normal)
        for index in cardButtons.indices {
            let card = game.cards[index]
            let button = cardButtons[index]
            if card.isFaceUp {
                button.setTitle(getEmoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ?  #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : themeChoice.cardBackground
            }
        }
        scoreLabel.text = "Score: \(gameScore)"
    }

    // swiftlint:disable:next large_tuple - this tuple is exceedingly readable and crisp
    private let themeStartChoices: [String: (screenBackground: UIColor, cardBackground: UIColor, cardFaces: [String])] =
        ["Spooky": (#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1), ["👻", "🎃", "🍬", "🙀", "🦇", "😱", "🍭", "🍌", "😈"]) ,
        "Animals": (#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1), ["🐶", "🐰", "🐨", "🦊", "🐯", "🐷", "🐭", "🐻", "🦁"]) ,
        "Sports": (#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏓", "🏒", "🏹"]) ,
        "Flags": (#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.8727331606, green: 0.04212352713, blue: 0.03055944928, alpha: 1), ["🏴", "🏁", "🇨🇦", "🇮🇪", "🇨🇭", "🇰🇷", "🇳🇿", "🇺🇸", "🎌"]) ,
        "Vehicles": (#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), ["🏎", "🚲", "🏍", "🚑", "🚒", "🚁", "🚂", "⛵️", "🚀"]) ,
        "Food": (#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), ["🥑", "🍒", "🍉", "🍯", "🥜", "🥐", "🧀", "🥓", "🌶", "🍳"])]

    // swiftlint:disable:next large_tuple - this tuple is exceedingly readable and crisp
    private var randomTheme: (screenBackground: UIColor, cardBackground: UIColor, cardFaces: [String]) {
        let themeKeys = Array(themeStartChoices.keys)
        return themeStartChoices[themeKeys[themeKeys.count.arc4random]]!
    }

    private lazy var themeChoice = randomTheme

    private lazy var emojiChoices = themeChoice.cardFaces

    private var emoji = [Card: String]()

    private func getEmoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            emoji[card] = emojiChoices.remove(at: emojiChoices.count.arc4random)
        }

        return emoji[card] ?? "?"
    }

    @IBAction private func startNewGame() {
        startGame()
    }

    @IBOutlet weak var startNewGameButton: UIButton!

    private func startGame () {
        game = nil
        themeChoice = randomTheme
        emojiChoices = themeChoice.cardFaces
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        flipCount = 0
        updateViewFromModel()
    }

    private(set) var flipCount: Int {
        get {
            return game.flipCount
        }
        set {
            game.flipCount = newValue
            updateFlipCountLabel(newValue: newValue)
        }
    }

    private var startNewGameString: String?

    private func updateFlipCountLabel(newValue: Int) {
        let attributes: [NSAttributedStringKey: Any] = [
            .strokeWidth: 5.0,
            .strokeColor: themeChoice.cardBackground
        ]
        var attributedString: NSAttributedString
        if startNewGameString != nil {
            attributedString = NSAttributedString(string: "Flips: \(newValue)", attributes: attributes)
            flipCountLabel.backgroundColor = themeChoice.screenBackground
            flipCountLabel.attributedText = attributedString
        } else {
            flipCountLabel.text = "or touch any card"
            startNewGameString = "App just started"
        }

    }

    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel(newValue: flipCount)
        }
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
