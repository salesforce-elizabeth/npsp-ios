//
//  VolunteerJob.swift
//  MyNPSPiOSApp
//
//  Created by Elizabeth Martin on 7/19/18.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import Foundation
import UIKit
import os.log
import SalesforceSDKCore
import SalesforceSwiftSDK
import PromiseKit

class VolunteerJob: NSObject, NSCoding {
    
    var dataRows = [NSDictionary]()
    
    //Mark: Properties
    var name: String
    var photo: UIImage?
    var jobDescription: String
    var jobId: String
    var jobLatitude: Double
    var jobLongitude: Double
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("volunteerjobs")
    
    //Mark: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let jobDescription = "jobDescription"
        static let jobId = "jobId"
        static let jobLatitude = "jobLatitude"
        static let jobLongitude = "jobLongitude"

    }
    
    
    //Mark: Initialization
    
    init?(name:String, photo:UIImage?, jobDescription:String, jobId:String, jobLatitude:Double, jobLongitude:Double) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialization should fail if there is no name
        if name.isEmpty {
            return nil
        }
        
        //Initialize stored properties
        self.name = name
        self.photo = photo
        self.jobDescription = jobDescription
        self.jobId = jobId
        self.jobLatitude = jobLatitude
        self.jobLongitude = jobLongitude
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(jobDescription, forKey: PropertyKey.jobDescription)
        aCoder.encode(jobId, forKey: PropertyKey.jobId)
        aCoder.encode(jobLatitude, forKey: PropertyKey.jobLatitude)
        aCoder.encode(jobLongitude, forKey: PropertyKey.jobLongitude)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Volunteer Job object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of VolunteerJob, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        guard let jobDescription = aDecoder.decodeObject(forKey: PropertyKey.jobDescription) as? String else {
            os_log("Unable to decode the description for a Volunteer Job object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let jobId = aDecoder.decodeObject(forKey: PropertyKey.jobId) as? String else {
            os_log("Unable to decode the Id for a Volunteer Job object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let jobLatitude = aDecoder.decodeObject(forKey: PropertyKey.jobLatitude) as? Double else {
            os_log("Unable to decode the latitude for a Volunteer Job object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let jobLongitude = aDecoder.decodeObject(forKey: PropertyKey.jobLongitude) as? Double else {
            os_log("Unable to decode the longitude for a Volunteer Job object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, jobDescription: jobDescription, jobId: jobId, jobLatitude: jobLatitude, jobLongitude: jobLongitude)
        
    }
    
    /*
    //Mark: Retrieve Data
    private func getVolunteerJobs () {
        let restApi = SFRestAPI.sharedInstance()
        restApi.Promises
            .query(soql: "SELECT Name FROM GW_Volunteers__Volunteer_Job__c LIMIT 10")
            .then {  request  in
                restApi.Promises.send(request: request)
            }.done { [unowned self] response in
                self.dataRows = response.asJsonDictionary()["records"] as! [NSDictionary]
                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"request:didLoadResponse: #records: \(self.dataRows.count)")
                DispatchQueue.main.async(execute: {
                    // COMMENTED OUT - self.tableView.reloadData()
                    /*
                    for Name in self.dataRows {
                        let VolunteerJob[datarows.indexpath] = indexPath.row
                    
                    let obj = dataRows[indexPath.row]
                    cell!.textLabel!.text = obj["Name"] as? String
 
                    }
                    */
                })
            }.catch { error in
                SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"Error: \(error)")
        }
        
    }
    */
    
    
   
    
    
    
    
}
