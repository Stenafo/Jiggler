objectivec
#import "Scheduler.h"

@interface Scheduler ()

@property (nonatomic, strong) NSMutableArray<NSTimeIntervalInterval *> *timeIntervals;
@property (nonatomic, strong) NSString *defaultsKey;

@property (nonatomic, strong) NSTimer *checkTimer;
@property (nonatomic, assign) BOOL isActive;

@end

@implementation Scheduler

- (instancetype)init {
    self = [super init];
    if (self) {
        _defaultsKey = @"ScheduledTimeIntervals"; // Unique key for NSUserDefaults
 _timeIntervals = [NSMutableArray array]; // Initialize here, will be replaced by loaded data
        _isActive = NO;
 [self loadTimeIntervals]; // Load intervals on initialization
        [self startCheckTimer];
    }
    return self;
}

- (void)dealloc {
    [self stopCheckTimer];
}

- (void)addTimeInterval:(NSTimeIntervalInterval *)interval {
    [self.timeIntervals addObject:interval];
 [self saveTimeIntervals];
    [self checkActiveState];
}

- (void)removeTimeInterval:(NSTimeIntervalInterval *)interval {
    [self.timeIntervals removeObject:interval];
 [self saveTimeIntervals];
    [self checkActiveState];
}

- (BOOL)isCurrentTimeWithinIntervals {
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *nowComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:now];
    NSTimeInterval currentTimeInSeconds = nowComponents.hour * 3600 + nowComponents.minute * 60 + nowComponents.second;

    for (NSTimeIntervalInterval *interval in self.timeIntervals) {
        NSTimeInterval startInSeconds = interval.startHour * 3600 + interval.startMinute * 60;
        NSTimeInterval endInSeconds = interval.endHour * 3600 + interval.endMinute * 60;

        if (startInSeconds <= endInSeconds) { // Interval does not cross midnight
            if (currentTimeInSeconds >= startInSeconds && currentTimeInSeconds <= endInSeconds) {
                return YES;
            }
        } else { // Interval crosses midnight
            if (currentTimeInSeconds >= startInSeconds || currentTimeInSeconds <= endInSeconds) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)checkActiveState {
    BOOL shouldBeActive = [self isCurrentTimeWithinIntervals];
    if (shouldBeActive != self.isActive) {
        self.isActive = shouldBeActive;
        if ([self.delegate respondsToSelector:@selector(scheduler:didChangeActiveState:)]) {
            [self.delegate scheduler:self didChangeActiveState:self.isActive];
        }
    }
}

- (void)startCheckTimer {
    // Check every minute
    self.checkTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(checkActiveState) userInfo:nil repeats:YES];
}

- (void)saveTimeIntervals {
    NSMutableArray *intervalArray = [NSMutableArray array];
    for (NSTimeIntervalInterval *interval in self.timeIntervals) {
        NSDictionary *intervalDict = @{
            @"startHour": @(interval.startHour),
            @"startMinute": @(interval.startMinute),
            @"endHour": @(interval.endHour),
            @"endMinute": @(interval.endMinute)
        };
        [intervalArray addObject:intervalDict];
    }
    [[NSUserDefaults standardUserDefaults] setObject:intervalArray forKey:self.defaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadTimeIntervals {
    NSArray *intervalArray = [[NSUserDefaults standardUserDefaults] arrayForKey:self.defaultsKey];
    if (intervalArray) {
        [self.timeIntervals removeAllObjects]; // Clear existing intervals
        for (NSDictionary *intervalDict in intervalArray) {
            NSTimeIntervalInterval *interval = [[NSTimeIntervalInterval alloc] initWithStartHour:[intervalDict[@"startHour"] integerValue] startMinute:[intervalDict[@"startMinute"] integerValue] endHour:[intervalDict[@"endHour"] integerValue] endMinute:[intervalDict[@"endMinute"] integerValue]];
            [self.timeIntervals addObject:interval];
        }
    }
}

- (void)stopCheckTimer {
    [self.checkTimer invalidate];
    self.checkTimer = nil;
}

@end


@implementation NSTimeIntervalInterval

- (instancetype)initWithStartHour:(NSInteger)startHour startMinute:(NSInteger)startMinute endHour:(NSInteger)endHour endMinute:(NSInteger)endMinute {
    self = [super init];
    if (self) {
        _startHour = startHour;
        _startMinute = startMinute;
        _endHour = endHour;
        _endMinute = endMinute;
    }
    return self;
}

@end