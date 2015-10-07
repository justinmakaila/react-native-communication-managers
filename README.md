# react-native-communication-managers
React Native components for accessing the phone, SMS, and email from within your application.

###Installation

1. Add the contents of the `iOS` directory to your project.
2. Import the proper component into your files:  

    ```javascript
    import * as CommunicationManagers from 'react-native-communication-managers'
    const {
      EmailManager,
      SMSManager,
      PhoneManager,
    } = CommunicationManagers
    ```
    
###Usage

#####Send an SMS
```javascript
SMSManager.messageNumber(phone, error => {
  if (error) {
  	AlertIOS.alert(
  		'Uh-oh',
  		'It looks like SMS is not available on this device.'
  	)
  }
})
```

#####Send an Email
```javascript
// composeEmailToRecipientsWithSubjectAndBody(to: [String], cc: [String], bcc: [String], subject: String, body: String)
EmailManager.composeEmailToRecipientsWithSubjectAndBody([email], null, null, emailSubject, emailBody, error => {
  if (error) {
  	AlertIOS.alert(
  		'Uh-oh',
  		`It looks like mail is not set up on this device. Please open the Settings app > Mail, Contacts, Calendars and add your account, or send an email to ${email}.`
  	)
  }
})
```

#####Place a Phone Call
```javascript
PhoneManager.call(phone) 
```
