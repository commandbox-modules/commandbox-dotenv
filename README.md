# commandbox-dotenv

## Load a local file into Java Properties for CommandBox commands and servers

Storing secrets in source-controlled files is a bad idea, but we still need some way to provide these sensitive credentials or configuration values to our projects.  This problem is exacerbated in development environments where we are running multiple servers at once.  This package let's

### Usage

This package loads up local files as Java Properties for both CommandBox commands and servers.  The usage is nearly identical, but with enough gotchas to warrant breaking them out in to separate sections.

> One note about the `.env` file: **Do not commit it to source control.**  Add it to your `.gitignore` immediately.

> Another good tip is to create an `.env.example` file that **is source controlled** that contains all the keys required in your `.env` file but none of the values.

#### CommandBox Commands

When loading up the CLI, this package will look for a `.env` file in the directory where CommandBox is being loaded or executed.  If found it will take the key / value pairs found in the file and store them as Java properties.  These values are now available in any CommandBox command either using the `java.lang.System` object and the `getProperties()` or `getProperty(name, defaultValue)` methods (Note: the keys are case-sensitive), or by using CommandBox's [built-in system variable expansion.](https://commandbox.ortusbooks.com/content/usage/execution/system-settings.html)

Since the CommandBox properties are loaded on CLI start, you will need to `reload` CommandBox before seeing any changes to the `.env` file.  This can be accomplished just by running `reload` from the interactive shell.  If you are running one-off commands, this happens on each command for you already.

#### CommandBox Servers

When starting up a server, this package will look for a `.env` file in the webroot of the server starting.  If found it will take the key / value pairs found in the file and store them as Java properties.  These values are now available in your web application using the `java.lang.System` object and the `getProperties()` or `getProperty(name, defaultValue)` methods (Note: the keys are case-sensitive).

#### Different Property File Name

The file name `.env` can be overridden, if desired.

For instance, by running:
```
config set modules.commandbox-dotenv.filename=env.properties
```
all your file names will need to be `env.properties`.

There is currently no way to provide a per-project override.
