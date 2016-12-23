//
//  ViewController.swift
//  firebase_ex
//
//  Created by Apple Hsiao on 2016/12/23.
//  Copyright © 2016年 zeroplus. All rights reserved.
//

import UIKit
import Firebase

class Act{
    var key: String = ""
    var name: String = ""
    var startTime: String = ""
    
    init(key: String, name: String, startTime: String){
        self.key = key
        self.name = name
        self.startTime = startTime
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //var data = [[String:Any]]()//Dictionary<String, Any>
    var data: [Act] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //ordering by startTime
        let ref = FIRDatabase.database().reference().queryOrdered(byChild: "startTime")

        ref.observeSingleEvent(of: .value, with: {(snapshot) in

            self.data = []
            
            //read multi data
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for snap in snapshots{
                        let tempData = snap.value as? Dictionary<String, String>
                    let key = snap.key
                    
                    let act = Act(key: key, name: tempData!["name"]!, startTime: tempData!["startTime"]!)
                    
                    self.data.append(act)
                }
                
            self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "detail") as! NewActivityTableViewController
        //go Detail
        controller.key = data[indexPath.row].key
        self.show(controller, sender: nil)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let ref = FIRDatabase.database().reference()
        let key = data[indexPath.row].key
        
        ref.child(key).removeValue()
        //remove data
        self.data.remove(at: indexPath.row)
        tableView.deleteRows(at:[indexPath], with: UITableViewRowAnimation.fade)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "list",
                                          for: indexPath)
        
        
        let seq = cell.contentView.viewWithTag(1) as! UILabel
        let startTime = cell.contentView.viewWithTag(2) as! UILabel
        let activity = cell.contentView.viewWithTag(3) as! UILabel

        
        seq.text = String(indexPath.row + 1)
        startTime.text = data[indexPath.row].startTime
        activity.text = data[indexPath.row].name
        
        
        return cell
    }


}

