# Flira

Use Flira to create Jira issues from your mobile flutter app.

[![GIF-220910_234824.gif](https://s4.gifyu.com/images/GIF-220910_234824.gif)](https://gifyu.com/image/SwtLA)

### Usage


The <b>Flira report dialog </b> is built to be placed inside the home parameter of our <b>MaterialApp</b>.

Once we initialized the Flira client, we will be able to call the report dialog using three methods: 
- shaking the screen
- taking a screenshot or 
- calling to a void function from Flira package.

```
Flira fliraClient = Flira(
        // get this from https://id.atlassian.com/manage-profile/security/api-tokens
        atlassianApiToken: 'myyQMo9cBvfUmWEgrwQUCA84',
        // atlassian url prefix
        atlassianUrl: 'marcostrt',
        // your email
        atlassianUser: 'tort.marcos9@gmail.com');
    fliraClient.init(
      
      context: context,
      // Here you can choose how to trigger the Flira client
      method: TriggeringMethod.screenshot,
    );
```
### Code example repository
[Code example](https://github.com/MarcosTort/flira)
