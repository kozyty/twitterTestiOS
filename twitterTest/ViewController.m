//
//  ViewController.m
//  twitterTest
//
//  Created by kozyty on 2014/08/18.
//  Copyright (c) 2014年 nanapi Inc. All rights reserved.
//

#import "ViewController.h"
#import "STTwitterAPI.h"

@interface ViewController ()

@property (nonatomic, strong) STTwitterAPI *twitter;

@property (strong, nonatomic) NSString *accessToken;
@property (strong, nonatomic) NSString *accessTokenSecret;

@end

#define kConsumerName @"登録したApp名"
#define kConsumerKey @"Developer登録したKey"
#define kConsumerKeySecret @"Developer登録したSecretKey"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerName:kConsumerName
                                                              consumerKey:kConsumerKey
                                                           consumerSecret:kConsumerKeySecret];
    [self.twitter postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
        self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
        [self.twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
            [self.twitter postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader
                                                                successBlock:^(NSString *oAuthToken,
                                                                               NSString *oAuthTokenSecret,
                                                                               NSString *userID,
                                                                               NSString *screenName) {
                                                                    self.accessToken = oAuthToken;
                                                                    self.accessTokenSecret = oAuthTokenSecret;
                                                                    NSLog(@"Token %@ secret %@",oAuthToken,oAuthTokenSecret);
                                                                    
                                                                } errorBlock:^(NSError *error) {
                                                                    NSLog(@"error %@",[error description]);
                                                                    
                                                                }];
        } errorBlock:^(NSError *error) {
            NSLog(@"error %@",[error description]);
        }];
    } errorBlock:^(NSError *error) {
        NSLog(@"error %@",[error description]);
    }];
    
    [self.twitter getSearchTweetsWithQuery:@"nanapiのアンサー"
                              successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                  NSLog(@"%@ %@", searchMetadata, statuses);
                              } errorBlock:^(NSError *error) {
                                  NSLog(@"%@", error);
                              }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
