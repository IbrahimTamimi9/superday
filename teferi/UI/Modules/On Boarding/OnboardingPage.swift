import UIKit
import RxSwift

class OnboardingPage : UIViewController
{
    //MARK: Public Properties
    var allowPagingSwipe : Bool { return self.nextButtonText != nil }

    private(set) var didAppear = false
    private(set) var nextButtonText : String?
    
    private(set) var timeService : TimeService!
    private(set) var timeSlotService : TimeSlotService!
    private(set) var settingsService : SettingsService!
    private(set) var appLifecycleService : AppLifecycleService!
    private(set) var notificationService : NotificationService!
    
    private(set) var onboardingPageViewController : OnboardingViewController!
    
    //MARK: Initializers
    init?(coder aDecoder: NSCoder, nextButtonText: String?)
    {
        super.init(coder: aDecoder)
        
        self.nextButtonText = nextButtonText
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Public Methods
    
    func inject(_ timeService: TimeService,
                _ timeSlotService: TimeSlotService,
                _ settingsService: SettingsService,
                _ appLifecycleService: AppLifecycleService,
                _ notificationService: NotificationService,
                _ onboardingPageViewController: OnboardingViewController)
    {
        self.timeService = timeService
        self.timeSlotService = timeSlotService
        self.settingsService = settingsService
        self.appLifecycleService = appLifecycleService
        self.notificationService = notificationService
        self.onboardingPageViewController = onboardingPageViewController
    }
    
    //MARK: Private Methods
    internal func finish()
    {
        DispatchQueue.main.async {
            self.onboardingPageViewController.goToNextPage(forceNext: false)
        }
    }

    internal func startAnimations()
    {
        // override in page
    }

    @objc internal func appBecameActive()
    {
        // override in page
    }

    internal func getDate(addingHours hours : Int, andMinutes minutes : Int) -> Date
    {
        return timeService.now
            .ignoreTimeComponents()
            .addingTimeInterval(TimeInterval((hours * 60 + minutes) * 60))
    }

    internal func createTimelineCell(for timeSlot: TimeSlot) -> TimelineCell
    {
        let cell = Bundle.main
            .loadNibNamed("TimelineCell", owner: self, options: nil)?
            .first as! TimelineCell
        
        let duration = timeSlotService.calculateDuration(ofTimeSlot: timeSlot)
        let timelineItem = TimelineItem(timeSlot: timeSlot,
                                        durations:[ duration ],
                                        lastInPastDay: false,
                                        shouldDisplayCategoryName: true)
        
        cell.bind(toTimelineItem: timelineItem, index: 0, duration: duration)
        return cell
    }

    internal func initAnimatedTitleText(_ view: UIView)
    {
        view.transform = CGAffineTransform(translationX: 100, y: 0)
    }

    internal func animateTitleText(_ view: UIView, duration: TimeInterval, delay: TimeInterval)
    {
        UIView.animate(withDuration: duration, delay: delay, options: .curveEaseOut, animations:
            {
                view.transform = CGAffineTransform(translationX: 0, y: 0)
        },
                       completion: nil)
    }
    
    internal func initAnimatingTimeline(with slots: [TimeSlot], in containingView: UIView) -> [TimelineCell]
    {
        
        let cells = createTimelineCells(for: slots)
        
        var previousCell:TimelineCell?
        for cell in cells
        {
            containingView.addSubview(cell)
            
            cell.snp.makeConstraints { make in
                if let previousCell = previousCell
                {
                    make.top.equalTo(previousCell.snp.bottom)
                }
                else {
                    make.top.equalToSuperview()
                }
                make.leading.trailing.equalToSuperview()
            }
            
            cell.transform = CGAffineTransform(translationX: 0, y: 15)
            cell.alpha = 0
            
            previousCell = cell
        }
        
        return cells
    }
    
    internal func animateTimeline(_ cells: [TimelineCell], delay initialDelay: TimeInterval)
    {
        var delay = initialDelay
        
        for cell in cells
        {
            UIView.animate(withDuration: 0.6, delay: delay, options: .curveEaseOut, animations:
                {
                    cell.transform = CGAffineTransform(translationX: 0, y: 0)
                    cell.alpha = 1
            },
                           completion: nil)
            
            delay += 0.2
        }
    }
    
    internal func getTimeSlot(withStartTime startTime: Date, endTime: Date, category: Category) -> TimeSlot
    {
        let timeSlot = TimeSlot(withStartTime: startTime,
                                category: category,
                                categoryWasSetByUser: false)
        timeSlot.endTime = endTime
        
        return timeSlot
    }

    private func createTimelineCells(for timeSlots: [TimeSlot]) -> [TimelineCell]
    {
        return timeSlots.map(createTimelineCell)
    }

    
    //MARK: ViewController lifecycle

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        guard !didAppear else { return }
        didAppear = true
        
        startAnimations()
    }
}
