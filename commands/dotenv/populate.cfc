/**
 * Accepts a path to an example env file (defaults to .env.example) and a target .env and walks the user through populating the "real" one from the example
 */
component {

    property name="propertyFile"   inject="provider:PropertyFile@propertyFile";
	property name="fileSystemUtil" inject="FileSystem";

    /**
     * The entry point of the command
	 *
     * @exampleFileName.hint The path to the example .envfile
     * @envFileName.hint     The path and name of the .env file
     * @folder.hint          The folder in which the .env file to use is located. Defaults to the current directory.
	 * @new.hint             Only add the new variables from the example file
     */
    function run(
		string exampleFileName = ".env.example",
		string envFileName = ".env",
		string folder = "",
		boolean new = false
	) {
		var directory = variables.fileSystemUtil.resolvePath( arguments.folder );
		var exampleFile = directory & arguments.exampleFileName;

        if ( !fileExists( exampleFile ) ) {
            return error( "The example file [#exampleFile#] given does not exist" );
		}

		var envFile = directory & arguments.envFileName;
		var shouldContinue = fileExists( envFile ) ?
			( arguments.new || confirm( "The file [#envFile#] already exists.  Do you want to overwrite it? [y/n]" ) ) :
			createEnv( envFile );

		if ( !shouldContinue ) {
			print.yellowLine( "Cancelling." );
			return;
		}

		var targetPropertyFile = propertyFile.load( envFile );
		var examplePropertyFile = propertyFile.load( exampleFile );

		var properties = examplePropertyFile
			.getAsStruct()
			.filter( ( key ) => !new || !targetPropertyFile.exists( key ) );

		if ( properties.isEmpty() ) {
			print.line( "No#arguments.new ? ' new' : ''# properties to add." );
			return;
		}

		properties.each( ( key, defaultValue = "" ) => {
			var newValue = ask(
				message = "#key#=",
				defaultResponse = defaultValue
			);
			targetPropertyFile.set( key, newValue );
		} );

		targetPropertyFile.store();
		print.line().greenLine( "#arguments.new ? 'New' : 'All'# values stored." );
	}

	/**
     * Creates the .env file with the given file path
	 *
     * @envFile.hint     The filename to create (typically .env).
	 *
	 * @return           Boolean representing the file was created.
     */
    private boolean function createEnv( required string envFile ) {
		command( "touch" ).params( arguments.envFile ).run();
        return true;
	}

}
