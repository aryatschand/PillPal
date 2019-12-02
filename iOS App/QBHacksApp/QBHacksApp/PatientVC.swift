//
//  ViewController.swift
//  QBHacksApp
//
//  Created by Arya Tschand on 12/1/19.
//  Copyright © 2019 Arya Tschand. All rights reserved.
//

import UIKit
import CoreBluetooth
import QuartzCore
import Firebase
import LocalAuthentication


class PatientVC: UIViewController, BluetoothSerialDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    var nameArray = ["Arya", "Albert", "Eli", "Sai"]
    var ref: DatabaseReference!
    var redPositions: [Int] = []
    var bluePositions: [Int] = []
    var doctors: [String] = []
    
    var verified = false
    
    var selectedName = "Arya"
    
    func checkVerified(CompletionHandler: @escaping (Bool?, Error?) -> Void){
           do {
               let url = NSURL(string: "https://h2grow.herokuapp.com/api")!
               let request = NSMutableURLRequest(url: url as URL)
               request.httpMethod = "POST"
               
               request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
               request.httpBody = try JSONSerialization.data(withJSONObject: [""], options: .prettyPrinted)
               let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                   
                   self.ref.child("Requests").child("Arya").child("Doctors").observeSingleEvent(of: .value, with: { (snapshot) in
                       
                       // Get user value
                       
                       let value = snapshot.value as? NSDictionary
                       
                       for (key, values) in value! {
                        self.doctors.append(key as! String)

                           if values as! Bool == true {
                            self.verified = true
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
    
    
    func textViewScrollToBottom() {
        //let range = NSMakeRange(NSString(string: mainTextView.text).length - 1, 1)
        //mainTextView.scrollRangeToVisible(range)
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        reloadView()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud?.mode = MBProgressHUDMode.text
        hud?.labelText = "Disconnected"
        hud?.hide(true, afterDelay: 1.0)
    }
    
    func serialDidChangeState() {
        reloadView()
        if serial.centralManager.state != .poweredOn {
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud?.mode = MBProgressHUDMode.text
            hud?.labelText = "Bluetooth turned off"
            hud?.hide(true, afterDelay: 1.0)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedName = nameArray[row]
    }
    
    
    @IBOutlet weak var StatusLabel: UILabel!
    
    @IBAction func SendInfo(_ sender: Any) {
        //serial.sendMessageToDevice("1600,Arya,Blue")
        
        let myContext = LAContext()
        let myLocalizedReasonString = "Biometric Authntication testing !! "
        
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    
                    DispatchQueue.main.async {
                        if success {
                            // User authenticated successfully, take appropriate action
                            self.ref.child("Requests").child(self.selectedName).child("Requested").setValue(true)
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
            // Fallback on earlier versions
            
            print("Ooops!!.. This feature is not supported.")
        }
    }
    
    @IBOutlet weak var SendBtn: UIButton!
    
    @IBOutlet weak var Connect: UIBarButtonItem!
    
    func loadArrays() {
        
        self.ref.child("Positions").child("Red").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            
            for (key, values) in value! {
                if values as! Bool == true{
                    var str = key as! String
                    var lastInt = Int(String(str[str.index(before: str.endIndex)]))
                    self.redPositions.append(lastInt!)
                }
            }
        })
            
            self.ref.child("Positions").child("Blue").observeSingleEvent(of: .value, with: { (snapshot) in
            
            // Get user value
            
            let value = snapshot.value as? NSDictionary
            
            for (key, values) in value! {
                if values as! Bool == true{
                    var str = key as! String
                    var lastInt = Int(String(str[str.index(before: str.endIndex)]))
                    self.bluePositions.append(lastInt!)
                }
            }
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        serial = BluetoothSerial(delegate: self)
        loadArrays()
        self.PickerView.delegate = self
        self.PickerView.dataSource = self
        
        // UI
        //mainTextView.text = ""
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PatientVC.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
    }
    
    @IBAction func ConnectBtn(_ sender: Any) {
        if serial.connectedPeripheral == nil {
            performSegue(withIdentifier: "ShowScanner", sender: self)
        } else {
            serial.disconnect()
            reloadView()
        }
    }
    
    
    
    @IBAction func Refresh(_ sender: Any) {
        checkVerified() {
            (returnval, error) in
            if (returnval)!
            {
                DispatchQueue.main.async {
                    if self.verified == true {
                        self.StatusLabel.text = "Request Status - Accepted"
                        var pillName = ""
                        var position = 0
                        if self.selectedName == "Arya" {
                            pillName = "Blue"
                            if self.bluePositions.count > 0{
                                position = self.bluePositions[0]
                                self.bluePositions.remove(at: 0)
                            }
                        } else {
                            pillName = "Red"
                            if self.redPositions.count > 0{
                                position = self.redPositions[0]
                                self.redPositions.remove(at: 0)
                            }
                        }
                    serial.sendMessageToDevice("\(position),\(self.selectedName),\(pillName)")
                    self.ref.child("Requests").child(self.selectedName).child("Requested").setValue(false)
                        for x in 0...self.doctors.count-1{
                            self.ref.child("Requests").child(self.selectedName).child("Doctors").child(self.doctors[x]).setValue(false)
                        }
                        
                    }
                }
            } else {
                print(error)
            }
        }
        DispatchQueue.main.async { // Correct
        }
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
    
    @objc func reloadView() {
        // in case we're the visible view again
        if serial.isReady {
            Connect.title = "Disconnect"
            Connect.tintColor = UIColor.red
            Connect.isEnabled = true
            serial.sendMessageToDevice("initialize")
        } else if serial.centralManager.state == .poweredOn {
            Connect.title = "Connect"
            Connect.tintColor = view.tintColor
            Connect.isEnabled = true
            serial.sendMessageToDevice("DISCONNECT")
        } else {
            Connect.title = "Connect"
            Connect.tintColor = view.tintColor
            Connect.isEnabled = false
            serial.sendMessageToDevice("DISCONNECT")
        }
    }
    
}

