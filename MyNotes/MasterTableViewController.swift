//
//  MasterTableViewController.swift
//  MyNotes
//
//  Created by Seema on 6/20/15.
//  Copyright (c) 2015 CMA. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    var notesObject: NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        super.viewDidAppear(true)
        
        if (PFUser.currentUser() == nil) {
            
            var  loginViewController = PFLogInViewController()
            loginViewController.delegate = self
            
            var signUpViewController = PFSignUpViewController()
            signUpViewController.delegate = self
            
            loginViewController.signUpController = signUpViewController
            
            self.presentViewController(loginViewController, animated: true, completion: nil)
            
        }
        else {
            
           self.fetchAllObjects()
        }
    }
    
    func fetchAllObjectsFormDataStore() {
        
        var query: PFQuery = PFQuery(className: "Note")
        query.fromLocalDatastore()
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if(error == nil){
                var temp: NSArray = objects as NSArray
                self.notesObject = temp.mutableCopy()  as NSMutableArray
                self.tableView.reloadData()
            }
        }
        
    }
    
    func fetchAllObjects(){
        
        PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        
        var query: PFQuery = PFQuery(className: "Note")
        query.whereKey("username", equalTo: PFUser.currentUser().username)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if(error == nil){
                PFObject.pinAllInBackground(objects, block: nil)
                self.fetchAllObjectsFormDataStore()
            }
            else{
                println(error.description)
            }
        }

    }
    
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty)
        {
            return true
        }
        else{
            return false
        }
    }

    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
        if let password = info?["password"] as? String {
            return password.utf16Count >= 8
        } else {
            return false
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        self.dismissViewControllerAnimated(true , completion:nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.notesObject.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as MasterTableViewCell

        var object:PFObject = self.notesObject.objectAtIndex(indexPath.row) as PFObject
        
        cell.labelTitle?.text = object["notetitle"] as? String
        cell.labelText?.text = object["notetext"] as? String
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("editNote", sender: self)
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        var controller: AddNoteTableViewController = segue.destinationViewController as AddNoteTableViewController
        
        if(segue.identifier == "editNote")
        {
            let index = self.tableView.indexPathForSelectedRow()!
            var object:PFObject = self.notesObject.objectAtIndex(index.row) as PFObject
            controller.notesObjects = object
            self.tableView.deselectRowAtIndexPath(index, animated: false)
        }
    }


}
