//
//  ScheduleVC.swift
//  QBHacksApp
//
//  Created by Arya Tschand on 4/25/20.
//  Copyright © 2020 Arya Tschand. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ScheduleVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBAction func submit(_ sender: Any) {
        getStorage(value2: "PillPal")
         _ = navigationController?.popViewController(animated: true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nameArray.count
    }
    
    var name: String = ""
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.medicinepicker.delegate = self
        self.medicinepicker.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData() {
            (returnval, error) in
            if (returnval)!
            {
                DispatchQueue.main.async {
                    print(self.nameArray)
                    self.medicinepicker.reloadAllComponents()
                }
            } else {
                print(error)
            }
        }
        DispatchQueue.main.async { // Correct
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nameArray[row]
    }
    
    var selectedName = ""
    
    var nameArray: [String] = []
    
    @IBOutlet weak var datepicker: UIDatePicker!
    @IBOutlet weak var medicinepicker: UIPickerView!
    
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
        selectedName = nameArray[row]
    }
    
    func getStorage(value2: String) {
        printMessagesForUser(parameters: value2) {
            (returnval, error) in
            if (returnval)!
            {
                DispatchQueue.main.async {
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
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let tosend = dateFormatter.string(from: datepicker.date)
            print(tosend)
            
            let url = NSURL(string: "https://2dd6e7b6.ngrok.io/iphone/newschedule")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            request.setValue(tosend, forHTTPHeaderField: "date")
            if selectedName == "" {
                selectedName = nameArray[0]
            }
            request.setValue(selectedName, forHTTPHeaderField: "pill")
            request.setValue(name, forHTTPHeaderField: "user")
            request.setValue("*", forHTTPHeaderField: "Origin")
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                
                
                //self.Severity.text = "test"
                
            }
            task.resume()
        } catch {
            
            print(error)
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
