/*
 */

import Foundation
import UIKit
import SalesforceSDKCore
import SalesforceSwiftSDK

// Fill these in when creating a new Connected Application on Force.com
let RemoteAccessConsumerKey = "3MVG9oNqAtcJCF.FshnsKkh1mC4zG2l0T79e6ogg6M0nhFqc4XOtJAWBn0k84EjJPq0X4i_zHfM5Mr_IwWjz3";
let OAuthRedirectURI = "testsfdc:///mobilesdk/detect/oauth/done";

class AppDelegate : UIResponder, UIApplicationDelegate
{
    var window: UIWindow?
    
    override
    init()
    {
        super.init()
        
        SalesforceSwiftSDKManager.initSDK()
        .Builder.configure { (appconfig: SFSDKAppConfig) -> Void in
            appconfig.oauthScopes = ["web", "api", "refresh_token", "offline_access"]
            appconfig.remoteAccessConsumerKey = RemoteAccessConsumerKey
            appconfig.oauthRedirectURI = OAuthRedirectURI
            
        }.postInit {
            
            //Uncomment the following line inorder to enable/force the use of advanced authentication flow.
            // SFUserAccountManager.sharedInstance().advancedAuthConfiguration = SFOAuthAdvancedAuthConfiguration.require;
            // OR
            // To  retrieve advanced auth configuration from the org, to determine whether to initiate advanced authentication.
            // SFUserAccountManager.sharedInstance().advancedAuthConfiguration = SFOAuthAdvancedAuthConfiguration.allow;
            
            // NOTE: If advanced authentication is configured or forced,  it will launch Safari to handle authentication
            // instead of a webview. You must implement application:openURL:options  to handle the callback.
        }
        .postLaunch {  [unowned self] (launchActionList: SFSDKLaunchAction) in
            let launchActionString = SalesforceSDKManager.launchActionsStringRepresentation(launchActionList)
            SalesforceSwiftLogger.log(type(of:self), level:.info, message:"Post-launch: launch actions taken: \(launchActionString)")
                //COMMENTING OUT TO TEST GETTING RID OF ROOT VIEW CONTROLLER
                //NOTE: ADDED BACK IN WITH UPDATED FUNCTION
                self.setupRootViewController()
            
            
        }.postLogout {  [unowned self] in
            self.handleSdkManagerLogout()
        }.switchUser{ [unowned self] (fromUser: SFUserAccount?, toUser: SFUserAccount?) -> () in
            self.handleUserSwitch(fromUser, toUser: toUser)
        }.launchError {  [unowned self] (error: Error, launchActionList: SFSDKLaunchAction) in
            SFSDKLogger.log(type(of:self), level:.error, message:"Error during SDK launch: \(error.localizedDescription)")
            self.initializeAppViewState()
            SalesforceSDKManager.shared().launch()
        }
        .done()
   
    }
    
    // MARK: - App delegate lifecycle
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        //Mark: Update at 10:20
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialNavigationViewController")

        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
                
        // COMMENTED OUT ON 10:20 update:
        self.initializeAppViewState();
        
        // If you wish to register for push notifications, uncomment the line below.  Note that,
        // if you want to receive push notifications from Salesforce, you will also need to
        // implement the application:didRegisterForRemoteNotificationsWithDeviceToken: method (below).
        //
        // SFPushNotificationManager.sharedInstance().registerForRemoteNotifications()
        
        //Uncomment the code below to see how you can customize the color, textcolor, font and fontsize of the navigation bar
        //var loginViewConfig = SFSDKLoginViewControllerConfig()
        //Set showSettingsIcon to NO if you want to hide the settings icon on the nav bar
        //loginViewConfig.showSettingsIcon = false
        //Set showNavBar to NO if you want to hide the top bar
        //loginViewConfig.showNavbar = true
        //loginViewConfig.navBarColor = UIColor(red: 0.051, green: 0.765, blue: 0.733, alpha: 1.0)
        //loginViewConfig.navBarTextColor = UIColor.white
        //loginViewConfig.navBarFont = UIFont(name: "Helvetica", size: 16.0)
        //SFUserAccountManager.sharedInstance().loginViewControllerConfig = loginViewConfig
        
        SalesforceSwiftSDKManager.shared().launch()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        //
        // Uncomment the code below to register your device token with the push notification manager
        //
        //
        // SFPushNotificationManager.sharedInstance().didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
        // if (SFUserAccountManager.sharedInstance().currentUser?.credentials.accessToken != nil)
        // {
        //    SFPushNotificationManager.sharedInstance().registerForSalesforceNotifications()
        // }
    }


    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error )
    {
        // Respond to any push notification registration errors here.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        // If you're using advanced authentication:
        // --Configure your app to handle incoming requests to your
        //   OAuth Redirect URI custom URL scheme.
        // --Uncomment the following line and delete the original return statement:

        // return  SFUserAccountManager.sharedInstance().handleAdvancedAuthenticationResponse(url, options: options)
        return false;
    }

    // MARK: - Private methods
    func initializeAppViewState()
    {
        if (!Thread.isMainThread) {
            DispatchQueue.main.async {
                self.initializeAppViewState()
            }
            return
        }
        
        self.window!.rootViewController = InitialViewController(nibName: nil, bundle: nil)
        self.window!.makeKeyAndVisible()
    }
    
    /*
    func setupRootViewController()
    {
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //let rootVC = storyboard.instantiateViewController(withIdentifier: "VolunteerJobTableViewController")
        //let navVC = UINavigationController(rootViewController: rootVC)
        //self.window!.rootViewController = navVC
        //self.window?.makeKeyAndVisible()
        
        let rootVC = RootViewController(nibName: nil, bundle: nil) //updated from Root
        let navVC = UINavigationController(rootViewController: rootVC)
        self.window!.rootViewController = navVC
        
    }
    */
    func setupRootViewController()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let initialViewController = storyboard.instantiateViewController(withIdentifier: "InitialNavigationViewController")
        
        self.window?.rootViewController = initialViewController
        
        /*
        let rootVC = RootViewController(nibName: nil, bundle: nil)
        let navVC = UINavigationController(rootViewController: rootVC)
        self.window!.rootViewController = navVC
        */
    }
    
    
    func resetViewState(_ postResetBlock: @escaping () -> ())
    {
        if let rootViewController = self.window!.rootViewController {
            if let _ = rootViewController.presentedViewController {
                rootViewController.dismiss(animated: false, completion: postResetBlock)
                return
            }
        }

        postResetBlock()
    }

    func handleSdkManagerLogout()
    {
        SFSDKLogger.log(type(of:self), level:.debug, message: "SFUserAccountManager logged out.  Resetting app.")
        self.resetViewState { () -> () in
            self.initializeAppViewState()

            // Multi-user pattern:
            // - If there are two or more existing accounts after logout, let the user choose the account
            //   to switch to.
            // - If there is one existing account, automatically switch to that account.
            // - If there are no further authenticated accounts, present the login screen.
            //
            // Alternatively, you could just go straight to re-initializing your app state, if you know
            // your app does not support multiple accounts.  The logic below will work either way.
            
            var numberOfAccounts : Int;
            let allAccounts = SFUserAccountManager.sharedInstance().allUserAccounts()
            numberOfAccounts = (allAccounts!.count);
            
            if numberOfAccounts > 1 {
                let userSwitchVc = SFDefaultUserManagementViewController(completionBlock: {
                    action in
                    self.window!.rootViewController!.dismiss(animated:true, completion: nil)
                })
                if let actualRootViewController = self.window!.rootViewController {
                    actualRootViewController.present(userSwitchVc, animated: true, completion: nil)
                }
            } else {
                if (numberOfAccounts == 1) {
                    SFUserAccountManager.sharedInstance().currentUser = allAccounts![0]
                }
                SalesforceSDKManager.shared().launch()
            }
        }
    }
    
    func handleUserSwitch(_ fromUser: SFUserAccount?, toUser: SFUserAccount?)
    {
        let fromUserName = (fromUser != nil) ? fromUser?.userName : "<none>"
        let toUserName = (toUser != nil) ? toUser?.userName : "<none>"
        SFSDKLogger.log(type(of:self), level:.debug, message:"SFUserAccountManager changed from user \(String(describing: fromUserName)) to \(String(describing: toUserName)).  Resetting app.")
        self.resetViewState { () -> () in
            self.initializeAppViewState()
            SalesforceSDKManager.shared().launch()
        }
    }
}
