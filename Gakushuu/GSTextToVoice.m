//
//  TextToVoice.m
//  Gakushuu
//
//  Created by Popcorn on 4/22/22.
//

#import "GSTextToVoice.h"

@interface TextToVoice ()

@end

@implementation TextToVoice

@synthesize text,player;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (id) initWithText: (NSString *) text
{
    self.text = text;
    [super viewDidLoad];
    state = IDLE;
    return self;
}

-(void) GetHomePage
{
    NSURL *nsurl = NULL;
    NSMutableURLRequest *request = NULL;
    NSURLSession *session = NULL;

    nsurl = [NSURL URLWithString:@"https://www.ibm.com/demos/live/tts-demo/self-service/home"];
    request= [NSMutableURLRequest requestWithURL:nsurl];

    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:66.0) Gecko/20100101 Firefox/66.0" forHTTPHeaderField:@"User-Agent"];
    
    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    
    [request setValue:@"https://www.ibm.com/demos/live/tts-demo/self-service" forHTTPHeaderField:@"Referer"];
    



    
    
    session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest: request
                 completionHandler:^(NSData *data,
                                     NSURLResponse *response,
                                     NSError *error) {
        NSHTTPURLResponse *httpResponse = NULL;
        NSDictionary *headers = NULL;
        headers = [httpResponse allHeaderFields];
            
            // Retrieve all occurrences of the "Set-Cookie" header
    
        for (NSString *key in headers) {
            NSLog(@"Key: %@", key);
            // You can access the corresponding value using objectForKey:
            id value = [headers objectForKey:key];
            NSLog(@"Value for %@: %@", key, value);
        }
        

        /*
            Get the cookies.
         */
        //httpResponse = (NSHTTPURLResponse *)response;
        
        //self->cookie =[[NSString alloc] initWithString:[httpResponse valueForHTTPHeaderField:@"Set-Cookie"]];
        
       // [self GetLink];
    }] resume];
}

-(void) GetLink
{
    NSURL *nsurl = NULL;
    NSMutableURLRequest *request=NULL;
    NSURLSession *session = NULL;
    NSString *body = NULL;
    NSString *uuid = NULL;
    NSData * bodyData = NULL;
    NSString *text = NULL;
    char* utfBody = NULL;
    
    uuid = [[NSUUID UUID] UUIDString];
    
    
    body = [NSString stringWithFormat:@"{\"ssmlText\":\"<prosody pitch=\\\"default\\\" rate=\\\"-0%%\\\">%@</prosody>\",\"sessionID\":\"%@\"}", self.text, uuid];
    
    utfBody = (char*) [body UTF8String];
    
    bodyData = [NSData dataWithBytes:utfBody length:strlen(utfBody)];   
    
    nsurl = [NSURL URLWithString:@"https://www.ibm.com/demos/live/tts-demo/api/tts/store"];
    request=[NSMutableURLRequest requestWithURL:nsurl];
    
    [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:66.0) Gecko/20100101 Firefox/66.0" forHTTPHeaderField:@"User-Agent"];
    [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
    [request setValue:@"https://www.ibm.com/demos/live/tts-demo/self-service/home" forHTTPHeaderField:@"Referer"];
    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%li", [bodyData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"https://www.ibm.com" forHTTPHeaderField:@"Origin"];
    [request setValue:@"Close" forHTTPHeaderField:@"Connection"];
    [request setValue:@"Cookie" forHTTPHeaderField:self->cookie];
    [request setValue:@"Sec-Fetch-Dest" forHTTPHeaderField:@"audio"];
    [request setValue:@"Sec-Fetch-Mode" forHTTPHeaderField:@"no-cors"];
    [request setValue:@"Sec-Fetch-Site" forHTTPHeaderField:@"same-origin"];
    [request setValue:@"Pragma" forHTTPHeaderField:@"no-cache"];
    [request setValue:@"Cache-Control" forHTTPHeaderField:@"no-cache"];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:bodyData];
    state = INIT;
    
    session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest: request
                 completionHandler:^(NSData *data,
                                     NSURLResponse *response,
                                     NSError *error) {
        
        NSLog(@"%s", [data bytes]);
#if 0
        NSError *jsonParsingError = NULL;
        NSDictionary *json = NULL;
        NSString *message = NULL;
        NSString *uuid = NULL;
        NSRange uuidRange;
        NSRange searchRange;
        NSHTTPURLResponse *httpResponse =NULL;
        NSString *cookies = NULL;
        
        NSMutableURLRequest *request=NULL;
        NSURL *nsurl = NULL;
        NSURLSession *session = NULL;

        
        json =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonParsingError];
        
        message =  [json objectForKey:@"message"];
        
        uuidRange = [message rangeOfString:@":"];
        
        searchRange = NSMakeRange(uuidRange.location +2 , [message length] - uuidRange.location-2);
        
        uuid = [message substringWithRange:searchRange];
        
        httpResponse = (NSHTTPURLResponse *) response;
        
        
        cookies = [httpResponse valueForHTTPHeaderField:@"Set-Cookie"];
        
        nsurl = [NSURL URLWithString:[NSString stringWithFormat: @"https://www.ibm.com/demos/live/tts-demo/api/tts/newSynthesize?voice=%@&id=%@",@"ja-JP_EmiV3Voice", uuid ]];
        
        [request setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:66.0) Gecko/20100101 Firefox/66.0" forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"application/json, text/plain, */*" forHTTPHeaderField:@"Accept"];
       // [request setValue:@"en-US,en;q=0." forHTTPHeaderField:@"Accept-Language"];
        [request setValue:@"bytes=0" forHTTPHeaderField:@"Range"];
        [request setValue:@"Close" forHTTPHeaderField:@"Connection"];
        [request setValue:@"Sec-Fetch-Dest" forHTTPHeaderField:@"audio"];
        [request setValue:@"Sec-Fetch-Mode" forHTTPHeaderField:@"no-cors"];
        [request setValue:@"Sec-Fetch-Site" forHTTPHeaderField:@"same-origin"];
        [request setValue:@"trailers" forHTTPHeaderField:@"TE"];
        [request setValue:@"Cookie" forHTTPHeaderField:self->cookie];
        [request setValue:@"Refer" forHTTPHeaderField:@"https://www.ibm.com/demos/live/tts-demo/self-service/home"];
        
        request=[NSMutableURLRequest requestWithURL:nsurl];
        
        session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest: request
                     completionHandler:^(NSData *data,
                                         NSURLResponse *response,
                                         NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
            NSError *err;
            self.player = [[AVAudioPlayer alloc] initWithData:data error:&err];
            self.player.delegate  = self;
            [self.player play];
            
            if (err.description)
            {
                NSLog(@"%@", err.description);
            } else {
                NSLog(@"playing?");
            }
            });
            
        }] resume];
        
#endif

        
        
        
    }] resume];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"%d",flag);
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    NSLog(@"%@", error.description);
}

@end
