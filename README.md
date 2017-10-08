# Cordova MailCore2 Plugin

A Cordova plugin that exposes some functions from MailCore2. So far only simple sending of an email is supported. Once it is properly working more functions can/will be added.

## Using

Install iOS platform

    cordova platform add ios

Install the plugin using any plugman compatible cli

    $ cordova plugin add https://github.com/CWBudde/cordova-plugin-mailcore.git

So far only the mail sending capacibilities of the MailCore2 library are exposed.

### Sending an email

To send an email you must first provide the required options as such

    var mailSettings = {
        fromEmail: "sender@domain.com",
        toName: "Name of the Receiver",
        toEmail: "receiver@domain.com",
        smtpServer: "smtp-mail.domain.com",
        smtpPort: 587,
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