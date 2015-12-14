//
//
//  Created by Dari on 12/10/15.
//  Copyright (c) 2015 Dari. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    
    //data dictionary [String: [String]]
    var parents = [String:[String]]()
    
    //array to store which section is expanded currently
    var expandedStateOfSection = [Bool]()
    
    
    //parent cell (section header cell) identifer: this cell will be the section header
    let parentCellIdentifier = "parentCell"
    
    //child cell identifier: this cell will be the cells inside the section
    let childCellIdentifier = "childCell"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set data in dictionary
        //manually inserting 5 keys with data i.e. there will be 5 sections
        for i in 1...5 {
            
            println(i)
            let rowsOfSection = ["s \(i)","d \(i)","f \(i)","g \(i)","h \(i)","j \(i)"]
            
            parents["Section \(i)"] = rowsOfSection
            
            //tried to make little distinct data this code can be used: parents = 
            //["secB":["x","c","v","b","n"],"secC":["w","e","r","t","y","u"], "secD":["wz","ez","rz","tz","yz","uz"], "secE":["wzz","ezz","rzz","tzz","yzz","uzz"]]
        }
        
        //set all sections expanded = false at initial
        for parent in parents {
            expandedStateOfSection.append(false)
        }
        
        //remove empty cells below the required cells table view
        self.tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return parents.count
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        //get cell to be a section header
        let cell = tableView.dequeueReusableCellWithIdentifier(parentCellIdentifier) as! UITableViewCell
        
        //manipulate data of the cell
        cell.textLabel?.text = parents.keys.array[section]
        
        //keep tapped gesture in the header view i.e. cell that we extracted in this case
        //when the header is tapped the function with idenfifier in action parameter is called which is defined at the end
        let tappedGesture = UITapGestureRecognizer(target: self, action: "headerTapped:")
        cell.addGestureRecognizer(tappedGesture)
        
        //give cell a tag for distinct
        cell.tag = section
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //get keys of the dictionary
        let keys = parents.keys.array
        
        //count number of data inside that key
        if let count = parents[keys[section]]?.count {
            
            //if the section is expanded then return the count
            if expandedStateOfSection[section] {
                return count
            }
        }
        //else return 0
        return 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //get cell for each row
        let cell = tableView.dequeueReusableCellWithIdentifier(childCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        //manipulate data in the cell
        cell.textLabel?.text = "child row: \(indexPath.row) in sec \(indexPath.section)"
        
        
        return cell
    }
    
    func headerTapped (recognizer: UITapGestureRecognizer) {
        //get which section is tapped (we gave unique tag to each section)
        let section = recognizer.view!.tag
        
        //get keys of the data dictionary
        let keys = parents.keys.array
        
        //know if the section is expanded or not
        let expanded = expandedStateOfSection[section]
        
        //change the state of expansion (if expanded then true, if not expanded then false) i.e. reverse the value
        expandedStateOfSection[section] = !expanded

        //if the selected section has data inside it assign it in children which is now a array if data exists
        if let children = parents[keys[section]] {
            
            //indexpaths for deleting or inserting later
            var indexpaths = [NSIndexPath]()
            
            //make indexpaths ready by counting the number of data(row) inside the key
            for var i = 0 ; i < children.count ; i++ {
                //append indexpaths in array
                indexpaths.append(NSIndexPath(forRow: i, inSection: section))
            }
            
            
            //begin transaction thread
            CATransaction.begin()
            
            //begin table update
            tableView.beginUpdates()
            
            //task to do after transaction (thread is completed) ##1
            CATransaction.setCompletionBlock({
                
                //reload tableview
                self.tableView.reloadData()
            })

            
            //if the section is expanded == true
            if expanded {
                
                //delete rows if the section is already expanded
                tableView.deleteRowsAtIndexPaths(indexpaths, withRowAnimation: UITableViewRowAnimation.None)
                
            }else {
                //insert rows if the section is collapsed
                tableView.insertRowsAtIndexPaths(indexpaths, withRowAnimation: UITableViewRowAnimation.None)
            }
            
            //end table update
            tableView.endUpdates()
            
            //commit transaction: after this statement the task inside ##1 gets executed in same thread
            CATransaction.commit()
        }
    }
    
}
