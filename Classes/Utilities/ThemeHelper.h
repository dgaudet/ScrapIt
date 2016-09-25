//
//  ThemeHelper.h
//  ScrapIt
//
//  Created by Dean on 2013-02-28.
//
//

#import <Foundation/Foundation.h>

@interface ThemeHelper : NSObject

+ (void)setDefaultBackgroundForTableView:(UITableView *)tableView;
+ (void)setBackgroundForCreditsTableView:(UITableView *)tableView;
+ (void)setBackgroundForProvinceTableView:(UITableView *)tableView;
+ (void)setColorForNavBar:(UINavigationBar *)navBar;
+ (UIView *)viewForMapAnnotationCallout;
+ (UIFont *)tableViewTitleFont;

@end
