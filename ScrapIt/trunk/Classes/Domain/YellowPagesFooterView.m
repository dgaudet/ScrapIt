//
//  YellowPagesFooterView.m
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-11-12.
//
//

#import "YellowPagesFooterView.h"
#import "AnalyticsService.h"
#import "DeviceUtil.h"

@interface YellowPagesFooterView (PrivateMethods)

- (void)logoPressed;
- (void)displayInView:(UIView *)view animated:(BOOL)animated withYOffset:(float)yOffset;

@end

@implementation YellowPagesFooterView

float footerHeight = 20.0;

- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, 320, footerHeight)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.5]];
        _yellowPagesLogo = [UIImage imageNamed:@"YellowPagesLogo"];
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setImage:_yellowPagesLogo forState:UIControlStateNormal];
        [_button setFrame:CGRectMake(self.frame.size.width - _yellowPagesLogo.size.width, -8, _yellowPagesLogo.size.width, _yellowPagesLogo.size.height)];
        [_button addTarget:self action:@selector(logoPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];
    }
    return self;
}

- (void)displayInUITableViewController:(UITableViewController *)tableViewController animated:(BOOL)animated {
    float yOffset = 0;
    if ([DeviceUtil isCurrentDeviceOSMainVersionEqualTo:7]) {
        yOffset = 64;
    }
    [self displayInView:tableViewController.view animated:animated withYOffset:yOffset];
}

- (void)displayInUIViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self displayInView:viewController.view animated:animated withYOffset:0];
}

- (void)displayInView:(UIView *)view animated:(BOOL)animated withYOffset:(float)yOffset {
    [view addSubview:self];
    if (self.hidden) {
        [self setHidden:NO];
    }
    float y = view.frame.size.height - yOffset;
    CGRect startFrame = CGRectMake(view.frame.origin.x, y, view.frame.size.width, footerHeight);
    [self setFrame:startFrame];
    
    CGRect finalRect = CGRectMake(startFrame.origin.x, y - footerHeight, startFrame.size.width, footerHeight);
    if (animated) {
        [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self setFrame:finalRect];
        } completion:^(BOOL finished) {    }];
    } else {
        [self setFrame:finalRect];
    }
}

- (void)logoPressed {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kYellowPagesBadgeLinkUrl]]) {
        [self loadAlertViewWithMessage:@"Leave scrap it and view Yellow Pages in Safari?" andOkButtonTile:@"Leave"];
    }
}

- (void)loadAlertViewWithMessage:(NSString *)message andOkButtonTile:(NSString *)okTitle {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:message
                                                   delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:okTitle, nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:kYellowPagesBadgeLinkUrl]]) {
            [AnalyticsService logEmailedSupportEvent];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kYellowPagesBadgeLinkUrl]];
        }
    }
}

@end
