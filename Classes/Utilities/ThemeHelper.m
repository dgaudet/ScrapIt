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
    [backgroundView release];
}

+ (void)setColorForNavBar:(UINavigationBar *)navBar {
    if ([navBar respondsToSelector:@selector(setBarTintColor:)]) {
        //iOS 7 style
        [navBar setBarTintColor:nil];
    } else {
        navBar.tintColor = [UIColor purpleColor];
    }
}

+ (UIView *)viewForMapAnnotationCallout {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    UIImage *disclosureImage = [[UIImage imageNamed:@"chevron"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    button.frame = CGRectMake(0, 0, disclosureImage.size.width, disclosureImage.size.height);
    [button setImage:disclosureImage forState:UIControlStateNormal];
    return button;
}

+ (UIFont *)tableViewTitleFont {
    return [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
}

#pragma mark CreditsTableView Methods
+ (void)setBackgroundForCreditsTableView:(UITableView *)tableView {
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor lightGrayColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

+ (UIColor *)rowSeparatorColorForCreditsView {
    return [UIColor darkGrayColor];
}

+ (UIColor *)mainTextColorForCreditsView {
    return [UIColor whiteColor];
}

+ (UIColor *)subTextColorForCreditsView {
    return [UIColor blackColor];
}

@end
