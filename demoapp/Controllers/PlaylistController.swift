//
//  PlaylistController.swift
//  TrackFastBlastMusic
//
//  Created by Jason Sekhon on 2017-10-06.
//  Copyright © 2017 Jason Sekhon. All rights reserved.
//

import UIKit
import CoreData
import MediaPlayer

class PlaylistController: UIViewController, UITableViewDataSource, UITableViewDelegate, MPMediaPickerControllerDelegate {
    
    @IBOutlet weak var playlistTableView: UITableView!
    
    private var playlist = [Song]()
    var activity: Activity!
    var managedObjectContext: NSManagedObjectContext!
    override func viewDidLoad() {
        super.viewDidLoad()
        playlistTableView.dataSource = self
        playlistTableView.delegate   = self
        let request: NSFetchRequest<Song> = Song.fetchRequest()
        let predicate = NSPredicate(format: "%K == %d", #keyPath(Song.activity.id), activity.id)
        request.predicate = predicate
        do {
            let fetchedSongs = try managedObjectContext.fetch(request)
            print(fetchedSongs)
            playlist = fetchedSongs
            
        } catch {
            fatalError("Failed to fetch playlist from core data: \(error)")
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addSongsButtonPressed(_ sender: Any) {
        let musicPicker = MPMediaPickerController(mediaTypes: MPMediaType.music)
        musicPicker.allowsPickingMultipleItems = true
        musicPicker.popoverPresentationController?.sourceView = sender as? UIView
        musicPicker.delegate = self
        self.present(musicPicker, animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        for song in mediaItemCollection.items {
            let id = (song.value(forProperty: MPMediaItemPropertyPersistentID) as? Int64)!
            let request: NSFetchRequest<Song> = Song.fetchRequest()
            let predicate = NSPredicate(format: "%K == %d && %K == %ld", #keyPath(Song.activity.id), activity.id, #keyPath(Song.id), id)
            request.predicate = predicate
            do {
                let count = try managedObjectContext.count(for: request)
                print(count)
                if (count == 0) {
                    let music = Song(context: managedObjectContext)
                    music.activity = self.activity
                    music.id = id
                    music.title = song.value(forProperty: MPMediaItemPropertyTitle) as? String
                    music.artist = song.value(forProperty: MPMediaItemPropertyArtist) as? String
                    do {
                        try managedObjectContext.save()
                        playlist.append(music)
                    } catch {
                        fatalError("Failure to save context: \(error)")
                    }
                }
            } catch {
                fatalError("Failure to get count of id in context: \(error)")
            }
        }
        playlistTableView.reloadData()
        mediaPicker.dismiss(animated: true)
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return playlist.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = playlistTableView.dequeueReusableCell(withIdentifier: "PlaylistAddSongTableViewCell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = playlistTableView.dequeueReusableCell(withIdentifier: "PlaylistSongTableViewCell", for: indexPath) as? PlaylistSongTableViewCell else {
            fatalError("PlaylistController, the dequeued cell is not an instance of PlaylistSongTableViewCell")
        }
        cell.title.text = playlist[indexPath.row].title
        cell.artist.text = playlist[indexPath.row].artist
        let predicate = MPMediaPropertyPredicate(value: playlist[indexPath.row].id, forProperty: MPMediaItemPropertyPersistentID)
        let songQuery = MPMediaQuery()
        songQuery.addFilterPredicate(predicate)
        if let items = songQuery.items {
            if (items.count > 0) {
                let song = items[0]
                if let image = ((song.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork)?.image(at: CGSize(width:50, height: 50)))   {
                    cell.albumCover.image = image
                } else {
                    cell.albumCover.image = #imageLiteral(resourceName: "iTunesArtwork")
                }
            } else {
                cell.albumCover.image = #imageLiteral(resourceName: "iTunesArtwork")
            }
        }
        return cell
    }
    
    
}
