//
//  VolunteerJobDetailViewController.swift
//  MyNPSPiOSApp
//
//  Created by Elizabeth Martin on 7/20/18.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import Foundation
import UIKit
import SalesforceSDKCore
import SalesforceSwiftSDK
import PromiseKit
import os.log

class VolunteerJobDetailViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //Mark: Properties
    @IBOutlet weak var detailJobImageView: UIImageView!
    @IBOutlet weak var detailVolunteerJobLabel: UILabel!
    @IBOutlet weak var detailVolunteerJobDescriptionLabel: UILabel!
    @IBOutlet weak var availableShiftsHeading: UILabel!    
    @IBOutlet weak var tableView: UITableView!
    var shortWeekdaySymbols = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    //Mark: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
    }
    
    /*
     This value is either passed by `VolunteerJobTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new job.
     */
    var job: VolunteerJob?
    var shifts = [VolunteerJobShift]()
    var jobHoursSignedUp = [VolunteerJobHours]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up views if viewing an existing Job.
        if let job = job {
            navigationItem.title = job.name
            detailVolunteerJobLabel.text = job.name
            detailJobImageView.image = job.photo
            detailVolunteerJobDescriptionLabel.text = job.jobDescription
        }
        
        detailVolunteerJobLabel.font = UIFont.boldSystemFont(ofSize: 17.0)
        availableShiftsHeading.font = UIFont.boldSystemFont(ofSize: 17.0)
        
        tableView.reloadData()
        
        // Do any additional setup after loading the view.
    }
    
    
    //Mark: Setup the table view
    //removed 'override'
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //removed 'override'
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shifts.count
    }
    
    //removed 'override'
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "ShiftTableViewCell"
        
        // Configure the cell...
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ShiftTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ShiftTableViewCell.")
        }
        
        //MARK: root view controller implementation
        // Configure the cell to show the data.
        let particularShift = shifts[indexPath.row]
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ";
        
        // Swift
        let myCalendar = Calendar(identifier: .gregorian)
        let dft = DateFormatter()
        dft.setLocalizedDateFormatFromTemplate("MMMdh")
        let dft2 = DateFormatter()
        dft2.setLocalizedDateFormatFromTemplate("h")
        var endTimeString = ""
        
        if let endDate = dateFormatterGet.date(from: particularShift.endDateTime){
            endTimeString = dft2.string(from: endDate)
        }
        else {
            print("There was an error decoding the end date-time string")
        }
        
        if let date = dateFormatterGet.date(from: particularShift.startDateTime){
            let weekDay = myCalendar.component(.weekday, from: date)
            let weekDayString = shortWeekdaySymbols[weekDay-1]
            cell.shiftDateandTimeLabel.text = weekDayString+", "+dft.string(from: date)+"-"+endTimeString
            print(weekDayString+", "+dft.string(from: date))
            print(date.description(with: .current))
        }
        else {
            print("There was an error decoding the string")
        }

        if jobHoursSignedUp.count > 0 {
            for i in 0..<jobHoursSignedUp.count {
                if jobHoursSignedUp[i].volunteerShiftId == particularShift.shiftId {
                    print("Rachel is signed up for this shift!")
                    print(jobHoursSignedUp[i].volunteerShiftId)
                    cell.signUpButtonOutlet.backgroundColor = UIColor(red:0.67, green:0.71, blue:0.77, alpha:1.0)
                    cell.signUpButtonOutlet.setTitle("Signed Up", for: .normal)
                } else {
                    print("Rachel is NOT signed up for this shift!")
                    print(jobHoursSignedUp[i].volunteerShiftId)
                    cell.signUpButtonOutlet.backgroundColor = UIColor(red:1.00, green:0.29, blue:0.35, alpha:1.0)
                }
            }
        } else {
            print("Rachel is not signed up for any shifts")
        }
        
        cell.shiftId = particularShift.shiftId
        cell.jobId = particularShift.volunteerJobId
                
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
