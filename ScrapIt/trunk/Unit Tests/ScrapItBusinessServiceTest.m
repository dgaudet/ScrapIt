//
//  ScrapItBusinessServiceTest.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-07-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScrapItBusinessServiceTest.h"
#import "ScrapItBusinessService.h"

@implementation ScrapItBusinessServiceTest

- (void)setUp
{
    [super setUp];
    scrapItBusinessService = [ScrapItBusinessService sharedInstance];
}

- (void)testEncodedBusinessName_shouldReplaceSpacesWithDashes {
    NSString *name = @"hello space";
    NSString *expectedResult = @"hello-space";
    
    NSString *result = [scrapItBusinessService encodeBusinessName:name];
    
    STAssertTrue([result isEqualToString:expectedResult], @"Result should have dash was %@", result);
}

- (void)testEncodedBusinessName_shouldReplaceADashWithTwoDashes {
    NSString *name = @"hello-dash";
    NSString *expectedResult = @"hello--dash";
    
    NSString *result = [scrapItBusinessService encodeBusinessName:name];
    
    STAssertTrue([result isEqualToString:expectedResult], @"Result should have two dashes was %@", result);
}

- (void)testEncodedBusinessName_shouldReplaceAmpersandWithDash {
    NSString *name = @"hello&ampersand";
    NSString *expectedResult = @"hello-ampersand";
    
    NSString *result = [scrapItBusinessService encodeBusinessName:name];
    
    STAssertTrue([result isEqualToString:expectedResult], @"Result should have dash was %@", result);
}

- (void)testEncodedBusinessName_shouldReplaceQuestionMarkWithDash {
    NSString *name = @"hello?question";
    NSString *expectedResult = @"hello-question";
    
    NSString *result = [scrapItBusinessService encodeBusinessName:name];
    
    STAssertTrue([result isEqualToString:expectedResult], @"Result should have dash was %@", result);
}

- (void)testEncodedBusinessName_shouldReplacePercentMarkWithDash {
    NSString *name = @"hello%percent";
    NSString *expectedResult = @"hello-percent";
    
    NSString *result = [scrapItBusinessService encodeBusinessName:name];
    
    STAssertTrue([result isEqualToString:expectedResult], @"Result should have dash was %@", result);
}

- (void)testEncodedBusinessName_shouldReplacePeriodMarkWithDash {
    NSString *name = @"hello.period";
    NSString *expectedResult = @"hello-period";
    
    NSString *result = [scrapItBusinessService encodeBusinessName:name];
    
    STAssertTrue([result isEqualToString:expectedResult], @"Result should have dash was %@", result);
}

@end