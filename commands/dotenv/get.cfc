/**
 * Reads the .env file in the current folder (or submitted) and returns the value of the submitted key
 */
component {

    property name="propertyFile"   inject="provider:PropertyFile@propertyFile";
	property name="fileSystemUtil" inject="FileSystem";

    /**
     * The entry point of the command
	 *
     * @name.hint        The name of the variable desired
     * @name.optionsUDF  envNameComplete
     * @envFileName.hint The .env file name in the folder to read. Defaults to `.env`.
     * @folder.hint      The folder in which the .env file to use is located. Defaults to the current directory.
     */
    function run(
		required string name,
		string envFileName = ".env",
		string folder = ""
	) {
		var directory = variables.fileSystemUtil.resolvePath( arguments.folder );
		var envFile = directory & arguments.envFileName;

        if ( !fileExists( envFile ) ) {
			return error( "The file [#envFile#] does not exist" );
		}

		return propertyFile.load( envFile ).get( name );
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
