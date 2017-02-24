//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var blanksLabel: UILabel!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    
    var letter = ""
    var phrase = ""
    var phraseLength = 0
    var displayString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hangmanPhrases = HangmanPhrases()
        // Generate a random phrase for the user to guess
        phrase = hangmanPhrases.getRandomPhrase()
        phraseLength = phrase.characters.count
        print(phrase)
        
        displayInitialDashes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func displayInitialDashes() {
        for _ in 0..<phraseLength {
            displayString += "-"
        }
        updateDisplayString()
    }
    
    func updateDisplayString() {
        blanksLabel.text = displayString
    }
    
    func addCorrectLetter() {
        let range: Range<String.Index> = phrase.range(of: letter)!
        let indexOfLetter: Int = phrase.distance(from: phrase.startIndex, to: range.lowerBound)

        var chars = Array(phrase.characters)  // gets an array of characters
        chars[indexOfLetter] = Character(letter)
        displayString = String(chars)

    }
    
    func addIncorrectLetter() {
        incorrectGuessesLabel.text? += " " + letter
    }
    
    @IBAction func letterButtonWasPressed(_ sender: UIButton) {
        if let label = sender.titleLabel {
            if let text = label.text {
                letter = text
            }
        }
    }

    @IBAction func guessButtonWasPressed(_ sender: UIButton) {
        if phrase.range(of:letter) != nil{
            // display on screen
            addCorrectLetter()
            updateDisplayString()
        } else {
            addIncorrectLetter()
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
