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

@end

@implementation YellowPagesFooterView

- (id)init {
    float y = [DeviceUtil screenSize].height - 64;
    return [self initWithFrame:CGRectMake(0, y, 320, 20)];
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

- (void)displayInView:(UIView *)view animated:(BOOL)animated {
    [view addSubview:self];
    float y = [DeviceUtil screenSize].height - 84;
    CGRect finalRect = CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height);
    if (animated) {
        [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationCurveEaseOut animations:^{
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
