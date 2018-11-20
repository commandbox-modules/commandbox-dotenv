# commandbox-dotenv

## Load a local file into Java Properties for CommandBox commands and servers

Storing secrets in source-controlled files is a bad idea, but we still need some way to provide these sensitive credentials or configuration values to our projects.  This problem is exacerbated in development environments where we are running multiple servers at once.  This package let's us solve this problem for servers started with CommandBox.

### Usage

This package loads up local files as Java Properties for both CommandBox commands and servers.  The usage is nearly identical, but with enough gotchas to warrant breaking them out in to separate sections.

> One note about the `.env` file: **Do not commit it to source control.**  Add it to your `.gitignore` immediately.

> Another good tip is to create an `.env.example` file that **is source controlled** that contains all the keys required in your `.env` file but none of the values.

#### CommandBox Startup

When loading up the CLI, this package will look for a `.env` file in the directory where CommandBox is being loaded or executed.  If found it will take the key / value pairs found in the file and store them as CommandBox environment variables.  These values are now available in any CommandBox command either using `systemSettings.getSystemSetting( name, defaultValue )`, or by using CommandBox's [built-in system variable expansion.](https://commandbox.ortusbooks.com/usage/system-settings#using-system-settings-from-the-cli):

```bash
echo ${myvar}
```

#### CommandBox Commands
Any time you run a command, if there is a `.env` file in the current working directory where the command was run, those vars will be loaded into the environment context of that command only.   This is great for localized variables that only apply to a specific project. Note, this feature only kicks in if you are on CommandBox 4.5 or higher.


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

#### Logging Properties

There are two levels of logging available.  You can log to the console every time an `.env` file has been loaded by setting the `printOnLoad` setting to `true`.

```
config set modules.commandbox-dotenv.printOnLoad=true
```

You can get further output that shows you the name and value of every variable that was loaded by setting the `verbse` setting to `true` as well.


```
config set modules.commandbox-dotenv.verbose=true
```

The `verbse` setting will only kick in if `printOnLoad` is also true.
