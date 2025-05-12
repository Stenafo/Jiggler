objectivec
#import <Foundation/Foundation.h>

@class Scheduler;

NS_ASSUME_NONNULL_BEGIN

@protocol SchedulerDelegate <NSObject>

@required
- (void)scheduler:(Scheduler *)scheduler didChangeActiveState:(BOOL)isActive;

@end

@interface Scheduler : NSObject

@property (nonatomic, weak) id<SchedulerDelegate> delegate;

- (void)addIntervalFromHour:(NSInteger)startHour
                 startMinute:(NSInteger)startMinute
                   toHour:(NSInteger)endHour
                 endMinute:(NSInteger)endMinute;

- (void)removeIntervalFromHour:(NSInteger)startHour
                    startMinute:(NSInteger)startMinute
                      toHour:(NSInteger)endHour
                    endMinute:(NSInteger)endMinute;

- (BOOL)isCurrentlyActive;

- (void)saveIntervals;
- (void)loadIntervals;

@end

NS_ASSUME_NONNULL_END