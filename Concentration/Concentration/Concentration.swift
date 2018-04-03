//
//  Concentration.swift
//  Concentration
//
//  Created by Landon Epps on 3/27/18.
//  Copyright © 2018 Landon Epps. All rights reserved.
//

import Foundation

class Concentration {
    // let the UI get the cards, but we handle flipping in the Concentration class
    private(set) var cards = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            var foundIndex: Int?
            for index in cards.indices {
                if cards[index].isFaceUp {
                    if foundIndex == nil {
                        foundIndex = index
                    }
                    else {
                        return nil
                    }
                }
            }
            return foundIndex
        }
        set {
            // flip all cards down
            for index in cards.indices {
                // (index == newValue) evaluates to true for the card that is set
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    var flipCount = 0
    var score = 0
    // if true, the card at the corresponding index in "cards" has been seen
    var seen = [Bool]()
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index),
               "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if !cards[index].isMatched {
            // a card was chosen, so increment flipCount
            flipCount += 1
            
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // one card is face up and another is selected
                // check if cards match
                if cards[matchIndex].identifier == cards[index].identifier {
                    // match found, mark cards as matched
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    // add 2 to score
                    score += 2
                } else {
                    // no match was found, so deduct points if a card was seen before
                    if seen[index] == true {
                        score -= 1
                    }
                    if seen[matchIndex] == true {
                        score -= 1
                    }
                }
                cards[index].isFaceUp = true
                
                // mark both cards as seen
                seen[index] = true
                seen[matchIndex] = true
            } else {
                // either no cards or 2 cards are face up
                // use computed property to set card state
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0,
               "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
            // add corresponding bools to seen array
            seen += [false, false]
        }
        
        // MARK: Shuffle the cards
        var shuffledCards = [Card]()
        for _ in cards {
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            shuffledCards.append(cards.remove(at: randomIndex))
        }
        cards = shuffledCards
    }
}
