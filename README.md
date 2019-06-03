# ArtTour
[![Version](https://img.shields.io/badge/version-3.0-green.svg)](https://github.com/ta13pioneer/ArtTour/releases/tag/v3.0)
[![Swift Version](https://img.shields.io/badge/swfit-5.0-blue.svg)](https://swift.org/)
[![iOS Version](https://img.shields.io/badge/iOS-12.0-yellow.svg)](https://developer.apple.com/ios/)

# ArtTour Project Description

“Art Tour”, is an iOS application which provides users with a map of landmarks and public artworks and image recognition that allows them to obtain information about landmark and public artwork easily. Also, the app provides a list of events related to arts and culture, and a little game that shows the numbers of landmark and public artwork visited by the user. The game allows users to share or compete with others.
By providing above functions, Art Tour aims to increase public awareness and understanding of landmarks and public artwork, encourage public to participate into art events and in the end, change Melbourne to a more creative city.
Our users can be residents or visitors who are interested in art and culture, and are exploring or plan to explore the creative life of Melbourne.

We can help when:

•	Users want to know if there is any landmark or artwork closed by to visit but they do not have time or are not willing to spend time to investigate;

•	Users find a beautiful artwork/landmark, and want to know its name and related information, but they do not have time or are not willing to spend time to search online;                                                                                                                                                  

•	Users want to know the ongoing and upcoming art event. And add interested events to the calendar.

# Things you need to know before Installation
There are several API Key or third party library configuration file need to be changed before you install and set up this App.

First is the API Key for Google map. This is in the AppDelegate.swift file and inside the method which called "application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?)"

Second is the configuration file of Firebase which is used for Google AutoML feature to do the image recognition. This file is called GoogleService-info.plist and it is the root folder of this project.

Third is the REST API URL of own server which is used to query landmarks and artworks information form our own server. These API URL is inside the file called testViewController.swift under the introduction folder.

The last is the authtication token for eventbrite. It is inside the file called eventnewTableViewController.swift and under the folder called event. the variable of the eventbrite authentication token is called eventbritetoken, you need to change this token to your own eventbrite authentication token. 

# Prerequisites
iOS system 12.2 and above

# Getting Started

@ Explore Upcoming Events 

Search the upcoming events based on various criteria and glance over the event details, 
such as the location and ticket fees. Experience the cultural diversity of Melbourne.

@ Find Your Favorite Landmarks and Artworks Nearby

Automatically nidificate and display the artificial landmarks surrounding you based on location. 
Find your favorite attractions and visit them. Enjoy your city day trip.

@ Image Recognition

Want to know more about the landmarks or artefacts you are visiting? 
Just upload your photos and explore deeper with ArtTour, finding stories behind them.

@ Manage Your Lists 

Manage your saved attractions and events here, recording and reviewing your 
exploration of City Melbourne. Get instructed to ArtTour better and refresh your favorite list.  

# Versioning
We use GitHub for versioning. 

# Authors
Toby Ren - Main author

Ada Chen - Contributor

# License
This project is licensed under the Apache License, Version 2.0 (the "License").

# Acknowledgments
The data sets used in this application mainly are the APIs, which means it is possible to remain updated overtime automatically;

Some code to achieve complex functionalties is referenced from other forums, such as the Stack Overflow and GitHub.

# Third Party Library or tool to support this application
1. Google Map
2. Google AutoML on Firebase
3. PinRemoteImage on GitHub: https://github.com/pinterest/PINRemoteImage
4. SwiftyJSON on GitHub: https://github.com/SwiftyJSON/SwiftyJSON
5. YoutubePlayer-in-WKWebView on GitHub: https://github.com/hmhv/YoutubePlayer-in-WKWebView
6. Eventbrite API
7. Victoria Museum API
8. Wikipedia REST API
9. Toast on GitHub: https://github.com/bolagong/Toast
10. EFImageViewZoom on GitHub: 

