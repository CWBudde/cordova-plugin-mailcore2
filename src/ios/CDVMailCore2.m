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
 
#import "CDVMailCore2.h"
#import "MailCore2.h"

@implementation CDVMailCore2

- (void)cordovaSendMail:(CDVInvokedUrlCommand*)command
{
	self.callbackId = command.callbackId;

	NSDictionary* options = command.arguments[0];

	NSString *fromEmail = [options objectForKey:@"fromEmail"];
	NSString *toName = [options objectForKey:@"toName"];
	NSString *toEmail = [options objectForKey:@"toEmail"];
	NSString *smtpServer = [options objectForKey:@"smtpServer"];
	NSString *smtpPort = [options objectForKey:@"smtpPort"];
	NSString *smtpUsername = [options objectForKey:@"smtpUserName"];
	NSString *smtpPassword = [options objectForKey:@"smtpPassword"];
	NSString *textSubject = [options objectForKey:@"textSubject"];
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
    MCOAddress *newAddress = [MCOAddress addressWithMailbox:toEmail];
    [to addObject:newAddress];
	[[builder header] setTo:to];

	[[builder header] setSubject:textSubject];
	[builder setHTMLBody:textBody];
	NSData * rfc822Data = [builder data];

	MCOSMTPSendOperation *sendOperation = [smtpSession sendOperationWithData:rfc822Data];
	[sendOperation start:^(NSError *error) {
    if(error) {
      NSLog(@"%@ Error sending email:%@", smtpUsername, error);
			CDVPluginResult *pluginResult = [
				CDVPluginResult resultWithStatus : CDVCommandStatus_OK
			];				

			[self.commandDelegate sendPluginResult:pluginResult callbackId:self.CallbackId];
    } else {
      NSLog(@"%@ Successfully sent email!", smtpUsername);
			CDVPluginResult *pluginResult = [ 
				CDVPluginResult resultWithStatus: CDVCommandStatus_OK
			];
	
			[self.commandDelegate sendPluginResult:pluginResult callbackId:self.CallbackId];
    }
	}];
}

@end
