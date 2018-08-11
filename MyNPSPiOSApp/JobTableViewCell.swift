//
//  JobTableViewCell.swift
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

class JobTableViewCell: UITableViewCell {
    
    //Mark: Properties
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var volunteerJobLabel: UILabel!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
