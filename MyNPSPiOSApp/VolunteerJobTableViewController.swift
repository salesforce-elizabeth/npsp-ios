//
//  VolunteerJobTableViewController.swift
//  MyNPSPiOSApp
//
//  Created by Elizabeth Martin on 7/19/18.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import Foundation
import UIKit
import SalesforceSDKCore
import SalesforceSwiftSDK
import PromiseKit
import os.log

var signedUpHours = [VolunteerJobHours]()
var loadedJobs = [VolunteerJob]()

class VolunteerJobTableViewController: UITableViewController {
    
    //Mark: Properties
    var jobs = [VolunteerJob]()
    var shiftsArray = [VolunteerJobShift]()
    var hoursArray = [VolunteerJobHours]()

    //Mark: root view controller copy
    var dataRows = [NSDictionary]()
    var shiftDataRows = [NSDictionary]()
    var hoursDataRows = [NSDictionary]()
    var numberOfJobs: Int = 0
    var numberOfShifts: Int = 0
    var numberOfHours: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Mark: Volunteer Job API Call
        let restApi = SFRestAPI.sharedInstance()
        restApi.Promises
            .query(soql: "SELECT Name, GW_Volunteers__Description__c, Id, Location__latitude__s, Location__longitude__s FROM GW_Volunteers__Volunteer_Job__c LIMIT 10")
            .then { request  in
                restApi.Promises.send(request: request)
            }.done { [unowned self] response in
                self.dataRows = response.asJsonDictionary()["records"] as! [NSDictionary]
                print(self.dataRows)
                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"request:didLoadResponse: #records: \(self.dataRows.count)")
                DispatchQueue.main.async(execute: {
                    self.tableView.reloadData()
                })
            }.catch { error in
                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"Error: \(error)")
        }
        
        //Mark: Volunteer Shift API call
        let shiftRestApi = SFRestAPI.sharedInstance()
        shiftRestApi.Promises
            .query(soql: "SELECT Name, GW_Volunteers__Start_Date_Time__c,End_Date__c, GW_Volunteers__Desired_Number_of_Volunteers__c, GW_Volunteers__Number_of_Volunteers_Still_Needed__c, GW_Volunteers__Volunteer_Job__c, Id FROM GW_Volunteers__Volunteer_Shift__c")
            .then { request  in
                shiftRestApi.Promises.send(request: request)
            }.done { [unowned self] response in
                self.shiftDataRows = response.asJsonDictionary()["records"] as! [NSDictionary]
                //print(self.shiftDataRows)
                print(self.shiftDataRows.count)
                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"request:didLoadResponse: #records: \(self.shiftDataRows.count)")
                DispatchQueue.main.async(execute: {
                })
            }.catch { error in
                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"Error: \(error)")
        }
        
        //Mark: Volunteer Hours API call
        let hoursRestApi = SFRestAPI.sharedInstance()
        hoursRestApi.Promises
            .query(soql: "SELECT Name, GW_Volunteers__Volunteer_Job__c, GW_Volunteers__Volunteer_Shift__c, GW_Volunteers__Contact__c, GW_Volunteers__Start_Date__c FROM GW_Volunteers__Volunteer_Hours__c WHERE GW_Volunteers__Volunteer_Shift__c != null")
            .then { request  in
                hoursRestApi.Promises.send(request: request)
            }.done { [unowned self] response in
                self.hoursDataRows = response.asJsonDictionary()["records"] as! [NSDictionary]
                print(self.hoursDataRows.count)
                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"request:didLoadHoursResponse: #records: \(self.hoursDataRows.count)")
                DispatchQueue.main.async(execute: {
                })
            }.catch { error in
                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"Error: \(error)")
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        shiftsArray.removeAll()
        hoursArray.removeAll()
        
        
    }

    
    /*
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    */

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataRows.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "JobTableViewCell"

        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? JobTableViewCell  else {
            fatalError("The dequeued cell is not an instance of JobTableViewCell.")
        }
        

        
        //MARK: root view controller implementation
        // Configure the cell to show the data.
        let obj = dataRows[indexPath.row]
        
        if obj["Name"] != nil {
            cell.volunteerJobLabel.text = obj["Name"] as? String
        } else {
            cell.volunteerJobLabel.text = "nil"
        }
        
        
        if let cellImage = UIImage(named: "VolJob"+"\(indexPath.row)") {
            cell.photoImageView.image = cellImage
        }
        
        

        /*
        // This adds the arrow to the right hand side.
        cell?.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        */
        
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
    

    
    //MARK: Private Methods
    private func loadVolunteerJobs() {
        
        numberOfJobs = dataRows.count
        for i in 0..<numberOfJobs {
            
            let jobref = dataRows[i]
            let photoi = UIImage(named: "VolJob\(i)")
            let jobNamei = jobref["Name"] as? String
            let jobDesci = jobref["GW_Volunteers__Description__c"] as? String
            let jobIdi = jobref["Id"] as? String
            let jobLatitudei = jobref["Location__Latitude__s"] as! Double
            let jobLongitudei = jobref["Location__Longitude__s"] as! Double
            guard let jobi = VolunteerJob(name: jobNamei!, photo: photoi, jobDescription: jobDesci!, jobId: jobIdi!, jobLatitude: jobLatitudei, jobLongitude: jobLongitudei) else {
                fatalError("Unable to instantiate job \(i)")
            }
            loadedJobs.append(jobi)
            jobs.append(jobi)
            print(jobs.count)
            print(dataRows[i])
        }
 
    }
    
    private func loadVolunteerShifts () {
        numberOfShifts = shiftDataRows.count
        for i in 0..<numberOfShifts {
            let shift = shiftDataRows[i]
            let shiftStartDateTime = shift["GW_Volunteers__Start_Date_Time__c"]
            let shiftEndDateTime = shift ["End_Date__c"]
            let volunteerJobId = shift["GW_Volunteers__Volunteer_Job__c"]
            let numberVolunteersStillNeeded = shift["GW_Volunteers__Number_of_Volunteers_Still_Needed__c"]
            let desiredNumberVolunteers = shift["GW_Volunteers__Desired_Number_of_Volunteers__c"]
            let shiftName = shift["Name"]
            let shiftId = shift["Id"]

            guard let shiftI = VolunteerJobShift(startDateTime: shiftStartDateTime! as! String, endDateTime: shiftEndDateTime! as! String, desiredNumberVolunteers: desiredNumberVolunteers as! Int, numberVolunteersStillNeeded: numberVolunteersStillNeeded as! Int, volunteerJobId: volunteerJobId! as! String, shiftName: shiftName! as! String, shiftId: shiftId! as! String) else {
                fatalError("Unable to instantiate shift")
            }
            
            shiftsArray.append(shiftI)
            print(shiftsArray.count)
            
        }
        
    }
    
    

    
    //Notes: Not yet working due to null values.
    private func loadVolunteerHours () {
        numberOfHours = hoursDataRows.count
        for i in 0..<numberOfHours {
                        
            // Variable assignment
            let hours = hoursDataRows[i]
            let volunteerShiftId = hours["GW_Volunteers__Volunteer_Shift__c"]
            
            if volunteerShiftId != nil {
            
                let hoursID = hours["Name"]
                let volunteerJobId = hours["GW_Volunteers__Volunteer_Job__c"]
                let volunteerId = hours["GW_Volunteers__Contact__c"]
                let startDate = hours["GW_Volunteers__Start_Date__c"]
            
                guard let hoursI = VolunteerJobHours(hoursID: hoursID! as! String, volunteerJobId: volunteerJobId as! String, volunteerShiftId: volunteerShiftId! as! String, volunteerId: volunteerId! as! String, startDate: startDate! as! String) else {
                    fatalError("Unable to instantiate hours")
                }
            
                hoursArray.append(hoursI)
                print(hoursArray.count)
            }
            
        }
        
        if signedUpHours.count < 1 {
            for i in 0..<hoursArray.count {
                if hoursArray[i].volunteerId == "003f200002RBqk6AAD" {
                    signedUpHours.append(hoursArray[i])
                }
            }
        }
            
        for i in 0..<signedUpHours.count {
            print("shift identifier:")
            print(signedUpHours[i].hoursID)
        }
        
        print("shifts signed up for:")
        print(signedUpHours.count)

        
        
    }
    
    //Notes
    /*
     var startDateTime: String
     var endDateTime: String
     var desiredNumberVolunteers: Int
     var numberVolunteersStillNeeded: Int
     var volunteerJobId: String
    */
    
    private func loadJobs() -> [VolunteerJob]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: VolunteerJob.ArchiveURL.path) as? [VolunteerJob]
    }
    
    
    //MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        loadVolunteerJobs()
        loadVolunteerShifts()
        loadVolunteerHours()
        
        switch(segue.identifier ?? "") {
            
        case "ShowDetail":
            guard let volunteerJobDetailViewController = segue.destination as? VolunteerJobDetailViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedVolunteerJobCell = sender as? JobTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedVolunteerJobCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedJob = jobs[indexPath.row]
            volunteerJobDetailViewController.job = selectedJob
            let targetId = selectedJob.jobId
            var selectedShifts = [VolunteerJobShift]()
            var selectedHours = [VolunteerJobHours]()
            
            //Pass selected shifts
            for i in 0..<numberOfShifts {
                if shiftsArray[i].volunteerJobId == targetId {
                    selectedShifts.append(shiftsArray[i])
                }
                print(selectedShifts.count)
            }
            
            volunteerJobDetailViewController.shifts = selectedShifts
            
            //Pass selected hours
            for i in 0..<signedUpHours.count {
                if signedUpHours[i].volunteerJobId == targetId {
                    selectedHours.append(signedUpHours[i])
                }
            }
            
            volunteerJobDetailViewController.jobHoursSignedUp = selectedHours
            
        
        case "mapview":
            guard let volunteerMapViewController = segue.destination as? MapViewController
                else {
                    fatalError("Unexpected destination: \(segue.destination)")
            }
            
            
        default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }

    
    
    
    

}
