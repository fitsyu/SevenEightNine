//
//  ViewController.swift
//  SevenEightNine
//
//  Created by Fitsyu on 17/08/2018.
//  Copyright © 2018 o0o. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    // MARK: Outlets
    @IBOutlet weak var onOff: UISwitch!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func triggerUseCase(_ sender: UIButton)
    {
        let uc = App.useCase_TurningLampOnOff
        uc.userInterface = self
        uc.play()
    }
    
}


// MARK: User Interface
protocol UI
{
    func read() -> Bool
    
    func display(_ formattedOutput: String)
}
extension ViewController: UI
{
    func read() -> Bool {
        return onOff.isOn
    }
    
    func display(_ formattedOutput: String) {
        label.text = formattedOutput
    }
}




// MARK: BUSSINESS LOGIC
protocol Interaction
{
    func process(_ input: Bool) -> Bool
}
class I: Interaction
{
 
    internal func process(_ input: Bool) -> Bool
    {
        var result: Bool = false
        
        // complex processing logic
        if input == true && input != false || (input == !false)
        {
            result = true
        }
        else
        {
            result = false
        }
        
        return result
    }

}



// MARK: PRESENTATION
protocol Formatting
{
    func format(_ result: Bool) -> String
}
class P: Formatting
{
    internal func format(_ result: Bool) -> String
    {
        var textOut = ""
        
        if result == true
        {
            textOut = "On"
        }
        else
        {
            textOut = "Off"
        }
        
        return textOut
    }
}




// MARK: Conductor
protocol UseCase
{
    func play()
}
class TurningLampOnOff: UseCase
{
    var userInterface: UI?
    var interactor: Interaction?
    var formatter: Formatting?
    
    init(userInterface: UI?, interactor: Interaction?, formatter: Formatting?)
    {
        self.userInterface = userInterface
        self.interactor = interactor
        self.formatter = formatter
    }
    
    func play()
    {
        // MAKE SURE ALL PARTY ARE AVAILABLE
        guard
            userInterface != nil
                &&
            interactor != nil
                &&
            formatter != nil
        else {
            fatalError("make sure all party for this use case set correctly")
        }
        
        
        
        
        // GET INPUT
        let input = userInterface!.read()
        
        // PROCESS
        let output = interactor!.process(input)
        
        // FORMAT
        let niceOutput = formatter!.format(output)
        
        // DISPLAY
        userInterface!.display(niceOutput)
    }
}


class App
{
    
    // List use cases here as a property of this class
    
    static var useCase_TurningLampOnOff: TurningLampOnOff {
        // setup a use case
        let i = I()
        let p = P()
        let UC = TurningLampOnOff(userInterface: nil, interactor: i, formatter: p)
        return UC
    }
    
    
}

