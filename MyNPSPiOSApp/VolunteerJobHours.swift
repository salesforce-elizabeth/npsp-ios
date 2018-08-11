//
//  VolunteerJobHours.swift
//  MyNPSPiOSApp
//
//  Created by Elizabeth Martin on 8/6/18.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import Foundation
import UIKit
import SalesforceSDKCore
import SalesforceSwiftSDK
import PromiseKit
import os.log

class VolunteerJobHours {
    
    //Mark: Properties
    var hoursID: String
    var volunteerJobId: String
    var volunteerShiftId: String
    var volunteerId: String
    var startDate: String
    
    //MARK: Initialization
    init?(hoursID: String, volunteerJobId: String, volunteerShiftId: String, volunteerId: String, startDate: String) {
        
        // Initialization should fail if there is no name or # volunteers is negative
        if volunteerJobId.isEmpty {
            return nil
        }
        
        // Initialize stored properties.
        self.hoursID = hoursID
        self.volunteerJobId = volunteerJobId
        self.volunteerShiftId = volunteerShiftId
        self.volunteerId = volunteerId
        self.startDate = startDate
        
    }

    
}
