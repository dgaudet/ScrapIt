//
//  ThemeHelper.m
//  ScrapIt
//
//  Created by Dean on 2013-02-28.
//
//

#import "ThemeHelper.h"
#import "DeviceUtil.h"

@implementation ThemeHelper

+ (void)setDefaultBackgroundForTableView:(UITableView *)tableView {
    NSString *imageName = @"PaperTexture";
    if ([DeviceUtil isCurrentDeviceIPhone5]) {
        imageName = @"PaperTexture-568h";
    }
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView = nil;
    CGRect backgroundRect = [[UIScreen mainScreen] bounds];
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:backgroundRect];
    
    [backgroundView setImage:[UIImage imageNamed:imageName]];
    [backgroundView setContentMode:UIViewContentModeBottom];
    
    [tableView setBackgroundView:backgroundView];
}

+ (void)setBackgroundForCreditsTableView:(UITableView *)tableView {
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
}

+ (void)setColorForNavBar:(UINavigationBar *)navBar {
    if ([navBar respondsToSelector:@selector(setBarTintColor:)]) {
        //iOS 7 style
        [navBar setBarTintColor:nil];
    } else {
        navBar.tintColor = [UIColor purpleColor];
    }
}

+ (UIFont *)tableViewTitleFont {
    return [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
}

@end
