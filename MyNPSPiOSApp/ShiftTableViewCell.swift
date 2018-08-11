//
//  ShiftTableViewCell.swift
//  MyNPSPiOSApp
//
//  Created by Elizabeth Martin on 7/26/18.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import Foundation
import UIKit
import SalesforceSDKCore
import SalesforceSwiftSDK
import PromiseKit
import os.log

class ShiftTableViewCell: UITableViewCell {
    
    //Mark: Variables
    //var buttonColor: UIColor()
    //var cellShift = VolunteerJobShift(startDateTime: "", endDateTime: "")
    var jobId = ""
    var shiftId = ""
    var startDate = ""
    
    /*
    //MARK: Initialization
    init?(buttonColor: UIColor) {
        
        // Initialize stored properties.
        self.buttonColor = UIColor(red:1.00, green:0.29, blue:0.35, alpha:1.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    */
    
    
    //Mark: Outlets
    @IBOutlet weak var shiftDateandTimeLabel: UILabel!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        
        if (signUpButtonOutlet.backgroundColor == UIColor(red:0.67, green:0.71, blue:0.77, alpha:1.0)) {
            print("Already signed up!")
        } else {
            
            //Mark: Create new shift
            let shiftCreateRestApi = SFRestAPI.sharedInstance()
            shiftCreateRestApi.Promises
                .create(objectType: "GW_Volunteers__Volunteer_Hours__c", fields: [
                    "GW_Volunteers__Contact__c": "003f200002RBqk6AAD",
                    "GW_Volunteers__Volunteer_Job__c": jobId,
                    "GW_Volunteers__Volunteer_Shift__c": shiftId,
                    "GW_Volunteers__Status__c":"Confirmed",
                    "GW_Volunteers__Start_Date__c": "2018-08-20T14:00:00.000+0000"])
                
                .then {  request  in
                    shiftCreateRestApi.Promises.send(request: request)
                }.done { [unowned self] response in
                    DispatchQueue.main.async(execute: {
                    })
                }.catch { error in
                    SalesforceSwiftLogger.log(type(of:self), level:.debug, message:"Error: \(error)")
            }
            
            
        print("Signed-up 👍")
        signUpButtonOutlet.backgroundColor = UIColor(red:0.67, green:0.71, blue:0.77, alpha:1.0)
        signUpButtonOutlet.setTitle("Signed Up", for: .normal)}
    }
    
    /* old button method
     @IBAction func signUp1(_ sender: UIButton) {
     
     }
     */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
