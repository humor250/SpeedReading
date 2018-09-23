//
//  ViewController.swift
//  SpeedReading
//
//  Created by joanthan liu on 2018/8/29.
//  Copyright © 2018年 Butterfly Tech. All rights reserved.
//
import UIKit
import AVFoundation

class ReadingViewController: UIViewController {
    
    @IBOutlet weak var secondLabel: UILabel! {
        didSet {
            secondLabel.text = String(sliderValue) + " seconds"
        }
    }
    @IBOutlet weak var secondSlider: UISlider!
    var sliderValue = 5
    
    @IBAction func secondValueChanged(_ sender: UISlider) {
        sliderValue = Int(sender.value)
        secondLabel.text = "\(sliderValue)"
    }
    @IBOutlet weak var backgroundUIView: UIView!
    @IBOutlet weak var seqLabel: UILabel!
    @IBOutlet weak var slabel: UILabel!
    var isRunning = false
    
    @IBOutlet weak var translate: UIButton!
    @IBAction func translationButton(_ sender: UIButton) {
        translationLabel.text = Sentences.chinese[index-1]
    }
    @IBOutlet weak var translationLabel: UILabel!
    
    @IBOutlet weak var sound: UIButton!
    @IBAction func soundButton(_ sender: UIButton) {
        EmojiSays.shared.say(sentence: data[index-1])
    }
    
    @IBOutlet weak var control: UIButton!
    @IBAction func controlButton(_ sender: UIButton) {
        if sender.titleLabel?.text == "Start" {
            startReading()
            isRunning = true
            control.setTitle("Stop", for: .normal)
            translate.setTitle(" ", for: .normal)
            translationLabel.text = " "
            sound.setTitle(" ", for: .normal)
            secondLabel.isHidden = true
            secondSlider.isHidden = true
        }
        if sender.titleLabel?.text == "Stop" {
            stopAction()
        }
    }
    
    var data = Sentences.english
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //backgroundUIView.backgroundColor = UIColor.white
        control.setTitle("Start", for: .normal)
        translate.setTitle(" ", for: .normal)
        sound.setTitle(" ", for: .normal)
    }
    override func viewWillDisappear(_ animated: Bool) {
        stopAction()
    }
    
    private func stopAction() {
        myTimer.invalidate()
        isRunning = false
        translate.setTitle("Translate", for: .normal)
        sound.setTitle("Sound", for: .normal)
        secondLabel.isHidden = false
        secondSlider.isHidden = false
        control.setTitle("Start", for: .normal)
    }
    
    var myTimer = Timer()
    var index = 0
    
    func startReading() {
        myTimer = Timer.scheduledTimer(timeInterval: TimeInterval(sliderValue), target: self, selector: #selector(ReadingViewController.updateContentLabel), userInfo: nil, repeats: true)
    }

    @objc func updateContentLabel() {
        if index > data.count - 1 {
            myTimer.invalidate()
            isRunning = false
            index = 0
            seqLabel.text = " "
            slabel.text = "The End"
            control.setTitle("Start", for: .normal)
        } else {
            slabel.text = data[index]
            index += 1
            seqLabel.text = String(index)
        }
    }
    
    deinit {
        // ViewController going away.  Kill the timer.
        if myTimer.isValid {
            myTimer.invalidate()
        }
    }
}



