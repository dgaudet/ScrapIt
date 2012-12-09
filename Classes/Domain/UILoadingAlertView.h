//
//  UILoadingAlertView.h
//  ScrapIt
//
//  Created by Dean Gaudet on 12-02-15.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILoadingAlertView : NSObject {
    UIAlertView *alertView;
    UIActivityIndicatorView *spinner;
}

- (id)initWithTitle:(NSString *)title;
- (void)show;
- (void)dismiss;

@end
