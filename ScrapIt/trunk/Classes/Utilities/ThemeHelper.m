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

+ (void)setBackgroundViewForTableView:(UITableView *)tableView {
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

//+ (void)setBackgroundViewForTableView:(UITableView *)tableView {
//    tableView.backgroundColor = [UIColor clearColor];
//    tableView.backgroundView = nil;
//}

@end
