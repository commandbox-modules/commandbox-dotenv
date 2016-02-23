# commandbox-dotenv

This is a simple package that looks for a `.env` json file in your webroot and sets the key-value pairs as JVM arguments.  Those values are then accessible through the `java.lang.System` object and the `getProperties()` or `getProperty(name, defaultValue)` methods.