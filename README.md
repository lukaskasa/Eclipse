# Eclipse iOS App

The Eclipse iOS / iPadOS application takes advantage of the NASA API (https://api.nasa.gov/). The app accesses the "Mars Rover Photos", "Earth", and "Insight" endpoints explicitly. 

The "Eye in the Sky" module consumes earth observation data from the "Earth" endpoint. The user can search for an address or use their current location to download a satellite image from that location.

The "Rover Postcard Maker" feature uses the "Mars Rover Photos" endpoint to display image data collected by the rovers on Mars. The user is then able to select an image, add some text and send the picture as an E-Mail. 

Weather on Mars takes advantage of the "Insight" endpoint where the temperature data is consumed and displayed in a UICollectionView. Additionally, a rotating sphere with a texture is used to illustrate the planet of Mars.


API's and frameworks in use:

* NASA API (https://api.nasa.gov/)
* Foundation
* UIKit
* SystemConfiguration
* MapKit
* MessageUI
* SceneKit
* XCTest 