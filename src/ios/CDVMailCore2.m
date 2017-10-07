/* 
 * Copyright 2017 Christian-W. Budde
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
 
#import "CDVMailCore.h"
#import "MailCore2.h"

@implementation CDVMailCore2

- (void)cordovaSendMail:(CDVInvokedUrlCommand*)command
{
	self.CallbackId = command.callbackId;

	NSDictionary* options = command.arguments[0];

	NSString *from = [options objectForKey:@"emailFrom"];
	NSString *to = [options objectForKey:@"emailTo"];
	NSString *bcc = [options objectForKey:@"bcc"];
	NSString *smtpServer = [options objectForKey:@"Server"];
	NSString *smtpPort = [options objectForKey:@"Port"];
	NSString *smtpUsername = [options objectForKey:@"UserName"];
	NSString *smtpPassword = [options objectForKey:@"Password"];
	NSString *textBody = [options objectForKey:@"textBody"];

	MCOSMTPSession *smtpSession = [[MCOSMTPSession alloc] init];
	smtpSession.hostname = smtpServer;
	smtpSession.port = smtpPort;
	smtpSession.username = smtpUsername;
	smtpSession.password = smtpPassword;
	smtpSession.connectionType = MCOConnectionTypeTLS;

	MCOMessageBuilder * builder = [[MCOMessageBuilder alloc] init];
	[[builder header] setFrom:[MCOAddress addressWithDisplayName:nil mailbox:USERNAME]];
	NSMutableArray *to = [[NSMutableArray alloc] init];
	for(NSString *toAddress in RECIPIENTS) {
    MCOAddress *newAddress = [MCOAddress addressWithMailbox:toAddress];
    [to addObject:newAddress];
	}
	[[builder header] setTo:to];
	NSMutableArray *cc = [[NSMutableArray alloc] init];
	for(NSString *ccAddress in CC) {
    MCOAddress *newAddress = [MCOAddress addressWithMailbox:ccAddress];
    [cc addObject:newAddress];
	}
	[[builder header] setCc:cc];
	NSMutableArray *bcc = [[NSMutableArray alloc] init];
	for(NSString *bccAddress in BCC) {
    MCOAddress *newAddress = [MCOAddress addressWithMailbox:bccAddress];
    [bcc addObject:newAddress];
	}
	[[builder header] setBcc:bcc];
	[[builder header] setSubject:SUBJECT];
	[builder setHTMLBody:BODY];
	NSData * rfc822Data = [builder data];

	MCOSMTPSendOperation *sendOperation = [smtpSession sendOperationWithData:rfc822Data];
	[sendOperation start:^(NSError *error) {
    if(error) {
      NSLog(@"%@ Error sending email:%@", USERNAME, error);
			CDVPluginResult *pluginResult = [
				CDVPluginResult resultWithStatus : CDVCommandStatus_OK
			];				

			[self.commandDelegate sendPluginResult:pluginResult callbackId:self.CallbackId];
    } else {
      NSLog(@"%@ Successfully sent email!", USERNAME);
			CDVPluginResult *pluginResult = [ 
				CDVPluginResult resultWithStatus: CDVCommandStatus_OK
			];
	
			[self.commandDelegate sendPluginResult:pluginResult callbackId:self.CallbackId];
    }
	}];
}

@end