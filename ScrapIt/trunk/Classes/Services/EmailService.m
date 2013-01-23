//
//  EmailService.m
//  ScrapIt
//
//  Created by Dean on 2013-01-20.
//
//
//ToDo: possibly initialize it with a UINavigationController or a view
// then use that object to present and dismiss controller from it

#import "EmailService.h"

@implementation EmailService

+ (void)setupSupportEmailForMailController:(MFMailComposeViewController *)mailController {
    [mailController setSubject:@"Support Request"];
    [mailController setToRecipients:[NSArray arrayWithObject:kSystemAppSupportEmail]];
}

@end
