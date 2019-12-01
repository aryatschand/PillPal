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

class PatientVC: UIViewController, BluetoothSerialDelegate {
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
    
    
    @IBAction func SendInfo(_ sender: Any) {
        serial.sendMessageToDevice("1000")
    }
    
    
    @IBOutlet weak var ConnectBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        serial = BluetoothSerial(delegate: self)
        
        // UI
        //mainTextView.text = ""
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(PatientVC.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
    }

    @IBAction func ConnectButton(_ sender: Any) {
        if serial.connectedPeripheral == nil {
            performSegue(withIdentifier: "ShowScanner", sender: self)
        } else {
            serial.disconnect()
            reloadView()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func printMessagesForUser(parameters: String, CompletionHandler: @escaping (Bool?, Error?) -> Void){
        let json = [parameters]
        print(json)
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            
            let url = NSURL(string: "https://h2grow.herokuapp.com/api")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                if String(data: data!, encoding: .utf8) != nil {
                    //global data string 123
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
    
    func serialDidReceiveString(_ message: String) {
        print(message)
        _ = message.components(separatedBy: ",")
        printMessagesForUser(parameters: message) {
            (returnval, error) in
            if (returnval)!
            {
                DispatchQueue.main.async {
                    //Do Stuff
                }
            } else {
                print(error)
            }
        }
        DispatchQueue.main.async { // Correct
        }
        
    }
    
    @objc func reloadView() {
        // in case we're the visible view again
        serial.delegate = self
        
        if serial.isReady {
            ConnectBtn.titleLabel!.text = "Disconnect"
            ConnectBtn.tintColor = UIColor.red
            ConnectBtn.isEnabled = true
            serial.sendMessageToDevice("initialize")
        } else if serial.centralManager.state == .poweredOn {
            ConnectBtn.titleLabel!.text = "Connect"
            ConnectBtn.tintColor = view.tintColor
            ConnectBtn.isEnabled = true
            serial.sendMessageToDevice("DISCONNECT")
        } else {
            ConnectBtn.titleLabel!.text = "Connect"
            ConnectBtn.tintColor = view.tintColor
            ConnectBtn.isEnabled = false
            serial.sendMessageToDevice("DISCONNECT")
        }
    }
    
}

