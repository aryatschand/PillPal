//
//  ViewController.swift
//  QBHacksApp
//
//  Created by Arya Tschand on 12/1/19.
//  Copyright © 2019 Arya Tschand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import LocalAuthentication
import AVFoundation


class PatientVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nameArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nameArray[row]
    }
    
    @IBOutlet weak var PickerView: UIPickerView!
    
    var nameArray: [String] = []
    var ref: DatabaseReference!
    var redPositions: [Int] = []
    var bluePositions: [Int] = []
    var doctors: [String] = []
    var name = "Arya Tschand"
    let synthesizer = AVSpeechSynthesizer()
    
    var manual = false
    
    var verified = false
    
    var selectedName: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        getData() {
            (returnval, error) in
            if (returnval)!
            {
                DispatchQueue.main.async {
                    self.PickerView.reloadAllComponents()
                }
            } else {
                print(error)
            }
        }
        DispatchQueue.main.async { // Correct
        }
    }
    
    func getData(CompletionHandler: @escaping (Bool?, Error?) -> Void){
           do {
               let url = NSURL(string: "https://h2grow.herokuapp.com/api")!
               let request = NSMutableURLRequest(url: url as URL)
               request.httpMethod = "POST"
               
               request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
               request.httpBody = try JSONSerialization.data(withJSONObject: [""], options: .prettyPrinted)
               let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                   
                self.ref.child("Patients").child(self.name).observeSingleEvent(of: .value, with: { (snapshot) in
                       let value = snapshot.value as? NSDictionary
                       for (key, values) in value! {
                        if key as? String == "pills"{
                            let separatestring = values as? String
                            var temparr = separatestring!.components(separatedBy: ",")
                            if temparr.count > 0 {
                                self.nameArray = []
                                for x in 0...temparr.count-1{
                                    if temparr[x] != "" && temparr[x] != " "{
                                        self.nameArray.append(temparr[x])
                                    }
                                }
                            }
                            
                        }

                       }
                       CompletionHandler(true,nil)
                       
                   })
    
                   
               }
               task.resume()
           } catch {
               print(error)
           }
       }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if nameArray.count >= 1 {
            selectedName = nameArray[row]

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    
    @IBOutlet weak var StatusLabel: UILabel!
    
    @IBAction func SendInfo(_ sender: Any) {
        
        let myContext = LAContext()
        let myLocalizedReasonString = "Biometric Authntication testing !! "
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            if self.selectedName == "" {
                                self.selectedName = self.nameArray[0]
                            }
                            self.ref.child("Patients").child(self.name).child("requested").setValue(self.selectedName)
                            self.ref.child("Patients").child(self.name).child("fulfilled").setValue("waiting approval")
                            self.StatusLabel.text = "Requested Pill - \(self.selectedName)"
                            if self.manual == true {
                                self.manual = false
                                _ = self.navigationController?.popViewController(animated: true)
                            }
                        } else {
                            // User did not authenticate successfully, look at error and take appropriate action
                            print("Sorry!!... User did not authenticate successfully")
                        }
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
                print("Sorry!!.. Could not evaluate policy.")
            }
        } else {
             if self.selectedName == "" {
                 self.selectedName = self.nameArray[0]
             }
             self.ref.child("Patients").child(self.name).child("requested").setValue(self.selectedName)
             self.ref.child("Patients").child(self.name).child("fulfilled").setValue("waiting approval")
             self.StatusLabel.text = "Requested Pill - \(self.selectedName)"
             if self.manual == true {
                 self.manual = false
                 _ = self.navigationController?.popViewController(animated: true)
             }
        }
    }
    
    @IBOutlet weak var SendBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.PickerView.delegate = self
        self.PickerView.dataSource = self
        
        // UI
        //mainTextView.text = ""
        let utterance = AVSpeechUtterance(string: "Please select the desired medication that you want to request for. When you click the request button, move your face in front of the camera for Face ID authentication and your medicine will be sent for review.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5

        synthesizer.speak(utterance)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /*
    func newWord(CompletionHandler: @escaping (Bool?, Error?) -> Void){
        do {
            let url = NSURL(string: "https://h2grow.herokuapp.com/api")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: [""], options: .prettyPrinted)
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                randomNumberIndex = Int.random(in: 1 ..< 4)
                ref.child("\(randomNumberIndex)").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    word = value!["Word"] as! String
                    definition = value!["Definition" ] as! String
                    CompletionHandler(true,nil)
                    
                })
                
            }
            task.resume()
        } catch {
            print(error)
        }
    } */
    
    
}

