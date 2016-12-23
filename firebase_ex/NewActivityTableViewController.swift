//
//  NewActivityTableViewController.swift
//  firebase_ex
//
//  Created by Apple Hsiao on 2016/12/23.
//  Copyright © 2016年 zeroplus. All rights reserved.
//

import UIKit
import Firebase

class NewActivityTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityName: UITextField!
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    @IBOutlet weak var place: UITextField!
    @IBOutlet weak var otherInfo: UITextView!
    
    var key: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let key = key {
            //read only one data
            let tryDatabase = FIRDatabase.database().reference()
            tryDatabase.child(key).observeSingleEvent(of: .value, with: {(snapshot) in
                if let postDict = snapshot.value as? Dictionary<String, String>{
                    self.activityName.text = postDict["name"]
                    self.startTime.text = postDict["startTime"]
                    self.endTime.text = postDict["endTime"]
                    self.place.text = postDict["place"]
                    self.otherInfo.text = postDict["otherInfo"]
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 6
    }
    
    @IBAction func donePressed(_ sender: Any) {
        
        let data = ["name": activityName.text!,
                    "startTime": startTime.text!,
                    "endTime": endTime.text!,
                    "place": place.text!,
                    "otherInfo": otherInfo.text!]
        let tryDatabase = FIRDatabase.database().reference()
        
        
        if let key = key{
            //edit
            tryDatabase.child(key).setValue(data)
        }else
        {
            //new data
            tryDatabase.childByAutoId().setValue(data)
        }
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //建立一個UIDatePicker
        let myDatePicker = UIDatePicker()
        
        //設置UIDatePickerMode
        myDatePicker.datePickerMode = .dateAndTime
        
        //設置時間顯示格式
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        //設置預設日期為今天或出發日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if (textField.tag == 2 && startTime.text != "") {
            
            let date = dateFormatter.date(from: startTime.text!)
            myDatePicker.date = date!
            
            textField.text = startTime.text
            
        }else if textField.tag == 1{
            myDatePicker.date = Date()
            textField.text = formatter.string(from: Date())
        }
        
        //設置顯示的語言環境
        myDatePicker.locale = Locale(identifier: "zh_TW")
        
        //設置改變日期時會執行的動作
        if textField.tag == 1{
            myDatePicker.addTarget(self, action: #selector(self.datePickerChanged), for: .valueChanged)
            textField.inputView = myDatePicker
        }else if textField.tag == 2{
            myDatePicker.addTarget(self, action: #selector(self.datePickerChanged2), for: .valueChanged)
            textField.inputView = myDatePicker
        }
        
    }
    
    func datePickerChanged(datePicker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        startTime.text = formatter.string(from: datePicker.date)
    }
    func datePickerChanged2(datePicker: UIDatePicker){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        endTime.text = formatter.string(from: datePicker.date)
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
