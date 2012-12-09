//
//  UILoadingAlertView.m
//  ScrapIt
//
//  Created by Dean Gaudet on 12-02-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UILoadingAlertView.h"

@implementation UILoadingAlertView

- (id)init {
    return [self initWithTitle:@"Loading ..."];
}

- (id)initWithTitle:(NSString *)title {
    self = [super init];
    if(self){
        alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        UIApplication* app = [UIApplication sharedApplication]; 
        app.networkActivityIndicatorVisible = YES;
        spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];        
        [spinner startAnimating];
        spinner.frame = CGRectMake(130, 50, 25, 25);
        
        [alertView addSubview:spinner];
    }
    return self;
}


- (void)show {
    [alertView show];
}

- (void)dismiss {
    if (spinner) {
        UIApplication* app = [UIApplication sharedApplication]; 
        app.networkActivityIndicatorVisible = NO;
        [spinner stopAnimating];
        [spinner removeFromSuperview];
        [spinner release];
        spinner = nil;
    }
    [alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)dealloc {
    [spinner release];
    [alertView release];
    [super dealloc];
}

@end
