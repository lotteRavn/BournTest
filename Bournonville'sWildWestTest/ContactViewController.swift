//
//  ContactViewController.swift
//  Bournonville'sWildWestTest
//
//  Created by Lotte Ravn on 05/06/16.
//  Copyright © 2016 Lotte Ravn. All rights reserved.
//

import UIKit
import MessageUI

class ContactViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var mailButton: UIButton!
    @IBOutlet weak var ringButton: UIButton!
    
    
       override func viewDidLoad() {
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            textLabel.hidden = true
        }
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationItem.title = "Kontakt"
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: Mail

    @IBAction func mailButtonTapped(sender: UIButton) {
        textLabel.hidden = true
        
        let mailComposeViewController = configureMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        }else{
            self.showSendMailAlert()
        }
        
  
        
    }
       func configureMailComposeViewController() ->MFMailComposeViewController{
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        mailComposerVC.setToRecipients(["lotteravn@live.dk"])
        mailComposerVC.setSubject("Kontakt Bournonvilles")
        mailComposerVC.setMessageBody("Howdy Bournonville's!\n\nJeg kontakter jer fordi...\n", isHTML: false)
        
        return mailComposerVC
    }
    func showSendMailAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Kunne desværre ikke sende mailen", message:
            "Tjek opsætning på din telefon", preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "Annuller", style: .Default, handler: nil)
        sendMailErrorAlert.addAction(defaultAction)
        
        presentViewController(sendMailErrorAlert, animated: true, completion: nil)
        
        
    }
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue{
        case MFMailComposeResultCancelled.rawValue:
            print("mail cancelled")
        case MFMailComposeResultSent.rawValue:
            print("mail sent")
        default:
            break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    

    @IBOutlet weak var menuButton: UIBarButtonItem!
    //MARK: Call
    
    @IBAction func ringButtonTapped(sender: UIButton) {
        
        if let phoneUrl = NSURL(string: "tel://\(31531926)")
        {
            UIApplication.sharedApplication().openURL(phoneUrl)
            textLabel.hidden = false
            findButton.hidden = true
            mailButton.hidden = true
        }

        
    }
    
    @IBAction func findButtonTapped(sender: AnyObject) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destinationViewController as!
            MapViewController
            destinationController.address = "Vordingborgvej 441,Dalby,4690 Haslev"
            
        }
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
