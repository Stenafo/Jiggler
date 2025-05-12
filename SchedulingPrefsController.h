objectivec
#import <Cocoa/Cocoa.h>
#import "Scheduler.h"

NS_ASSUME_NONNULL_BEGIN

@interface SchedulingPrefsController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSTableView *intervalsTableView;
@property (weak) IBOutlet NSButton *addButton;
@property (weak) IBOutlet NSButton *removeButton;
@property (weak) IBOutlet NSDatePicker *startTimePicker;
@property (weak) IBOutlet NSDatePicker *endTimePicker;

- (IBAction)addInterval:(id)sender;
- (IBAction)removeInterval:(id)sender;

@end

NS_ASSUME_NONNULL_END