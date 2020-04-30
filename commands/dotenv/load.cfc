/**
 * Load all the values from a properties file into the shell's current environment context.
 * .
 * {code:bash}
 * dotenv load config/common.properties
 * {code}
 * .
 * You can load more than one file at a time using file globbing patterns
  * .
 * {code:bash}
 * dotenv load config/*.properties
 * {code}
 */
component accessors="true" {
    property name="envFileService" inject="EnvironmentFileService@commandbox-dotenv";

    /**
     * @envFile File or globbing pattern of file(s) to load. 
     */
    function run( required Globber envFile ) {
		envFile.apply( ( file ) => {
			envFileService.loadEnvToCLI( envStruct=envFileService.getEnvStruct( file ), inParent=true );
			print.greenLine( "Env file [#file#] loaded." );
		} );
		if( !envFile.count() ) {
			print.yellowLine( "No Env files were found matching [#envFile.getPattern()#]." );
		}
	}

}
