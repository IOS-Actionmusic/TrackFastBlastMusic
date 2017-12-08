//
//  ActivityViewController.swift
//  demoapp
//
//  Created by Morris Arroyo on 2017-11-16.
//  Copyright © 2017 Jason Sekhon. All rights reserved.
//

import UIKit
import CoreData

class ActivityViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var managedObjectContext: NSManagedObjectContext!
    @IBOutlet weak var activityTableView: UITableView!
    private var activities = [Activity]()
    private var activity: Activity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityTableView.dataSource = self
        activityTableView.delegate   = self
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        for act in ActivityType.all {
            //let activity = NSEntityDescription.insertNewObject(forEntityName: "Activity", into: managedObjectContext)
            let activity = Activity(context: managedObjectContext)
            activity.id   = Int32(act.rawValue)
            activity.name = act.description
            //activities.append(Activity(entity: act.description, insertInto: act.rawValue))
            do {
                try managedObjectContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            activities.append(activity)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivityType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let leftCellId  = "ActivityLeftTableViewCell"
        let rightCellId = "ActivityRightTableViewCell"
        let activity = activities[indexPath.row]
        if (indexPath.row % 2  == 0) {
            guard let cell = activityTableView.dequeueReusableCell(withIdentifier: leftCellId) as? ActivityLeftTableViewCell else {
                fatalError("ActivityViewController, the dequeued cell is not an instance of ActivityLeftTableViewCell")
            }
            cell.activityImage.image = UIImage(named: activity.name!)
            cell.activityName.text = activity.name
            cell.editImage.image = #imageLiteral(resourceName: "icons8-Edit Filled")
            return cell
        } else {
            guard let cell = activityTableView.dequeueReusableCell(withIdentifier: rightCellId) as? ActivityRightTableViewCell else {
                fatalError("ActivityViewController, the dequeued cell is not an instance of ActivityRightTableViewCell")
            }
            cell.activityImage.image = UIImage(named: activity.name!)
            cell.activityName.text = activity.name
            cell.editImage.image = #imageLiteral(resourceName: "icons8-Edit")
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        performSegue(withIdentifier: "ShowPlaylistSongsSegue", sender: cell)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if let destinationViewController = segue.destination as? PlaylistController {
            destinationViewController.managedObjectContext = self.managedObjectContext
            let index = activityTableView.indexPath(for: (sender as? UITableViewCell)!)?.row
            print(index?.description ?? (-1).description)
            destinationViewController.activity = activities[index!]
        }
     }
    
    
}
