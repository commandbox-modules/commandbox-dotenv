/**
 * Displays the contents of the .env (or submitted file)
 */
component {

    property name="propertyFile"   inject="provider:PropertyFile@propertyFile";
	property name="fileSystemUtil" inject="FileSystem";

    /**
     * The entry point of the command
	 *
     * @envFileName.hint The .env file name in the folder to read. Defaults to `.env`.
     * @folder.hint      The folder in which the .env file to use is located. Defaults to the current directory.
     */
    function run(
		string envFileName = ".env",
		string folder = ""
	) {
		var directory = variables.fileSystemUtil.resolvePath( arguments.folder );
		var envFile = directory & arguments.envFileName;

        if ( !fileExists( envFile ) ) {
            return error( "The file [#envFile#] does not exist. Use `dotenv set` or `dotenv populate` to create one." );
		}

		variables.propertyFile
			.load( envFile )
            .getAsStruct()
            .each( ( key, value ) => print.boldWhite( key ).blue( "=" ).line( value ) );
    }

}
