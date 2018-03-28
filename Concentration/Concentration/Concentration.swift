//
//  Concentration.swift
//  Concentration
//
//  Created by Landon Epps on 3/27/18.
//  Copyright © 2018 Landon Epps. All rights reserved.
//

import Foundation

class Concentration {
    var cards = [Card]()
    
    var indexOfOneAndOnlyFaceUpCard: Int?
    
    var flipCount = 0
    var score = 0
    // if true, the card at the corresponding index in "cards" has been seen
    var seen = [Bool]()
    
    func chooseCard(at index: Int) {
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
                indexOfOneAndOnlyFaceUpCard = nil
                
                // mark both cards as seen
                seen[index] = true
                seen[matchIndex] = true
            } else {
                // either no cards or 2 cards are face up
                // flip all cards down
                for flipDownIndex in cards.indices {
                    cards[flipDownIndex].isFaceUp = false
                }
                // flip over current selected card and save its index
                cards[index].isFaceUp = true
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
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
