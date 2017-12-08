//
//  DataContainerSingleton.swift
//  demoapp
//
//  Created by Jason Sekhon on 2017-11-26.
//  Copyright © 2017 Jason Sekhon. All rights reserved.
//

import Foundation
import UIKit
import MediaPlayer

class DataContainerSingleton {
    static let sharedInstance = DataContainerSingleton()
    private init(){}
    let mediaPlayer = MPMusicPlayerApplicationController.systemMusicPlayer
}
    /*
    func setupNowPlayingInfoCenter(){
        UIApplication.shared.beginReceivingRemoteControlEvents();
        MPRemoteCommandCenter.shared().playCommand.addTarget {event in
            self.mediaPlayer.play()
            self.setupNowPlayingInfoCenter()
            return .success
        }
        MPRemoteCommandCenter.shared().pauseCommand.addTarget {event in
            self.mediaPlayer.pause()
            return .success
        }
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget {event in
            self.mediaPlayer.skipToNextItem()
            return .success
        }
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget {event in
            self.mediaPlayer.skipToPreviousItem()
            return .success
        }
    }
    
    func updateNowPlayingInfoCenter() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [
            MPMediaItemPropertyTitle: mediaPlayer.nowPlayingItem?.title ?? "",
            MPMediaItemPropertyAlbumTitle: mediaPlayer.nowPlayingItem?.albumTitle ?? "",
            MPMediaItemPropertyArtist: mediaPlayer.nowPlayingItem?.artist ?? "",
            MPMediaItemPropertyPlaybackDuration: mediaPlayer.currentPlaybackRate,
            MPNowPlayingInfoPropertyElapsedPlaybackTime: mediaPlayer.currentPlaybackTime
        ]
    }
}
*/

/*
/**
 This struct defines the keys used to save the data container singleton's properties to NSUserDefaults.
 This is the "Swift way" to define string constants.
 */
struct DefaultsKeys
{
    static let mediaPlayer  = "mediaPlayer"
}

/**
 :Class:   DataContainerSingleton
 This class is used to save app state data and share it between classes.
 It observes the system UIApplicationDidEnterBackgroundNotification and saves its properties to NSUserDefaults before
 entering the background.
 Use the syntax `DataContainerSingleton.sharedDataContainer` to reference the shared data container singleton
 */
class DataContainerSingleton
{
    static let sharedDataContainer = DataContainerSingleton()
    
    //------------------------------------------------------------
    //Add properties here that you want to share accross your app
    var mediaPlayer: MPMusicPlayerApplicationController?
    //------------------------------------------------------------
    
    var goToBackgroundObserver: AnyObject?
    
    init()
    {
        let defaults = UserDefaults.standard
        //-----------------------------------------------------------------------------
        //This code reads the singleton's properties from NSUserDefaults.
        //edit this code to load your custom properties
        mediaPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
        //-----------------------------------------------------------------------------
        
        //Add an obsever for the UIApplicationDidEnterBackgroundNotification.
        //When the app goes to the background, the code block saves our properties to NSUserDefaults.
        goToBackgroundObserver = NotificationCenter.default.addObserver(
            forName: Notification.Name.UIApplicationDidEnterBackground,
            object: nil,
            queue: nil)
        {
            (note: Notification!) -> Void in
            let defaults = UserDefaults.standard
            //-----------------------------------------------------------------------------
            //This code saves the singleton's properties to NSUserDefaults.
            //edit this code to save your custom properties
            defaults.set( self.mediaPlayer, forKey: DefaultsKeys.mediaPlayer)
            //-----------------------------------------------------------------------------
            //Tell NSUserDefaults to save to disk now.
            defaults.synchronize()
        }
    }
}*/
