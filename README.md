# Redmine Plugin Update Checker

This branch contains the lookup table for any known [Redmine](http://www.redmine.org) plugins which can't be directly mapped using a url lookup.

## Registering Your Plugin

1. Fork this repository
2. Add your plugin to the ``lookup.json`` file
3. Send a pull request

When adding your plugin to the lookup table, ensure that you insert it in the correct place in the file so that it appears alphabetically by id.

The format of a new entry is a standard json hash object with the following keys:

``` json
{
  "id": "<required>",     // The value that was used in the Redmine::Plugin.register 
                          // block to identifiy the plugin
  "author": "[optional]", // Used to identify the author of the plugin
  "url": "<required>"     // The url to the source repository of the plugin 
                          // that will be used to check for updates
}

```
