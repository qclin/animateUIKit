//
//  NotificationViewController.swift
//  reminderNotification
//
//  Created by Qiao Lin on 3/3/17.
//  Copyright © 2017 Qiao Lin. All rights reserved.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var label: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        self.label?.text = notification.request.content.body
        
        if let number = notification.request.content.userInfo["customNumber"] as? Int {
            label?.text = "\(number)"
        }
    }
    
    

}
