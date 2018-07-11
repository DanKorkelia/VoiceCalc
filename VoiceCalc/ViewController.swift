//
//  ViewController.swift
//  VoiceCalc
//
//  Copyright © 2018 iOS London Meetup Hackathon. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVSpeechSynthesizerDelegate {
    
    var questioning = false
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var testButton: UIButton!
    
    @IBOutlet weak var checkButton: UIButton!
    var numberGenerator = arc4random()
    var correctAnswer: Int = 0
    
    let synth = AVSpeechSynthesizer()
    var welcome = "Welcome to the 2 plus 2."
    var currentString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        synth.delegate = self
        say(what: welcome)
        updateButtons()
    }
    
    func say(what text: String) {
        try? AVAudioSession.sharedInstance().setCategory(text)
        synth.speak(getUtterance(text: text))
    }
    
    fileprivate func randomNumbers()-> (first: Int, second:Int, result:Int) {
        let numberOne = Int(arc4random_uniform(99))
        let numberTwo = Int(arc4random_uniform(99))
        return ( numberOne , numberTwo, numberOne+numberTwo )
    }
    
    @IBAction func checkResult(_ sender: Any) {
        print(textField.text ?? "error")
        guard let answer = Int(textField.text!) else { return }
        
        if answer == correctAnswer {
            say(what: "You are a genius, Sir")
        } else {
            say(what:"You are a moron. Eat your vegetables")
        }
        questioning = false
        updateButtons()
    }
    
    fileprivate func updateButtons() {
        if questioning == true {
            testButton.isEnabled = false
            checkButton.isEnabled = true
        } else {
            testButton.isEnabled = true
            checkButton.isEnabled = false
        }
    }
    
    @IBAction func startButtonPresses(_ sender: Any) {
        questioning = true
        updateButtons()
        let test = randomNumbers()
        textField.text = ""
        
        correctAnswer = test.first + test.second
        speak(first: test.first, second: test.second)
        
        print("correct answer \(correctAnswer)")
    }
    
    fileprivate func speak(first: Int, second: Int){
        let text = "What is \(first) plus \(second)"
        say(what: text)
    }
    
    func getUtterance(text: String) -> AVSpeechUtterance {
        let voices = AVSpeechSynthesisVoice.speechVoices()
        for voice in voices {
            print(voice.identifier, "   " , voice.name, "   =   ", voice.language)
        }
        let utterance = AVSpeechUtterance(string: text)
        
        //change the voice /pitch / speed / language here
        //let samantha = AVSpeechSynthesisVoice(identifier: com.apple.ttsbundle.Samantha-compactLanguage.karen)
        //utterance.voice = samantha
        //...
        
        return utterance
    }
    
    
    //  SYNTH FUNCTIONS (eg called from @IBActions)
    //    synth.speak(utterance)
    //    synth.pauseSpeaking(at: .immediate)
    //    synth.continueSpeaking()
    //    synth.stopSpeaking(at: .word)
    
    
    //////////////////////  DELEGATE METHODS /////////////
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didPause utterance: AVSpeechUtterance) {
        print("Synth did pause")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("Synth did start")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("Synth did cancel")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("Synth did finish")
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didContinue utterance: AVSpeechUtterance) {
        print("Synth did continue")
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        guard let rangeInString = Range(characterRange, in: utterance.speechString) else {return}
        print("This string will be said : " , utterance.speechString[rangeInString].description)
    }
}

extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
