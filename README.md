# Flira

Use Flira to create Jira issues from your mobile flutter app.

[![ezgif.com-gif-maker-1c8c10af26f6aee90.gif](https://s4.gifyu.com/images/ezgif.com-gif-maker-1c8c10af26f6aee90.gif)](https://gifyu.com/image/S34VA)

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
- To dismiss the floating button, drag it down.
```
FliraWrapper(
        triggeringMethod: TriggeringMethod.shaking,
        context: context,
        app: MaterialApp.router(
         .
         .
         .
        ),
      );
```

FliraWrapper can be applied to <b>MaterialApp</b> and <b>MaterialApp.router()</b> as well.

# Update
Due to some issues related to screenshot callback, I added a floating button at the left edge of the screen to make it work on all devices. 
### Code example repository
[Code example](https://github.com/MarcosTort/flira) feature/attach_image_to_issue (Current release)
