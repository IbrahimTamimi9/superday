///Contains the app's constants.
class Constants
{
    ///Distance the user has to travel in order to trigger a new location event.
    static let distanceFilter = 100.0
    
    ///Minimum size of the cosmetic line that appears on a TimeSlot cell.
    static let minLineSize = 12
    
    ///Key used for the preference that indicates whether the app is running for the first time or not.
    static let ranForTheFirstTime = "firstAppRunKey"
    
    ///Key used for the preference that indicates whether the user is currently traveling or not.
    static let isTravelingKey = "isTravelingKey"
    
    ///Name of the file that stores information regarding the first location detected since the user's last travel.
    static let firstLocationFile = "firstLocationFile"
    
    //MARK: Those values get replaced during build time
    
    ///AppId for HockeyApp.
    static let hockeyAppIdentifier = "HOCKEY_APP_IDENTIFIER"
}