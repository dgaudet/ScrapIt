//
//  UILoadingAlertView.m
//  ScrapIt
//
//  Created by Dean Gaudet on 12-02-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UILoadingAlertView.h"

@implementation UILoadingAlertView

- (id)initWithTitle:(NSString *)title inController:(UIViewController *)controller {
    self = [super init];
    if(self){
        alertView = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
        _parentController = controller;
        UIApplication* app = [UIApplication sharedApplication];
        app.networkActivityIndicatorVisible = YES;
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];        
        [spinner startAnimating];
        spinner.frame = CGRectMake(130, 50, 25, 25);
        
        //[alertView addSubview:spinner];
    }
    return self;
}


- (void)showAnimated:(BOOL)animated completion:(void (^)(void))completion {
    [_parentController presentViewController:alertView animated:animated completion:completion];
}

- (void)dismissAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (spinner) {
        UIApplication* app = [UIApplication sharedApplication]; 
        app.networkActivityIndicatorVisible = NO;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        [spinner release];
        spinner = nil;
    }
    [_parentController dismissViewControllerAnimated:animated completion:completion];
}

- (void)dealloc {
    [spinner release];
    [alertView release];
    [super dealloc];
}

@end
