    //
//  MapViewController.m
//  ScrapIt
//
//  Created by Dean Gaudet on 11-05-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "PlaceMark.h"
#import "BusinessListTableViewController.h"
#import "SearchService.h"
#import "UILoadingAlertView.h"
#import "YellowPagesFooterView.h"
#import "AnalyticsService.h"

//ToDo: do the correct thing? when you try to get a cities location but there isn't one found

@interface MapViewController (PrivateMethods)

- (void)addAnnotationsWithPlaceMarks:(NSArray *)placemarks;
- (void)loadBusinessListTableViewControllerWithBusiness:(Business *)business;
- (void)showLoadingIndicators;
- (void)hideLoadingIndicators;
+ (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message;
- (void)addYellowPagesFooterToView:(UIView *)view;

@end

@implementation MapViewController

@synthesize mapCenter, placemarksForCity;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [AnalyticsService logScreenViewWithName:@"Map - Business Search Results"];
    
	mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
	mapView.mapType = MKMapTypeStandard;
	mapView.delegate = self;
	
	MKCoordinateRegion region;
	region.center = mapCenter;
	MKCoordinateSpan span;
	span.latitudeDelta=1;
	span.longitudeDelta=1;
	region.span=span;	
	[mapView setRegion:region animated:NO];
	
	[self.view addSubview:mapView];
	[self addAnnotationsWithPlaceMarks:placemarksForCity];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

-(void)addAnnotationsWithPlaceMarks:(NSArray *)placemarks {
	for (PlaceMark *placemark in placemarks) {		
		[mapView addAnnotation:placemark];
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id <MKAnnotation>)annotation{
	//got this from http://blog.objectgraph.com/index.php/2009/04/08/iphone-sdk-30-playing-with-map-kit-part-3/	
	static NSString *reuseId = @"storeAnnotation";
	MKAnnotationView *annotationView = [aMapView dequeueReusableAnnotationViewWithIdentifier:reuseId];
    if (!annotationView) {
		annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId] autorelease];
//        annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:reuseId] autorelease];
//		annotationView.image = [UIImage imageNamed:@"bradCrop.png"];
		annotationView.canShowCallout = YES;
	}
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	annotationView.rightCalloutAccessoryView = button;
	annotationView.annotation = annotation;
	
	return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    PlaceMark *placeMark = view.annotation;	
    
    [self showLoadingIndicators];
    dispatch_queue_t myCustomQueue;
    myCustomQueue = dispatch_queue_create([[[NSBundle mainBundle] bundleIdentifier] UTF8String], NULL);
    
    dispatch_async(myCustomQueue, ^{
        NSError *error = nil;
        Business *business = [[SearchService sharedInstance] retrieveBusinessFromBusinessSummary:placeMark.businessSummary error:&error];
        if (error) {
            [self performSelectorOnMainThread:@selector(displayErrorToUser:) withObject:error waitUntilDone:NO];
        } else {
            [self performSelectorOnMainThread:@selector(loadBusinessListTableViewControllerWithBusiness:) withObject:business waitUntilDone:NO];
        }
    });
}

- (void)loadBusinessListTableViewControllerWithBusiness:(Business *)business {
    [self hideLoadingIndicators];
    BusinessListTableViewController *businessController = [[BusinessListTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
	businessController.business = business;
	[self.navigationController pushViewController:businessController animated:YES];
	[businessController release];
}

- (void)displayErrorToUser:(NSError *)error {
    [self hideLoadingIndicators];
    NSDictionary *errorInfo = [error userInfo];
    NSString *message = @"There was a problem completing your search.\nPlease try again.";
    if (errorInfo) {
        if ([errorInfo objectForKey:NSLocalizedDescriptionKey]) {
            message = [errorInfo objectForKey:NSLocalizedDescriptionKey];
        }
    }
    [MapViewController displayAlertWithTitle:nil message:[errorInfo objectForKey:NSLocalizedDescriptionKey]];
}

+ (void)displayAlertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [alert release];
}

- (void)showLoadingIndicators {
    if(!alertView){
        alertView = [[UILoadingAlertView alloc] initWithTitle:@"Loading Business ..."];
        [alertView show];
    }
}

- (void)hideLoadingIndicators {
    if (alertView) {
        [alertView dismiss];
        alertView = nil;
    }
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)addYellowPagesFooterToView:(UIView *)view {
    if (!footer) {
        footer = [[YellowPagesFooterView alloc] init];
    }
    [footer displayInView:view animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addYellowPagesFooterToView:self.view];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [footer setHidden:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[mapView release];
    if (alertView) {
        [alertView release];
    }
    if (footer) {
        [footer release];
    }
	[placemarksForCity release];
    [super dealloc];
}


@end
