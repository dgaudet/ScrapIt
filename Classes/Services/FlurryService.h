//
//  FlurryService.h
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-09-16.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern void flurryServiceUncaughtExceptionHandler(NSException *exception);

@interface FlurryService : NSObject

+ (void)startFlurry;
+ (void)logSearchEventForBusinessWithCity:(NSString *)city andProvince:(NSString *)province;
+ (void)logBusinessEventForStoresWithLocation:(CLLocationCoordinate2D)location;
+ (void)logDetailViewEventForBusiness:(NSString *)businessName inCity:(NSString *)city andProvince:(NSString *)province;

@end
