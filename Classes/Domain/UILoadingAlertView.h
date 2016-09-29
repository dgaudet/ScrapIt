//
//  UILoadingAlertView.h
//  ScrapIt
//
//  Created by Dean Gaudet on 12-02-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILoadingAlertView : NSObject {
    UIAlertController *alertView;
    UIViewController *_parentController;
    UIActivityIndicatorView *spinner;
}

- (id)initWithTitle:(NSString *)title inController:(UIViewController *)controller;
- (void)showAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
