//
//  WSDownloader.h
//  WorkspaceManagement
//
//  Created by Technique on 06/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WSDownloaderDelegate
- (void) downloadFailed:(NSError*)error;
- (void) didSuccessDownload:(NSData*)data;
@end

@interface WSDownloader : NSObject <NSURLConnectionDelegate>

@property (nonatomic, weak) id <WSDownloaderDelegate> delegate;

@property (nonatomic, strong) NSURL             *url;
@property (nonatomic, strong) NSURLConnection   *urlConnection;
@property (nonatomic, strong) NSMutableData     *responseData;
@property (nonatomic, assign) NSInteger         statusCode;


- (void)startDownload:(NSString*)idDevice withStartDate:(NSString*)startDate andEndDate:(NSString*)endDate;

@end