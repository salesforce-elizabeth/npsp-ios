/*

*/

import Foundation
import UIKit
import SalesforceSDKCore

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    NSStringFromClass(SFApplication.self),
    NSStringFromClass(AppDelegate.self)
)
