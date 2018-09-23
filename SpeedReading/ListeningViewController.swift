//
//  ListeningViewController.swift
//  SpeedReading
//
//  Created by joanthan liu on 2018/9/14.
//  Copyright © 2018年 Butterfly Tech. All rights reserved.
//

import UIKit
import AVFoundation

class ListeningViewController: UIViewController {

    let content = Sentences.english
    var index = 0
    //var isRunning = true
    var isAway = false
    
    @IBOutlet weak var seqLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var control: UIButton!
    @IBAction func controlButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Start" {
            //var index = 0
            sender.setTitle("Stop", for: .normal)
            //isRunning = true
            if synthesizer.isSpeaking {
                synthesizer.stopSpeaking(at: .immediate)
            } else if index < content.count {
                speakOnMain(content[index])
            } else {
                index = 0
            }
        }
        if sender.titleLabel?.text == "Stop" {
            stopSpeaking()
        }
    }
    
    private func stopSpeaking() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        control.setTitle("Start", for: .normal)
    }
    
    let synthesizer = AVSpeechSynthesizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        control.setTitle("Start", for: .normal)
        synthesizer.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopSpeaking()
    }
}

extension ListeningViewController: AVSpeechSynthesizerDelegate {

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        synthesizer.stopSpeaking(at: .word)
        index += 1
        if index < content.count {
            speakOnMain(content[index])
        } else {
            stopSpeaking()
            contentLabel.text = "The End"
            seqLabel.isHidden = true
        }
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, willSpeakRangeOfSpeechString characterRange: NSRange, utterance: AVSpeechUtterance) {
        let mutableAttributedString = NSMutableAttributedString(string: utterance.speechString)
        mutableAttributedString.addAttribute(.foregroundColor, value: UIColor.red, range: characterRange)
        contentLabel.attributedText = mutableAttributedString
    }
    
    private func speakOnMain(_ stringToSpeak: String) {
        let utterance = AVSpeechUtterance(string: stringToSpeak)
        DispatchQueue.main.async {
            self.seqLabel.text = String(self.index+1)
            self.contentLabel.attributedText = NSAttributedString(string: stringToSpeak)
            self.synthesizer.speak(utterance)
        }
    }
}
