//
//  RequestsTVC.swift
//  QBHacksApp
//
//  Created by Arya Tschand on 12/1/19.
//  Copyright © 2019 Arya Tschand. All rights reserved.
//

import UIKit
import Firebase

class RequestsTVC: UITableViewController {
    
    var labels: [String] = []
    var names: [String]  = []
    var pills: [String] = []
    var ref: DatabaseReference!
    
    @IBOutlet weak var RefreshBtn: UIBarButtonItem!
    
    @IBAction func RefreshClick(_ sender: Any) {
        refreshScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        refreshScreen()
    }
    
    func refreshScreen() {
        getData() {
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
        tableView.reloadData()
    }
    
    func getData(CompletionHandler: @escaping (Bool?, Error?) -> Void){
        do {
            let url = NSURL(string: "https://h2grow.herokuapp.com/api")!
            let request = NSMutableURLRequest(url: url as URL)
            request.httpMethod = "POST"
            
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONSerialization.data(withJSONObject: [""], options: .prettyPrinted)
            let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                
                self.ref.child("Requests").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let value = snapshot.value as? NSDictionary
                    for (key, values) in value! {
                        var verify = (values as! NSDictionary)["Requested"] as! Bool
                        if verify == true && self.names.contains(key as! String) == false{
                            var name = key as! String
                            var pill = (values as! NSDictionary)["Type"] as! String
                            self.names.append(name)
                            self.pills.append(pill)
                            self.labels.append("\(name) - \(pill)")
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return labels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "request", for: indexPath)

        cell.textLabel?.text = labels[indexPath.row]
        return cell
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Select" {
            let VerifyVC = segue.destination as! VerifyVC
            var selectedIndexPath = tableView.indexPathForSelectedRow
            VerifyVC.name = names[selectedIndexPath!.row]
            VerifyVC.pill = pills[selectedIndexPath!.row]
        }
    }
    

}
