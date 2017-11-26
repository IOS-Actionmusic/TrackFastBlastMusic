//
//  HomeController.swift
//  TrackFastBlastMusic
//
//  Created by Jason Sekhon on 2017-10-06.
//  Copyright © 2017 Jason Sekhon. All rights reserved.
//

import UIKit
import CoreMotion
import CoreData
import MediaPlayer

class HomeController: UIViewController {
    @IBOutlet weak var CurrentlyPlayingView: UIView!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var activityText: UILabel!
    var activity: String?
    var managedObjectContext: NSManagedObjectContext!
    let activityManager = CMMotionActivityManager()
    let myMediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if CMMotionActivityManager.isActivityAvailable()
        {
            activityManager.startActivityUpdates(to: OperationQueue.main)
            { (data: CMMotionActivity!) -> Void in
                DispatchQueue.main.async
                    { () -> Void in
                        if data.stationary == true
                        {
                            UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                                self.view.backgroundColor = UIColor.blue
                            })
                            self.activity = "Stationary"
                            self.activityText.text = "Stationary"
                            self.activityImage.image = #imageLiteral(resourceName: "Stationary")
                            let fetch = NSFetchRequest<NSFetchRequestResult>()
                            let entity = NSEntityDescription.entity(forEntityName: "Song", in: self.managedObjectContext)
                            fetch.entity = entity
                            do {
                                let result = try self.managedObjectContext.fetch(fetch)
                                print(result)
                                
                            } catch {
                                let fetchError = error as NSError
                                print(fetchError)
                            }
                            self.myMediaPlayer.setQueue(with: MPMediaQuery.songs())
                        }
                        else if data.walking == true
                        {
                            UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                                self.view.backgroundColor = UIColor.red
                            })
                            self.activity = "Walking"
                            self.activityText.text = "Walking"
                            self.activityImage.image = #imageLiteral(resourceName: "Walking")
                            self.myMediaPlayer.setQueue(with: MPMediaQuery.songs())
                        }
                        else if data.running == true
                        {
                            UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                                self.view.backgroundColor = UIColor.green
                            })
                            self.activity = "Running"
                            self.activityText.text = "Running"
                            self.activityImage.image = #imageLiteral(resourceName: "Running")
                            self.myMediaPlayer.setQueue(with: MPMediaQuery.songs())
                        }
                        else if data.cycling == true
                        {
                            UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                                self.view.backgroundColor = UIColor.magenta
                            })
                            self.activity = "Cycling"
                            self.activityText.text = "Cycling"
                            self.activityImage.image = #imageLiteral(resourceName: "Cycling")
                            self.myMediaPlayer.setQueue(with: MPMediaQuery.songs())
                        }
                        else if data.automotive == true
                        {
                            UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                                self.view.backgroundColor = UIColor.yellow
                            })
                            self.activity = "Automotive"
                            self.activityText.text = "Automotive"
                            self.activityImage.image = #imageLiteral(resourceName: "Driving")
                            self.myMediaPlayer.setQueue(with: MPMediaQuery.songs())
                        }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        testTouches(touches: touches as NSSet)
    }
    
    func testTouches(touches: NSSet!) {
        if (!((activity?.isEmpty)!)){
            let touch = touches.allObjects[0] as! UITouch
            let touchLocation = touch.location(in: self.view)
            let obstacleViewFrame = self.view.convert(CurrentlyPlayingView.frame, from: CurrentlyPlayingView.superview)
            if obstacleViewFrame.contains(touchLocation) {
                performSegue(withIdentifier: "showPlayer", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "showPlayer":
            guard let playerController = segue.destination as? PlayerController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            playerController.activity = (self.activity)!
        default:
            if let destinationViewController = segue.destination as? ActivityViewController {
                destinationViewController.managedObjectContext = self.managedObjectContext
            }
        }
    }

}
