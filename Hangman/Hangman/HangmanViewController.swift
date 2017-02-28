//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class HangmanViewController: UIViewController {


    @IBOutlet weak var hangmanImage: UIImageView!
    @IBOutlet weak var blanksLabel: UILabel!
    @IBOutlet weak var incorrectGuessesLabel: UILabel!
    
    var letter = ""
    var currLetterButton : UIButton? = nil
    var phrase = ""
    var phraseLength = 0
    var numIncorrectGuesses = 0
    let maxIncorrectGuesses = 6
    var guessesSoFar = Set<String>()
    var displayString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hangmanPhrases = HangmanPhrases()
        // Generate a random phrase for the user to guess
        phrase = hangmanPhrases.getRandomPhrase()
        phraseLength = phrase.characters.count
        print(phrase)
        
        resetGameValues()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func resetGameValues() {
        letter = ""
        numIncorrectGuesses = 0
        guessesSoFar = Set<String>()
        displayString = ""
        incorrectGuessesLabel.text? = "Incorrect Guesses: "
        hangmanImage.image = UIImage(named: "hangman1")
        
        displayInitialDashes()
    }
    
    func displayInitialDashes() {
        for pos in 0..<phraseLength {
            if Array(phrase.characters)[pos] == " " {
                displayString += " "
            } else {
                displayString += "-"
            }
        }
        updateDisplayString()
    }
    
    func updateDisplayString() {
        blanksLabel.text = displayString
    }
    
    func addCorrectLetter() {
        var indices = [Int]()
        for pos in 0..<phraseLength {
            if Array(phrase.characters)[pos] == Character(letter) {
                indices += [pos]
            }
        }
        
        var chars = Array(displayString.characters)
        for index in indices {
            chars[index] = Character(letter)
        }
        displayString = String(chars)
    }
    
    func addIncorrectLetter() {
        incorrectGuessesLabel.text? += " " + letter
    }
    
    func updateImage() {
        let imageName = "hangman" + String(numIncorrectGuesses + 1)
        hangmanImage.image = UIImage(named: imageName)
    }
    
    func allCorrectLettersGuessed() -> Bool {
        return displayString.lowercased() == phrase.lowercased()
    }
    
    func youWinAlert() {
        let alertController = UIAlertController(title: "You win!", message: "Congratulations! The phrase was " + phrase, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "New game", style: UIAlertActionStyle.default, handler: newGameActionHandler))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func youLoseAlert() {
        let alertController = UIAlertController(title: "You lose!", message: "The correct phrase was " + phrase, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "New game", style: UIAlertActionStyle.default, handler: newGameActionHandler))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func newGameActionHandler(alert: UIAlertAction!) {
        viewDidLoad()
    }
    
    @IBAction func newGameButtonWasPressed(_ sender: UIBarButtonItem) {
        viewDidLoad()
    }
    
    @IBAction func letterButtonWasPressed(_ sender: UIButton) {
        if let button = currLetterButton {
            button.backgroundColor = UIColor.white
        }
        currLetterButton = sender
        currLetterButton!.backgroundColor = UIColor.lightGray
        if let label = sender.titleLabel {
            if let text = label.text {
                letter = text
            }
        }
    }

    @IBAction func guessButtonWasPressed(_ sender: UIButton) {
        if let button = currLetterButton {
            button.backgroundColor = UIColor.white
        }
        if letter != "" && !guessesSoFar.contains(letter) {
            self.guessesSoFar.insert(letter)
        
            if phrase.range(of:letter) != nil && !allCorrectLettersGuessed() {
                addCorrectLetter()
                updateDisplayString()
            } else if numIncorrectGuesses <= maxIncorrectGuesses {
                numIncorrectGuesses += 1
                addIncorrectLetter()
                updateImage()
            }
            
            if allCorrectLettersGuessed() {
                // pop up you win box
                youWinAlert()
            }
            
            if numIncorrectGuesses == maxIncorrectGuesses {
                // pop up you lose box
                updateImage()
                youLoseAlert()
//                let when = DispatchTime.now() + 0.5
//                DispatchQueue.main.asyncAfter(deadline: when) {
//                    self.youLoseAlert()
//                    self.viewDidLoad()
//                }
            }
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
