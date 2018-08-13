//
//  VolunteerJobShift.swift
//  MyNPSPiOSApp
//
//  Created by Elizabeth Martin on 7/23/18.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import Foundation
import UIKit
import SalesforceSDKCore
import SalesforceSwiftSDK
import PromiseKit
import os.log

class VolunteerJobShift {
    
    //Mark: Properties
    var startDateTime: String
    var endDateTime: String
    var desiredNumberVolunteers: Int
    var numberVolunteersStillNeeded: Int
    var volunteerJobId: String
    var shiftName: String
    var shiftId: String
    var hoursInShift: Int

    //MARK: Initialization
    init?(startDateTime: String, endDateTime: String, desiredNumberVolunteers: Int, numberVolunteersStillNeeded: Int, volunteerJobId: String, shiftName: String, shiftId: String, hoursInShift: Int) {
        
        // Initialization should fail if there is no name or # volunteers is negative
        if volunteerJobId.isEmpty || desiredNumberVolunteers < 0 {
            return nil
        }
        
        // Initialize stored properties.
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.desiredNumberVolunteers = desiredNumberVolunteers
        self.numberVolunteersStillNeeded = numberVolunteersStillNeeded
        self.volunteerJobId = volunteerJobId
        self.shiftName = shiftName
        self.shiftId = shiftId
        self.hoursInShift = hoursInShift
        
    }
    
}
