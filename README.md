# Cordova MailCore2 Plugin

A Cordova plugin that exposes some functions from MailCore2. So far only simple sending of an email is supported. Once it is properly working more functions can/will be added.

## Using

Install iOS platform (if not present already):

    cordova platform add ios

Install the plugin:

    $ cordova plugin add cordova-plugin-mailcore2

Alternatively install the plugin directly from GitHub (for the latest version):

    $ cordova plugin add https://github.com/CWBudde/cordova-plugin-mailcore2.git

So far only the mail sending capacibilities of the MailCore2 library are exposed.

### Sending an email

To send an email you must first provide the required options as such

    var mailSettings = {
        fromEmail: "sender@domain.com",
        toName: "Name of the Receiver",
        toEmail: "receiver@domain.com",
        smtpServer: "smtp-mail.domain.com",
        smtpPort: 465,
        smtpUserName: "authuser@domain.com",
        smtpPassword: "password",
        textSubject: "email subject",
        textBody: "email body"
    };
            
    var success = function {
	    // message sent
    }

    var failure = function(error) {
	    console.log("Error sending the email");
    }
    
You can also add an attachment. However, so far it's just possible to add one attachment and it must be preformated. For example if you want to attach an image it needs to be surrounded by the img tag like this:

    textAttachment: "<img src='data:image/jpeg;base64,...' />"

This simple API might get changed in the future.
