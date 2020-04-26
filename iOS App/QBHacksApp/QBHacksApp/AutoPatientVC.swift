//
//  AutoPatientVC.swift
//  QBHacksApp
//
//  Created by Arya Tschand on 4/25/20.
//  Copyright © 2020 Arya Tschand. All rights reserved.
//

import UIKit
import AVFoundation

class AutoPatientVC: UIViewController {
    var name = ""
    
    @IBOutlet weak var textview: UITextView!
    
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let utterance = AVSpeechUtterance(string: "You are currently signed in as an automatic patient and all pill requests will be made automatically by your doctor. If you need to make a manual request, please click the button below.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5

        
        synthesizer.speak(utterance)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        textview.text = "Thank you for using PillPal, \(name). You are currently signed in as an automatic patient and all pill requests will be scheduled by your doctor. If you need to make a manual request, please click the button below."
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           // Get the new view controller using segue.destination.
           // Pass the selected object to the new view controller.
           if segue.identifier == "manualrequest" {
               let PatientVC = segue.destination as! PatientVC
               PatientVC.name = name
            PatientVC.manual = true
           }
       }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
