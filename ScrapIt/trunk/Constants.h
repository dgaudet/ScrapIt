//
//  Constants.h
//  ScrapIt
//
//  Created by Dean Gaudet on 2012-09-29.
//
//

#ifndef ScrapIt_Constants_h
#define ScrapIt_Constants_h

#define kYellowPagesApiKey @"9k5g4bqucenr9ztnh9x693cw"
#define kYellowPagesBadgeLinkUrl @"http://badge.yellowapi.com/"
#define kYellowPagesLegalText @"Yellow Pages Group & Design is a trademark of Yellow Pages Group Co. in Canada."

#define kYellowPagesBaseUrl @"http://api.sandbox.yellowapi.com"

#define kSystemDefaultFont [UIFont fontWithName:@"Helvetica-Bold" size:17.0]

#define kSystemAppSupportEmail @"support@deangaudet.com"

#ifdef Test
#define kScrapItServicesBaseUrl @"http://localhost:8080/"
#else
#define kScrapItServicesBaseUrl @"http://deangaudet.com/"
#endif

#endif
