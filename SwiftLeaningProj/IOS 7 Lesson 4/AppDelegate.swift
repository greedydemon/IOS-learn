//
//  AppDelegate.swift
//  IOS 7 Lesson 2
//
//  Created by Admin on 3/2/17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Using List
        var songs : [String] = ["Cheerleader", "Top of the world", "Love me like you do", "Hallelujah", "Spectre"]
        
        //Print list in alphabet order
        print("\nList great song : \(songs.sorted())")
        //Add, modify remove an item in list
        print("\nAppend 1 more song in list\n")
        songs.append("God is a girl")
        printList(list: songs)
        
        print("\nReplace 1 song in list\n")
        songs[1] = "Shake it off"
        printList(list: songs)
        
        print("\nDelete 1 song in list\n")
        songs.remove(at: 1)
        printList(list: songs)
        
        //Using Dictionary
        var chromeInfo = [[String : String]]()
        chromeInfo = [
            [
                "Name" : "Google Chrome",
                "Version" : "56.0",
                "Developer" : "Google",
                "License" : "Freeware",
                "Release" : "2008"
            ],
            [
                "Name" : "Firefox",
                "Version" : "54.0",
                "Developer" : "Firefox",
                "License" : "Freeware",
                "Release" : "2000"

            ],
            [
                "Name" : "Internet Explorer",
                "Version" : "12",
                "Developer" : "Microsoft",
                "License" : "Freeware",
                "Release" : "1990"
                
            ],

        ]
        //Add, Modify, delete and print 1 items in dictionary
        //dump(chromeInfo)
        chromeInfo = updatedict(listBrowser: chromeInfo, name: "Firefox", newbrowser: chromeInfo)
        print()
        print()
        dump(chromeInfo)
//        chromeInfo["Website"] = "google.com\\home"
//        
//        dump(chromeInfo)
//        chromeInfo["Name"] = "Firefox"
//        
//        dump(chromeInfo)
//        chromeInfo.removeValue(forKey: "Version")
//        
//        dump(chromeInfo)

        return true
    }
    
    func printList(list : [String]) -> Void {
        print("List great song : \(list.sorted())")
    }

    func updatedict(listBrowser : [[String: String]], name: String, newbrowser: [[String: String]]) -> [[String: String]] {
        var localBrowsers = listBrowser
        for i in 0..<localBrowsers.count{
//            for(key,value) in localBrowser[i]{
//                if (key == "Name" && value == name) {
//                    localBrowser.remove(at: i)
//                    return localBrowser
//                }
//            }
            if localBrowsers[i]["Name"] == name
            {
                localBrowsers.remove(at: i)
                return localBrowsers
            }
            
            //print(localBrowsers[i]["Name"])
        }
        return localBrowsers
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

