//
//  ViewController.swift
//  RetroCalculator
//
//  Created by Ken Krippeler on 29.06.17.
//  Copyright © 2017 Lichtverbunden. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController
{
    var buttonSound: AVAudioPlayer!
    
    enum Operation: String
    {
        case Divide = "/"
        case Multiply = "*"
        case Subtract = "-"
        case Add = "+"
        case Empty = "Empty"
    }
    
    var currentOperation = Operation.Empty
    var runningNumber = ""
    var leftValueString = ""
    var rightValueString = ""
    var result = ""
    
    @IBOutlet weak var outputLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "btn", ofType: "wav")
        let soundURL = URL(fileURLWithPath: path!)
        
        do
        {
            try buttonSound = AVAudioPlayer(contentsOf: soundURL)
            buttonSound.prepareToPlay()
        }
        catch let err as NSError
        {
            print(err.debugDescription)
        }
        
        outputLabel.text = "0"
     
    }
    
    @IBAction func numberPressed(sender: UIButton)
    {
        playSound()
        
        runningNumber += "\(sender.tag)"
        outputLabel.text = runningNumber
    }
    
    @IBAction func onDividePressed(sender: Any)
    {
        processOperation(operation: .Divide)
    }
    
    @IBAction func onMultiplyPressed(sender: Any)
    {
        processOperation(operation: .Multiply)
    }
    
    @IBAction func onSubtractPressed(sender: Any)
    {
        processOperation(operation: .Subtract)
    }
    
    @IBAction func onAddPressed(sender: Any)
    {
        processOperation(operation: .Add)
    }
    
    @IBAction func onEqualPressed(sender: Any)
    {
        processOperation(operation: currentOperation)
    }
    
    func playSound()
    {
        if buttonSound.isPlaying
        {
            buttonSound.stop()
        }
        
        buttonSound.play()
    }
    
    func processOperation(operation: Operation)
    {
        playSound()
        
        if currentOperation != Operation.Empty
        {
            //A user selected an operator, but then selected another operator without first entering a number
            if runningNumber != ""
            {
                rightValueString = runningNumber
                runningNumber = ""
                
                if currentOperation == Operation.Multiply
                {
                    result = "\(Double(leftValueString)! * Double(rightValueString)!)"
                }
                else if currentOperation == Operation.Divide
                {
                    result = "\(Double(leftValueString)! / Double(rightValueString)!)"
                }
                else if currentOperation == Operation.Subtract
                {
                    result = "\(Double(leftValueString)! - Double(rightValueString)!)"
                }
                else if currentOperation == Operation.Add
                {
                    result = "\(Double(leftValueString)! + Double(rightValueString)!)"
                }
                
                leftValueString = result
                outputLabel.text = result
            }
            
            currentOperation = operation
        }
        else
        {
            //This is the first time an operator has been pressed
            leftValueString = runningNumber
            runningNumber = ""
            currentOperation = operation
        }
    }

}

