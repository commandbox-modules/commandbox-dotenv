/**
 * Adds a key value pair to the .env file in the current folder (or submitted file)
 */
component accessors="true" {

	property name="propertyFile"   inject="provider:PropertyFile@propertyFile";
	property name="fileSystemUtil" inject="FileSystem";

    /**
     * Sets a key value pair to the .env file.
	 *
     * @name.hint        The property name to set.
	 * @name.optionsUDF  envNameComplete
     * @value.hint       The property value to set.
     * @envFileName.hint The .env file name in the folder to read. Defaults to `.env`.
     * @folder.hint      The folder in which the .env file to use is located. Defaults to the current directory.
     * @force.hint       Flag to bypass confirmation about creating a .env file if necessary
     */
    void function run(
        required string name,
        string value = "",
        string envFileName = ".env",
        string folder = "",
        boolean force = false
    ) {
		var directory = variables.fileSystemUtil.resolvePath( arguments.folder );
		var envFile = directory & arguments.envFileName;

        var shouldContinue = fileExists( envFile ) || createEnv( arguments.envFileName, envFile, arguments.force );
        if ( !shouldContinue ) {
			return;
		}

		variables.propertyFile
			.load( envFile )
			.set( arguments.name, arguments.value )
			.store();
	}

	/**
     * Confirms whether to create the .env file or not then creates it.
	 *
     * @envFileName.hint The full path and file to the file to create.
     * @envFile.hint     The filename to create (typically .env).
     * @force.hint       Whether to bypass confirmation about creating the file.
	 *
	 * @return           Boolean representing if the file was created.
     */
    private boolean function createEnv(
		required string envFileName,
		required string envFile,
		boolean force = false
	) {
        var createFile = arguments.force ? true : confirm(
            message = "The file #arguments.envFileName# does not appear to exist. Do you want to create it? [y/n]"
        );
        if ( createFile ) {
            command( "touch" ).params( arguments.envFile ).run();
        }
        return createFile;
	}

	function envNameComplete( string paramsSoFar, struct passedNamedParameters ) {
        param arguments.passedNamedParameters.envFileName = ".env";
        param arguments.passedNamedParameters.folder = "";
        var directory = fileSystemUtil.resolvePath( arguments.passedNamedParameters.folder );
		var envFile = directory & arguments.passedNamedParameters.envFileName;
        if ( !fileExists( envFile ) ) {
            return [];
        }
        return propertyFile.load( envFile ).getSyncedNames();
	}

}
