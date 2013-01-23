//
//  EmailService.h
//  ScrapIt
//
//  Created by Dean on 2013-01-20.
//
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface EmailService : NSObject

+ (void)setupSupportEmailForMailController:(MFMailComposeViewController *)mailController;

@end
