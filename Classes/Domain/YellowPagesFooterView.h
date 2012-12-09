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

- (void)displayInView:(UIView *)view animated:(BOOL)animated;

@end
