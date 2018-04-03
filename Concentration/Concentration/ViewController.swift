//
//  ViewController.swift
//  Concentration
//
//  Created by Landon Epps on 3/26/18.
//  Copyright © 2018 Landon Epps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // if we can't use lazy (property observers) make implicitly unwrapped optional
    // and init in one of the system functions that run after properties are init'd
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    // this is already get only so we don't need private(set)
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private weak var gameScoreLabel: UILabel!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction private func newGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        updateViewFromModel()
        emojiChoices = nil
        theme = nil
    }
    
    private func updateViewFromModel() {
        // indices returns countable range of array
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
        flipCountLabel.text = "Flips: \(game.flipCount)"
        gameScoreLabel.text = "Score: \(game.score)"
    }
    
    private let themes = [["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"],
                          ["🐶", "🐴", "🐧", "🦁", "🦊", "🐠", "🐮", "🐷", "🐵"],
                          ["🍎", "🍑", "🍒", "🥝", "🍋", "🍉", "🍓", "🍌", "🍊"],
                          ["🌮", "🌯", "🍱", "🍔", "🌭", "🍕", "🍳", "🥪", "🍝"],
                          ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🏸", "🏓"],
                          ["🇯🇵", "🇺🇸", "🇰🇷", "🇬🇷", "🇨🇳", "🇸🇪", "🇨🇭", "🇳🇵", "🇩🇪"]]
    private var emojiChoices: [String]!
    private var emoji = [Int:String]()
    private var theme: Int?

    private func emoji(for card: Card) -> String {
        if emojiChoices == nil {
            // arrays are value types in swift
            emojiChoices = themes[Int(arc4random_uniform(UInt32(themes.count)))]
        }
        
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            emoji[card.identifier] = emojiChoices.removeFirst()
        }
        
        // but this is another way to write it
        // return optional, but if nil return this other thing
        return emoji[card.identifier] ?? "?"
    }
}
