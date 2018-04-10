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
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }
    
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
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
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
        
        updateFlipCountLabel()
        gameScoreLabel.text = "Score: \(game.score)"
    }
    
    private let themes = ["🦇😱🙀😈🎃👻🍭🍬🍎",
                          "🐶🐴🐧🦁🦊🐠🐮🐷🐵",
                          "🍎🍑🍒🥝🍋🍉🍓🍌🍊",
                          "🌮🌯🍱🍔🌭🍕🍳🥪🍝",
                          "⚽️🏀🏈⚾️🎾🏐🏉🏸🏓",
                          "🇯🇵🇺🇸🇰🇷🇬🇷🇨🇳🇸🇪🇨🇭🇳🇵🇩🇪"]
    private var emojiChoices: String!
    private var emoji = [Card:String]()
    private var theme: Int?

    private func emoji(for card: Card) -> String {
        if emojiChoices == nil {
            // arrays are value types in swift
            emojiChoices = themes[Int(arc4random_uniform(UInt32(themes.count)))]
        }
        
        if emoji[card] == nil, emojiChoices.count > 0 {
            // if we were to randominze it, we'd use
            // let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            // emoji[card] = String(emojiChoices.remove(at: randomStringIndex)
            emoji[card] = String(emojiChoices.removeFirst())
        }
        
        // return optional, but if nil return this other thing
        return emoji[card] ?? "?"
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
