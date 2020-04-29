//
//  ChooseRoleVC.swift
//  QBHacksApp
//
//  Created by Arya Tschand on 12/1/19.
//  Copyright © 2019 Arya Tschand. All rights reserved.
//

import UIKit
import AVFoundation

class SignIn: UIViewController {
    
    @IBOutlet weak var emailBox: UITextField!
    
    @IBOutlet weak var passwordBox: UITextField!
    
    var name: String = ""
    var response: String = ""
    var type: String = ""
    let synthesizer = AVSpeechSynthesizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
        
        let utterance = AVSpeechUtterance(string: "Please enter username and password to login to your account.")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.5

        
        synthesizer.speak(utterance)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func getStorage(value2: String) {
        printMessagesForUser(parameters: value2) {
            (returnval, error) in
            if (returnval)!
            {
                DispatchQueue.main.async {
                    print(self.response)
                               if self.response == "Valid User" {
                                   if self.type == "Manual Patient"{
                                       self.performSegue(withIdentifier: "manualpatient", sender: self)
                                   } else if self.type == "Doctor" {
                                       self.performSegue(withIdentifier: "doctor", sender: self)
                                   } else if self.type == "Automatic Patient" {
                                    self.performSegue(withIdentifier: "autopatient", sender: self)
                                }
                               } else {
                                   let alert = UIAlertController(title: "Incorrect Login", message: "The credentials you entered are incorrect", preferredStyle: .alert)
                                   let cancel = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                                   })
                                   alert.addAction(cancel)
                                   self.present(alert, animated: true, completion: nil)
                                   self.emailBox.text = ""
                                   self.passwordBox.text = ""
                               }
                }
            } else {
                print(error)
            }
        }
        DispatchQueue.main.async { // Correct
        }
    }
    
    func printMessagesForUser(parameters: String, CompletionHandler: @escaping (Bool?, Error?) -> Void){
        let json = [parameters]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            

            let url = NSURL(string: "https://2dd6e7b6.ngrok.io/website/signIn")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.setValue(emailBox.text, forHTTPHeaderField: "email")
            request.setValue(passwordBox.text, forHTTPHeaderField: "password")
            request.setValue("*", forHTTPHeaderField: "Origin")
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if let returned = String(data: data!, encoding: .utf8) {
                    let dict = returned.toJSON() as? [String:AnyObject] // can be any type here
                    self.response = dict!["data"] as! String
                    
                    if self.response == "Valid User" {
                        self.name = dict!["name"] as! String
                        self.type = dict!["user"] as! String
                    }
                    
                    CompletionHandler(true,nil)
                    
                    //self.Severity.text = "hello"
                } else {
                }
                
                //self.Severity.text = "test"
                
            }
            task.resume()
        } catch {
            
            print(error)
        }
    }
    
    @IBAction func submit(_ sender: Any) {
        getStorage(value2: "PillPal")
    }
    
    
    @IBAction func signup(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "https://saivedagiri.github.io/PillPal-Website/signup.html")! as URL)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "autopatient" {
           var AutoPatientVC = segue.destination as! AutoPatientVC
           AutoPatientVC.name = name
        } else if segue.identifier == "manualpatient" {
            var PatientVC = segue.destination as! PatientVC
            PatientVC.name = name
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
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

extension String {
    func toJSON() -> Any? {
        guard let data = self.data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}
