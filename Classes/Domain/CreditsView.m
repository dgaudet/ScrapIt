//
//  CreditsView.m
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-11-18.
//
//

#import "CreditsView.h"

@implementation CreditsView

- (id)init {
    return [self initWithFrame:CGRectMake(10, 480, 300, 400)];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 20)];
//        [title setTextColor:[UIColor lightGrayColor]];
//        [title setTextAlignment:UITextAlignmentCenter];
//        [title setBackgroundColor:[UIColor clearColor]];
//        [title setText:@"Credits"];
//        
//        [self addSubview:title];
        
        //add app version info and icon
        //add yellow pages law stuff
        //add credits for paper background
        //thank family
        //dedicate to family
        UILabel *dedication = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, frame.size.width, 42)];
        NSString *dedicationText = @"I would like to thank my family for giving me the time, and idea for this project. Without their support none of this would be possible";
        CGSize size = CGSizeMake(frame.size.width, CGFLOAT_MAX);
        CGSize dedicationLabelSize = [dedicationText sizeWithFont:kSystemDefaultFont constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        NSLog(@"height: %f width: %f", dedicationLabelSize.height, dedicationLabelSize.width);
        [dedication setFrame:CGRectMake(dedication.frame.origin.x, dedication.frame.origin.y, dedicationLabelSize.width, dedicationLabelSize.height)];
        [dedication setFont:kSystemDefaultFont];
        [dedication setTextColor:[UIColor lightGrayColor]];
        [dedication setTextAlignment:NSTextAlignmentCenter];
        [dedication setBackgroundColor:[UIColor clearColor]];
        [dedication setLineBreakMode:NSLineBreakByWordWrapping];
        [dedication setNumberOfLines:0];
        [dedication setText:dedicationText];
        
        [self addSubview:dedication];
    }
    return self;
}

- (void)showInView:(UIView *)view {
    [view addSubview:self];
    CGRect finalRect = CGRectMake(self.frame.origin.x, 50, self.frame.size.width, self.frame.size.height);
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self setFrame:finalRect];
    } completion:^(BOOL finished) {    }];
}

- (void)hide {
    [self setAlpha:0.0];
}

@end
