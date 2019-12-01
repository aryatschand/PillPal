//
//  VerifyVC.swift
//  QBHacksApp
//
//  Created by Arya Tschand on 12/1/19.
//  Copyright © 2019 Arya Tschand. All rights reserved.
//

import UIKit
import Firebase

class VerifyVC: UIViewController {
    
    var name = ""
    var pill = ""
    var ref: DatabaseReference!
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var PillLabel: UILabel!
    
    @IBAction func YesClick(_ sender: Any) {
        print(name)
        self.ref.child("Requests").child(name).child("Doctors").child("Eli").setValue(true)
    }
    
    @IBAction func NoClick(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        NameLabel.text = "Patient Name - \(name)"
        PillLabel.text = "Pill Requested - \(pill)"
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
