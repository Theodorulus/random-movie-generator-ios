//
//  ContentView.swift
//  random-movie-picker
//
//  Created by user217570 on 4/18/22.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    let notificationCenter = UNUserNotificationCenter.current()
    
    var body: some View {
        NavigationView{
            List {
                NavigationLink(destination: MovieView(movieOrTv: "movie")) {
                    Text("Movie").font(.headline)
                }
                
                NavigationLink(destination: MovieView(movieOrTv: "tv")) {
                    Text("TV Series").font(.headline)
                }
            }
            .navigationBarTitle("Watch something?", displayMode: .large)
        }
        .onAppear() {
            notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { permissionGranted, error in
                if (!permissionGranted) {
                    print("Permission denied")
                    print(error?.localizedDescription)
                }
            }
            
            notificationCenter.getNotificationSettings { (settings) in
                if(settings.authorizationStatus == .authorized){
                    let content = UNMutableNotificationContent()
                    content.title = "Don't know what to watch?"
                    content.body = "We have some suggestions"
                    content.sound = UNNotificationSound.default
                    
                    var dateComponents = DateComponents()
                    dateComponents.hour = 20
                    dateComponents.minute = 0
                    
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    
                    let request =  UNNotificationRequest(identifier: "ID", content: content, trigger: trigger)
                    notificationCenter.add(request) { (error : Error?) in
                        if let theError = error {
                            print(theError.localizedDescription)
                        }
                    }
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}
