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
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var gameScoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
        updateViewFromModel()
        emojiChoices = nil
        theme = nil
    }
    
    
    func updateViewFromModel() {
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
    
    let themes = [["🦇", "😱", "🙀", "😈", "🎃", "👻", "🍭", "🍬", "🍎"],
                  ["🐶", "🐴", "🐧", "🦁", "🦊", "🐠", "🐮", "🐷", "🐵"],
                  ["🍎", "🍑", "🍒", "🥝", "🍋", "🍉", "🍓", "🍌", "🍊"],
                  ["🌮", "🌯", "🍱", "🍔", "🌭", "🍕", "🍳", "🥪", "🍝"],
                  ["⚽️", "🏀", "🏈", "⚾️", "🎾", "🏐", "🏉", "🏸", "🏓"],
                  ["🇯🇵", "🇺🇸", "🇰🇷", "🇬🇷", "🇨🇳", "🇸🇪", "🇨🇭", "🇳🇵", "🇩🇪"]]
    var emojiChoices: [String]!
    var emoji = [Int:String]()
    var theme: Int?

    func emoji(for card: Card) -> String {
        if emojiChoices == nil {
            // arrays are value types in swift
            emojiChoices = themes[Int(arc4random_uniform(UInt32(themes.count)))]
        }
        
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
            let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
            emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        
        // we could do if let or even this:
//        if emoji[card.identifier] != nil {
//            return emoji[card.identifier]!
//        } else {
//            return "?"
//        }
        // but this is another way to write it
        // return optional, but if nil return this other thing
        return emoji[card.identifier] ?? "?"
    }
    
    
}
