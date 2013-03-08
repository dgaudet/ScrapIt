//
//  Constants.h
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-09-29.
//
//

#ifndef ScrapIt_Constants_h
#define ScrapIt_Constants_h

#define kYellowPagesBadgeLinkUrl @"http://badge.yellowapi.com/"
#define kYellowPagesLegalText @"Yellow Pages Group & Design is a trademark of Yellow Pages Group Co. in Canada."

#define kSystemDefaultFont [UIFont fontWithName:@"Helvetica-Bold" size:17.0]

#define kSystemAppSupportEmail @"support@deangaudet.com"

#ifdef Test
#define kScrapItServicesBaseUrl @"http://localhost:8080/"
#else
#define kScrapItServicesBaseUrl @"http://deangaudet.com/"
#endif

#ifdef Test
#define kGoogleAnalyticsTrackingCode @"UA-38534491-2"
#else
#define kGoogleAnalyticsTrackingCode @"UA-38534491-1"
#endif

#define kCrashlyticsCode @"a5e729783a2ccbc18626b6a118870aae9c94ed75"

#endif
