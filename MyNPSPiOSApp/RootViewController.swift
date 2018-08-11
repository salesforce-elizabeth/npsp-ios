


import Foundation
import UIKit
import SalesforceSDKCore
import SalesforceSwiftSDK
import PromiseKit

class RootViewController : UITableViewController
{
    var dataRows = [NSDictionary]()
    
    // MARK: - View lifecycle
    override func loadView()
    {
        super.loadView()
        self.title = "Volunteering Jobs"
        self.tableView.rowHeight = 90.0
        let restApi = SFRestAPI.sharedInstance()
        restApi.Promises
        .query(soql: "SELECT Name FROM GW_Volunteers__Volunteer_Job__c LIMIT 10")
        .then {  request  in
            restApi.Promises.send(request: request)
        }.done { [unowned self] response in
            self.dataRows = response.asJsonDictionary()["records"] as! [NSDictionary]
            SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"request:didLoadResponse: #records: \(self.dataRows.count)")
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }.catch { error in
             SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"Error: \(error)")
        }
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView?, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataRows.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cellIdentifier = "CellIdentifier"
        
        // Dequeue or create a cell of the appropriate type.
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier:cellIdentifier)
        if (cell == nil)
        {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
                
        // If you want to add an image to your cell, here's how.
        let image = UIImage(named: "VolJob"+"\(indexPath.row)")
        cell!.imageView!.image = image
        
        // Configure the cell to show the data.
        let obj = dataRows[indexPath.row]
        cell!.textLabel!.text = obj["Name"] as? String
        
        // This adds the arrow to the right hand side.
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell!
    }
}
