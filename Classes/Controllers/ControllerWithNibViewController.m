//
//  ControllerWithNibViewController.m
//  ScrapIt
//
//  Created by Dean on 2013-06-01.
//
//

#import "ControllerWithNibViewController.h"

@interface ControllerWithNibViewController ()

@end

@implementation ControllerWithNibViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
//    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:17.0];
//    [self.view addSubview:label];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
