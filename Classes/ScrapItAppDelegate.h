//
//  ScrapItAppDelegate.h
//  ScrapIt
//
//  Created by Dean Gaudet on 11-05-13.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrapItAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navController;    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

