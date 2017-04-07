import RxSwift
import XCTest
import Nimble
@testable import teferi

class LocationPermissionViewModelTests : XCTestCase
{
    private var viewModel : PermissionViewModel!
    private var disposable : Disposable? = nil
    
    private var timeService : MockTimeService!
    private var settingsService : MockSettingsService!
    private var appLifecycleService : MockAppLifecycleService!
    
    override func setUp()
    {
        self.timeService = MockTimeService()
        self.settingsService = MockSettingsService()
        self.appLifecycleService = MockAppLifecycleService()
        
        self.viewModel = LocationPermissionViewModel(timeService: self.timeService,
                                                     settingsService: self.settingsService,
                                                     appLifecycleService: self.appLifecycleService)
    }
    
    override func tearDown()
    {
        self.disposable?.dispose()
    }
    
    func testThePermissionStateShouldNotBeShownIfTheUserHasAlreadyAuthorized()
    {
        self.settingsService.hasLocationPermission = true
        
        var wouldShow = false
        self.disposable = self.viewModel
            .showOverlayObservable
            .subscribe(onNext:  { wouldShow = true })
        
        expect(wouldShow).to(beFalse())
    }
    
    func testIfThePermissionOverlayWasNeverShownItNeedsToBeShown()
    {
        self.settingsService.hasLocationPermission = false
        self.settingsService.lastAskedForLocationPermission = nil
        
        var wouldShow = false
        self.disposable = self.viewModel
            .showOverlayObservable
            .subscribe(onNext: { _ in wouldShow = true })
        
        self.appLifecycleService.publish(.movedToForeground(fromNotification:false))
        
        expect(wouldShow).to(beTrue())
    }
    
    func testThePermissionStateShouldBeShownIfItWasNotShownForOver24Hours()
    {
        self.settingsService.hasLocationPermission = false
        self.settingsService.lastAskedForLocationPermission = Date().add(days: -2)
        
        var wouldShow = false
        self.disposable = self.viewModel
            .showOverlayObservable
            .subscribe(onNext: { _ in wouldShow = true })
        
        self.appLifecycleService.publish(.movedToForeground(fromNotification:false))
        
        expect(wouldShow).to(beTrue())
    }
    
    func testThePermissionStateShouldNotBeShownIfItWasLastShownInTheLast24Hours()
    {
        self.settingsService.hasLocationPermission = false
        self.settingsService.lastAskedForLocationPermission = Date().ignoreTimeComponents()
        
        var wouldShow = false
        self.disposable = self.viewModel
            .showOverlayObservable
            .subscribe(onNext: { _ in wouldShow = true })
        
        expect(wouldShow).to(beFalse())
    }
    
    func testPermissionShouldShowBlockingOverlayFirstTimeUserOpensTheApp()
    {
        self.settingsService.hasLocationPermission = false
        self.settingsService.lastAskedForLocationPermission = nil
        
        expect(self.viewModel.remindMeLater).to(beTrue())
    }
    
    func testPermissionShouldShowNonBlockingOverlayIfUserAlreadyGavePermission()
    {
        self.settingsService.hasLocationPermission = false
        self.settingsService.lastAskedForLocationPermission = nil
        
        self.viewModel.permissionGiven()
        
        self.appLifecycleService.publish(.movedToForeground(fromNotification:false))
        
        expect(self.viewModel.remindMeLater).to(beFalse())
    }
}
