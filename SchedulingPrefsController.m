objectivec
#import "SchedulingPrefsController.h"
#import "AppDelegate.h"
#import "Scheduler.h"

@interface SchedulingPrefsController ()

@property (nonatomic, weak) AppDelegate *appDelegate;

@end

@implementation SchedulingPrefsController

@synthesize timeIntervalsTableView;
@synthesize startTimePicker;
@synthesize endTimePicker;
@synthesize addIntervalButton;
@synthesize removeIntervalButton;

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.appDelegate = (AppDelegate *)[NSApp delegate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [self.timeIntervalsTableView setDelegate:self];
    [self.timeIntervalsTableView reloadData];
}

#pragma mark - Actions

- (IBAction)addInterval:(id)sender {
}

- (IBAction)addInterval:(id)sender {
    // Get the selected times from the date pickers
    NSTimeInterval startTime = [self.startTimePicker dateValue].timeIntervalSinceReferenceDate;
    NSTimeInterval endTime = [self.endTimePicker dateValue].timeIntervalSinceReferenceDate;
}

- (IBAction)removeInterval:(id)sender {
    NSInteger selectedRow = [self.timeIntervalsTableView selectedRow];
    if (selectedRow != -1) {
        [self.appDelegate.scheduler removeTimeIntervalAtIndex:selectedRow];
        [self.timeIntervalsTableView reloadData];
    }
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.appDelegate.scheduler.timeIntervals count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSDictionary *interval = [self.appDelegate.scheduler.timeIntervals objectAtIndex:row];
    NSTimeInterval startSeconds = [[interval objectForKey:@"start"] doubleValue];
    NSTimeInterval endSeconds = [[interval objectForKey:@"end"] doubleValue];

    NSDateComponents *startComponents = [[NSDateComponents alloc] init];
    startComponents.hour = startSeconds / 3600;
    startComponents.minute = (fmod(startSeconds, 3600)) / 60;

    NSDateComponents *endComponents = [[NSDateComponents alloc] init];
    endComponents.hour = endSeconds / 3600;
    endComponents.minute = (fmod(endSeconds, 3600)) / 60;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];

    if ([[tableColumn identifier] isEqualToString:@"StartTime"]) {
        NSDate *startDate = [calendar dateFromComponents:startComponents];
        return [formatter stringFromDate:startDate];
    } else if ([[tableColumn identifier] isEqualToString:@"EndTime"]) {
        NSDate *endDate = [calendar dateFromComponents:endComponents];
        return [formatter stringFromDate:endDate];
    }

    return nil;
}

#pragma mark - NSTableViewDelegate

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row {
    return YES;
}

@end