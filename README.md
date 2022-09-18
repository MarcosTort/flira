# Flira

Use Flira to create Jira issues from your mobile flutter app.

[![ezgif.com-gif-maker87824c9a4266f65e.gif](https://s5.gifyu.com/images/ezgif.com-gif-maker87824c9a4266f65e.gif)](https://gifyu.com/image/S3sLN)

### Usage


The <b>Flira report dialog </b> is built to wrap our <b>MaterialApp</b>.

Once we wrapped our MaterialApp, we will be able to call the report dialog using three methods: 
- shaking the screen
- taking a screenshot
- calling to a void function from Flira package.

The flow is:
- Trigger Flira.
- Tap the small floating button.
- Enter the data and send the ticket.
- To dismiss the floating button, double tap on it.
```
FliraWrapper(
        atlassianApiToken: 'TxS1UBrLD6f8Rjsbk6brA81D',
        atlassianUrlPrefix: 'marcostrt',
        atlassianUser: 'tort.marcos9@gmail.com',
        triggeringMethod: TriggeringMethod.shaking,
        context: context,
        app: MaterialApp.router(
          routeInformationProvider: _router.routeInformationProvider,
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
          title: title,
        ),
      );
```
### Code example repository
[Code example](https://github.com/MarcosTort/flira) stable branch
