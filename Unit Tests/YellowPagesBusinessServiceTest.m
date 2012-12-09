//
//  YellowPagesBusinessServiceTest.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-07-24.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YellowPagesBusinessServiceTest.h"
#import "YellowPagesBusinessService.h"

@implementation YellowPagesBusinessServiceTest

- (void)setUp
{
    [super setUp];
    yellowPagesService = [YellowPagesBusinessService sharedInstance];
    
}

- (void)testEncodedBusinessName_shouldReplaceSpacesWithDashes {
    NSString *name = @"hello space";
    NSString *expectedResult = @"hello-space";
    
    NSString *result = [yellowPagesService encodeBusinessName:name];
    
    STAssertTrue([result isEqualToString:expectedResult], @"Result should have dash was %@", result);
}

- (void)testEncodedBusinessName_shouldReplaceADashWithTwoDashes {
    NSString *name = @"hello-dash";
    NSString *expectedResult = @"hello--dash";
    
    NSString *result = [yellowPagesService encodeBusinessName:name];
    
    STAssertTrue([result isEqualToString:expectedResult], @"Result should have two dashes was %@", result);
}

- (void)testEncodedBusinessName_shouldReplaceAmpersandWithDash {
    NSString *name = @"hello&ampersand";
    NSString *expectedResult = @"hello-ampersand";
    
    NSString *result = [yellowPagesService encodeBusinessName:name];
    
    STAssertTrue([result isEqualToString:expectedResult], @"Result should have dash was %@", result);
}

- (void)testEncodedBusinessName_shouldReplaceQuestionMarkWithDash {
    NSString *name = @"hello?question";
    NSString *expectedResult = @"hello-question";
    
    NSString *result = [yellowPagesService encodeBusinessName:name];
    
    STAssertTrue([result isEqualToString:expectedResult], @"Result should have dash was %@", result);
}

- (void)testEncodedBusinessName_shouldReplacePercentMarkWithDash {
    NSString *name = @"hello%percent";
    NSString *expectedResult = @"hello-percent";
    
    NSString *result = [yellowPagesService encodeBusinessName:name];
    
    STAssertTrue([result isEqualToString:expectedResult], @"Result should have dash was %@", result);
}

- (void)testEncodedBusinessName_shouldReplacePeriodMarkWithDash {
    NSString *name = @"hello.period";
    NSString *expectedResult = @"hello-period";
    
    NSString *result = [yellowPagesService encodeBusinessName:name];
    
    STAssertTrue([result isEqualToString:expectedResult], @"Result should have dash was %@", result);
}

@end