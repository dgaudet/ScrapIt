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
+ (void)setColorForNavBar:(UINavigationBar *)navBar;
+ (UIView *)viewForMapAnnotationCallout;
+ (UIFont *)tableViewTitleFont;
+ (void)setBackgroundForCreditsTableView:(UITableView *)tableView;
+ (UIColor *)rowSeparatorColorForCreditsView;
+ (UIColor *)mainTextColorForCreditsView;
+ (UIColor *)subTextColorForCreditsView;

@end
