//
//  WSDownloader.m
//  WorkspaceManagement
//
//  Created by Technique on 06/04/2016.
//  Copyright © 2016 docapost. All rights reserved.
//

#import "WSDownloader.h"

@implementation WSDownloader

- (void)startDownload:(NSString*)idDevice withStartDate:(NSString*)startDate andEndDate:(NSString*)endDate
{
    self.url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.rec.docapost.io/mediation/v1/partner/get?idDevice=%@&startDate=%@&endDate=%@&count=1",idDevice,startDate,endDate]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url];
    request.timeoutInterval = 10.0;
    
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.responseData  = [[NSMutableData alloc] init];
}

#pragma mark NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    if ( challenge.previousFailureCount == 0) {
        
        NSLog(@"received authentication challenge");
        
        NSURLCredential *newCredential = [NSURLCredential credentialWithUser:@"5caae365-bb88-42e2-a4a0-5a81cd071f3d"
                                                                    password:@"wXyHnxckgWYK"
                                                                 persistence:NSURLCredentialPersistenceForSession];
        NSLog(@"credential created");
        
        [challenge.sender useCredential:newCredential
             forAuthenticationChallenge:challenge];
        
        NSLog(@"responded to authentication challenge");
    }
    else
    {
        NSLog(@"previous authentication failure");
    }
}


- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    self.statusCode = httpResponse.statusCode;
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (self.statusCode == 200)
        [self.responseData appendData:data];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self.delegate downloadFailed:error];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.delegate didSuccessDownload:self.responseData];
}

@end
