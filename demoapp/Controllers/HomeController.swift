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
import AVKit

class HomeController: UIViewController {
    @IBOutlet weak var CurrentlyPlayingView: UIView!
    @IBOutlet weak var activityImage: UIImageView!
    @IBOutlet weak var activityText: UILabel!
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var playPause: UIImageView!
    var activity: String?
    var managedObjectContext: NSManagedObjectContext!
    let activityManager = CMMotionActivityManager()
    let dataContainerSingleton = DataContainerSingleton.sharedInstance
    let myMediaPlayer = DataContainerSingleton.sharedInstance.mediaPlayer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.myMediaPlayer.setQueue(with: MPMediaItemCollection.init(items: []))
        
        MPMediaLibrary.requestAuthorization() { status in
            if status == .authorized {
                DispatchQueue.main.async {
                    MPMusicPlayerController.systemMusicPlayer.beginGeneratingPlaybackNotifications()
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(self.updatePlayNowFrame), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: MPMusicPlayerController.systemMusicPlayer)
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(self.updatePlayPause), name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: MPMusicPlayerController.systemMusicPlayer)
                }
            }
        }
        if CMMotionActivityManager.isActivityAvailable()
        {
            activityManager.startActivityUpdates(to: OperationQueue.main)
            { (data: CMMotionActivity!) -> Void in
                DispatchQueue.main.async
                    { () -> Void in
                        if data.stationary == true {
                            UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                                self.view.backgroundColor = UIColor.blue
                            })
                            self.activityText.text = "Stationary"
                            self.activityImage.image = #imageLiteral(resourceName: "Stationary")
                            if (self.activity != "Stationary"){
                                self.activity = "Stationary"
                                print("set Stationary with \(String(describing: self.activity))")
                                self.myMediaPlayer.setQueue(with: self.getPlaylist(activityName: self.activity!))
                            }
                        }
                        else if data.walking == true
                        {
                            UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                                self.view.backgroundColor = UIColor.red
                            })
                            self.activityText.text = "Walking"
                            self.activityImage.image = #imageLiteral(resourceName: "Walking")
                            if (self.activity != "Walking"){
                                self.activity = "Walking"
                                print("set Walking with \(String(describing: self.activity))")
                                self.myMediaPlayer.setQueue(with: self.getPlaylist(activityName: self.activity!))
                            }
                        }
                        else if data.running == true
                        {
                            UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                                self.view.backgroundColor = UIColor.green
                            })
                            self.activityText.text = "Running"
                            self.activityImage.image = #imageLiteral(resourceName: "Running")
                            if (self.activity != "Running"){
                                self.activity = "Running"
                                print("set Running with \(String(describing: self.activity))")
                                self.myMediaPlayer.setQueue(with: self.getPlaylist(activityName: self.activity!))
                            }
                        }
                        else if data.cycling == true
                        {
                            UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                                self.view.backgroundColor = UIColor.magenta
                            })
                            self.activityText.text = "Cycling"
                            self.activityImage.image = #imageLiteral(resourceName: "Cycling")
                            if (self.activity != "Cycling"){
                                self.activity = "Cycling"
                                print("set Cycle with \(String(describing: self.activity))")
                                self.myMediaPlayer.setQueue(with: self.getPlaylist(activityName: self.activity!))
                            }
                        }
                        else if data.automotive == true
                        {
                            UIView.animate(withDuration: 2, delay: 0, options: UIViewAnimationOptions.allowUserInteraction, animations: { () -> Void in
                                self.view.backgroundColor = UIColor.yellow
                            })
                            self.activityText.text = "Driving"
                            self.activityImage.image = #imageLiteral(resourceName: "Driving")
                            if (self.activity != "Driving"){
                                self.activity = "Driving"
                                print("set Auto with \(String(describing: self.activity))")
                                self.myMediaPlayer.setQueue(with: self.getPlaylist(activityName: self.activity!))
                            }
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
    
    @objc func updatePlayNowFrame(){
        myMediaPlayer.play()
        if (myMediaPlayer.nowPlayingItem != nil){
            albumArt.image = myMediaPlayer.nowPlayingItem?.artwork?.image(at: (albumArt.bounds.size))
            songName.text = (myMediaPlayer.nowPlayingItem?.title)!
            artistName.text = (myMediaPlayer.nowPlayingItem?.artist)!
        }
    }
    
    @objc func updatePlayPause(){
        if (myMediaPlayer.playbackState.rawValue != 1){
            playPause.image = #imageLiteral(resourceName: "icons8-Play Filled")
        } else {
            playPause.image = #imageLiteral(resourceName: "icons8-Pause Filled")
        }
    }
    
    func getPlaylist(activityName: String) -> MPMediaItemCollection{
        let fetch = NSFetchRequest<NSFetchRequestResult>()
        let entity = NSEntityDescription.entity(forEntityName: "Song", in: self.managedObjectContext)
        var collection = [MPMediaItem]()
        fetch.entity = entity
        do {
            let result = try self.managedObjectContext.fetch(fetch)
            for song in result {
                let activity = (song as! NSManagedObject).value(forKey: "activity") as! NSManagedObject
                if (activity.value(forKey: "name") as! String == activityName){
                    let item = self.findSongWithPersistentId(persistentID: (song as! NSManagedObject).value(forKey: "id") as! Int64)
                    collection.append(item!)
                }
            }
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return MPMediaItemCollection.init(items: collection)
    }
    
    func findSongWithPersistentId(persistentID: Int64) -> MPMediaItem? {
        let predicate = MPMediaPropertyPredicate(value: persistentID, forProperty: MPMediaItemPropertyPersistentID)
        let songQuery = MPMediaQuery()
        songQuery.addFilterPredicate(predicate)
        
        var song: MPMediaItem?
        if let items = songQuery.items, items.count > 0 {
            song = items[0]
        }
        return song
    }
    
    func validatePlaylists() -> (isEmpty: Bool, name: String){
        if (getPlaylist(activityName: "Stationary").count == 0){
            return (true, "Stationary")
        } else if (getPlaylist(activityName: "Walking").count == 0){
            return (true, "Walking")
        } else if (getPlaylist(activityName: "Running").count == 0){
            return (true, "Running")
        } else if (getPlaylist(activityName: "Cycling").count == 0){
            return (true, "Cycling")
        } else if (getPlaylist(activityName: "Driving").count == 0){
            return (true, "Driving")
        } else {
            return (false, "None")
        }
    }
    
    func testTouches(touches: NSSet!) {
        if (self.activity != nil){
            let validatePlaylist = self.validatePlaylists()
            if(!validatePlaylist.isEmpty){
                let touch = touches.allObjects[0] as! UITouch
                let touchLocation = touch.location(in: self.view)
                let obstacleViewFrame = self.view.convert(CurrentlyPlayingView.frame, from: CurrentlyPlayingView.superview)
                if obstacleViewFrame.contains(touchLocation) {
                    performSegue(withIdentifier: "showPlayer", sender: nil)
                }
            } else {
                let alert = UIAlertController(title: "\(validatePlaylist.name) has no songs", message: "Please add songs to the \(validatePlaylist.name) category", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Scanning", message: "Please wait until scanning is complete", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
