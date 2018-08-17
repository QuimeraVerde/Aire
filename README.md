# Aire
Augmented reality Swift application for iOS to visualize current pollutants in the air using the [World Air Quality Index](http://aqicn.org/)'s API to help create awareness of the rising air pollution in any given location.

To run this project locally, you'll need to have Xcode and Cocoapods installed. Xcode will let you run the app on the iOS simulator or on your iPad, and Cocoapods will let you install the libraries used on this project. 

To install Xcode, just look for it on the App Store.
To install Cocoapods, open your preferred terminal app and run 
```
$ sudo gem install cocoapods
```
For more information, visit https://cocoapods.org

Once you've got Xcode and Cocopoads, you'll need to follow these instructions to setup your work environment:

1. Run 
```
$ git clone https://github.com/pauescalantec/Aire.git
```
2. Change directory to the newly created folder by running 
```
$ cd Aire
```
3. Once you're on the project's root directory, run 
```
$ pod install
```
4. Open the file named **Aire.xcworkspace**. You can do it manually or through the terminal by running 
```
$ open Aire.xcworkspace
```
5. You can close your terminal app, from now on you'll use Xcode.
6. On the left panel, click on the root folder named **Aire**, the one with the blue icon.
7. Change the **Team** to match your developer account.
8. It'll show you an error because you'll be using a Bundle Id that's already in use. Change it and click on **Try again** until the app shows you no more errors. 

If you'll be running it on the iOS simulator, you're all set, now all you have to do is click on the *play* icon on the top left corner. 

If you want to run it on an iPad, follow these instructions:

1. Connect your iPad to your computer
2. On Xcode, in the top left corner, you'll find a section that reads "Aire > iPad Air". Click on it and select your iPad. 
3. Run the project by clicking on the *play* icon on the top left corner. This will install the app on your iPad, but it will not run it because you're not a trusted profile on your iPad yet. 
4. On your iPad, go to the **Settings** app. 
5. Open **General**
6. Open **Profiles & Device Management**
7. Choose your profile and trust it.
8. Try to open the app again and it should work! 
