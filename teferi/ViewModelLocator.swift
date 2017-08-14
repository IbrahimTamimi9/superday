import Foundation
import UIKit

protocol ViewModelLocator
{
    func getNavigationViewModel(forViewController: UIViewController) -> NavigationViewModel
    func getIntroViewModel() -> IntroViewModel
    func getOnboardingViewModel() -> OnboardingViewModel
    
    func getCalendarViewModel() -> CalendarViewModel
    
    func getMainViewModel() -> MainViewModel
    
    func getPagerViewModel() -> PagerViewModel
    
    func getLocationPermissionViewModel() -> PermissionViewModel
    func getHealthKitPermissionViewModel() -> PermissionViewModel
    
    func getTimelineViewModel(forDate date: Date) -> TimelineViewModel
    
    func getWeeklySummaryViewModel() -> WeeklySummaryViewModel
    
    func getDailySummaryViewModel(forDate date: Date) -> DailySummaryViewModel
    func getSummaryViewModel() -> SummaryViewModel
    func getSummaryPageViewModel(forDate date: Date) -> SummaryPageViewModel
}

class DefaultViewModelLocator : ViewModelLocator
{
    private let timeService : TimeService
    private let metricsService : MetricsService
    private let feedbackService : FeedbackService
    private let locationService : LocationService
    private let settingsService : SettingsService
    private let timeSlotService : TimeSlotService
    private let editStateService : EditStateService
    private let smartGuessService : SmartGuessService
    private let appLifecycleService : AppLifecycleService
    private let selectedDateService : SelectedDateService
    private let loggingService : LoggingService
    private let healthKitService : HealthKitService
    private let notificationService : NotificationService
    
    init(timeService: TimeService,
         metricsService: MetricsService,
         feedbackService: FeedbackService,
         locationService: LocationService,
         settingsService: SettingsService,
         timeSlotService: TimeSlotService,
         editStateService: EditStateService,
         smartGuessService: SmartGuessService,
         appLifecycleService: AppLifecycleService,
         selectedDateService: SelectedDateService,
         loggingService: LoggingService,
         healthKitService : HealthKitService,
         notificationService: NotificationService)
    {
        self.timeService = timeService
        self.metricsService = metricsService
        self.feedbackService = feedbackService
        self.locationService = locationService
        self.settingsService = settingsService
        self.timeSlotService = timeSlotService
        self.editStateService = editStateService
        self.smartGuessService = smartGuessService
        self.appLifecycleService = appLifecycleService
        self.selectedDateService = selectedDateService
        self.loggingService = loggingService
        self.healthKitService = healthKitService
        self.notificationService = notificationService
    }
    
    func getNavigationViewModel(forViewController viewController: UIViewController) -> NavigationViewModel
    {
        let feedbackService = (self.feedbackService as! MailFeedbackService).with(viewController: viewController)

        return NavigationViewModel(timeService: self.timeService,
                                       feedbackService: feedbackService,
                                       selectedDateService: self.selectedDateService,
                                       appLifecycleService: self.appLifecycleService)
    }
    
    func getIntroViewModel() -> IntroViewModel
    {
        return IntroViewModel(settingsService: self.settingsService)
    }
    
    func getOnboardingViewModel() -> OnboardingViewModel
    {
        return OnboardingViewModel(timeService: self.timeService,
                                   timeSlotService: self.timeSlotService,
                                   settingsService: self.settingsService,
                                   appLifecycleService: self.appLifecycleService,
                                   notificationService: self.notificationService)
    }
    
    func getMainViewModel() -> MainViewModel
    {
        let viewModel = MainViewModel(timeService: self.timeService,
                                      metricsService: self.metricsService,
                                      timeSlotService: self.timeSlotService,
                                      editStateService: self.editStateService,
                                      smartGuessService: self.smartGuessService,
                                      selectedDateService: self.selectedDateService,
                                      settingsService: self.settingsService,
                                      appLifecycleService: self.appLifecycleService)
        return viewModel
    }
    
    func getPagerViewModel() -> PagerViewModel
    {
        let viewModel = PagerViewModel(timeService: self.timeService,
                                       timeSlotService: self.timeSlotService,
                                       settingsService: self.settingsService,
                                       editStateService: self.editStateService,
                                       appLifecycleService: self.appLifecycleService,
                                       selectedDateService: self.selectedDateService)
        return viewModel
    }

    func getTimelineViewModel(forDate date: Date) -> TimelineViewModel
    {
        let viewModel = TimelineViewModel(date: date,
                                          timeService: self.timeService,
                                          timeSlotService: self.timeSlotService,
                                          editStateService: self.editStateService,
                                          appLifecycleService: self.appLifecycleService,
                                          loggingService: self.loggingService,
                                          settingsService: self.settingsService,
                                          metricsService: self.metricsService)
        return viewModel
    }
    
    func getLocationPermissionViewModel() -> PermissionViewModel
    {
        let viewModel = LocationPermissionViewModel(timeService: self.timeService,
                                                    settingsService: self.settingsService,
                                                    appLifecycleService: self.appLifecycleService)
        
        return viewModel
    }
    
    func getHealthKitPermissionViewModel() -> PermissionViewModel
    {
        let viewModel = HealthKitPermissionViewModel(timeService: self.timeService,
                                                     settingsService: self.settingsService,
                                                     appLifecycleService: self.appLifecycleService,
                                                     healthKitService: self.healthKitService)
        
        return viewModel
    }
    
    func getCalendarViewModel() -> CalendarViewModel
    {
        let viewModel = CalendarViewModel(timeService: self.timeService,
                                          settingsService: self.settingsService,
                                          timeSlotService: self.timeSlotService,
                                          selectedDateService: self.selectedDateService)
        
        return viewModel
    }
    
    func getWeeklySummaryViewModel() -> WeeklySummaryViewModel
    {
        return WeeklySummaryViewModel(
            timeService: timeService,
            timeSlotService: timeSlotService,
            settingsService: settingsService
        )
    }
    
    func getDailySummaryViewModel(forDate date: Date) -> DailySummaryViewModel
    {
        let viewModel = DailySummaryViewModel(date: date,
                                              timeService: self.timeService,
                                              timeSlotService: self.timeSlotService,
                                              appLifecycleService: self.appLifecycleService,
                                              loggingService: self.loggingService)
        return viewModel
    }
    
    func getSummaryViewModel() -> SummaryViewModel
    {
        return SummaryViewModel(selectedDateService: self.selectedDateService)
    }
    
    func getSummaryPageViewModel(forDate date: Date) -> SummaryPageViewModel
    {
        return SummaryPageViewModel(date: date,
                                    timeService: self.timeService,
                                    settingsService: self.settingsService)
    }
}
