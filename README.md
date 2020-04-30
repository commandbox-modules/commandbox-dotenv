# commandbox-dotenv

## Load a local file into Java Properties for CommandBox commands and servers

Storing secrets in source-controlled files is a bad idea, but we still need some
way to provide these sensitive credentials or configuration values to our projects.
This problem is exacerbated in development environments where we are running multiple servers at once.
This package let's us solve this problem for servers started with CommandBox.

### Usage

This package loads up local files as Java Properties for both CommandBox commands
and servers. The usage is nearly identical, but with enough gotchas to warrant
breaking them out in to separate sections.

> One note about the `.env` file: **Do not commit it to source control.**
> Add it to your `.gitignore` immediately.

> Another good tip is to create an `.env.example` file that **is source controlled**
> that contains all the keys required in your `.env` file but none of the values.

#### CommandBox Startup

When loading up the CLI, this package will look for a `.env` file in the directory
where CommandBox is being loaded or executed.  If found it will take the key / value
pairs found in the file and store them as CommandBox environment variables.
These values are now available in any CommandBox command either using
`systemSettings.getSystemSetting( name, defaultValue )`, or by using CommandBox's
[built-in system variable expansion.](https://commandbox.ortusbooks.com/usage/system-settings#using-system-settings-from-the-cli):

```bash
echo ${myvar}
```

#### CommandBox Commands
Any time you run a command, if there is a `.env` file in the current working
directory where the command was run, those vars will be loaded into the environment
context of that command only. This is great for localized variables that only apply
to a specific project. Note, this feature only kicks in if you are on CommandBox 4.5 or higher.

#### CommandBox Servers

When starting up a server, this package will look for a `.env` file in the webroot
of the server starting. If found, it will take the key / value pairs found in the
file and store them as Java properties. These values are now available in your web
application using the `java.lang.System` object and the `getProperties()` or
`getProperty(name, defaultValue)` methods (Note: the keys are case-sensitive).

#### Global Env File

When starting up the CLI, CommandBox will look for a `~/.box.env` file.
It will load the file's key / value pairs as environment variables inside CommandBox.

If you change the contents of this file, you will need to reload your shell for
the changes to take effect.

If you want to change the name of the global environment file, you can update
your module settings:

```bash
config set modules.commandbox-dotenv.globalEnvFile = "~/.commandbox.env"
```

#### Different Property File Name

The file name `.env` can be overridden, if desired.

For instance, by running:

```bash
config set modules.commandbox-dotenv.fileName=env.properties
```

all your file names will need to be `env.properties`.

You can also set your example env file name:

```bash
config set modules.commandbox-dotenv.exampleFileName=env.properties
```

There is currently no way to provide a per-project override.

#### Logging Properties

There are two levels of logging available.  You can log to the console every
time an `.env` file has been loaded by setting the `printOnLoad` setting to `true`.

```bash
config set modules.commandbox-dotenv.printOnLoad=true
```

You can get further output that shows you the name and value of every variable
that was loaded by setting the `verbose` setting to `true` as well.

```bash
config set modules.commandbox-dotenv.verbose=true
```

The `verbose` setting will only kick in if `printOnLoad` is also true.

#### Check Command

When using environment variables, you will inevitably run in to a situation
where you lose time debugging a strange error only to find that you haven't
provided a value for a new environment variable.  The `check` command
will check that all the keys in your `.env.example` file exist in your `.env` file.

```bash
dotenv check
```

The filenames can be overridden with the `envFileName` and `envExampleFileName`
parameters to the command.

```bash
dotenv check envFileName=env.properties envExampleFileName=env.example.properties
```

You can reverse the check to ensure the `.env.example` file has all the keys
in your `.env` file by passing the `--reverse` flag.

```bash
dotenv check --reverse
```

One great place to add this command is using [CommandBox GitHooks](https://forgebox.io/view/commandbox-githooks).

```json
{
    "githooks": {
        "preCommit": "dotenv check --reverse",
        "postCheckout": "dotenv check",
        "postMerge": "dotenv check"
    }
}
```

This will prevent you from commiting code when you have `.env` keys that are not
in your `.env.example` file. It will also check for any new keys in your
`.env.example` file and notify you of them after checking out a new branch

Another great place to add this command is in your CI pipeline to avoid deploying
a build with a missing environment variable.

#### preServerStart Check

Enabled by default is a `preServerStart` check.  This will run `dotenv check` for you and
throw an error if the `.env` file does not have all of the `.env.example` keys.  This
is to help prevent you spending precious time debugging your application just to find
you are missing an env key.

If you do not want this behavior, you can set the `checkEnvPreServerStart` module setting to false.

```sh
box config set modules.commandbox-dotenv.checkEnvPreServerStart=false
```

#### Env File Commands

Thanks to Dan Card and his `commandbox-envfile` library, you can interact with your env file right from CommandBox.
There are four commands to help you out.

##### dotenv show

This shows the current .env file contents.  You can pass an override envFileName or folder, if desired.

##### dotenv get

This gets the value of a key in the current .env file.  You can pass an override envFileName or folder, if desired.
Don't forget tab completion here to help you fill out the key names quickly!

##### dotenv set

This takes two arguments, a name and a value, and sets it in your current .env file.  Current property names
can be tab completed.  You can pass an override envFileName or folder, if desired.

##### dotenv populate

This command will inspect your .env.example file and help you fill out the values in your .env file.
Additionally, it can only prompt you for new values using the `--new` flag.  The exampleFileName, envFileName, and
folder can all be customized, if desired.

##### dotenv load

This command will load arbitrary properties files into your CommandBox environment.  Useful for task runners where you need to load a shared environment file.
