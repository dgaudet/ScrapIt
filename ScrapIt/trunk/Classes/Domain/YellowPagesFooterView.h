//
//  YellowPagesFooterView.h
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-11-12.
//
//

#import <UIKit/UIKit.h>

@interface YellowPagesFooterView : UIView {
    UIImage *_yellowPagesLogo;
    UIButton *_button;
}

- (void)displayInUIViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)displayInUITableViewController:(UITableViewController *)tableViewController animated:(BOOL)animated;

@end
