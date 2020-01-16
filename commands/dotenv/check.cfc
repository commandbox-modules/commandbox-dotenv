/**
 * Checks that a `.env` file has all of the keys defined in `.env.example`.
 */
component {

    property name="envFileService" inject="EnvironmentFileService@commandbox-dotenv";
    property name="fileSystemUtil" inject="FileSystem";

    /**
     * @envFileName The name of the .env file. Default: .env
     * @envExampleFileName The name of the .env example file. Default: .env.example
     * @reverse Check that the example file has all the keys of the .env file if true.
     */
    function run(
        string envFileName = ".env",
        string envExampleFileName = ".env.example",
        boolean reverse = false
    ) {
        var directory = fileSystemUtil.resolvePath( "" );
        var envStruct = envFileService.getEnvStruct( "#directory#/#arguments.envFileName#" );
        var envExampleStruct = envFileService.getEnvStruct( "#directory#/#arguments.envExampleFileName#" );
        var fileNameToCheck = arguments.reverse ? arguments.envExampleFileName : arguments.envFileName;
        var structOfTruth = arguments.reverse ? envStruct : envExampleStruct;
        var structToCheck = arguments.reverse ? envExampleStruct : envStruct;

        var missingKeys = structOfTruth.reduce( ( acc, key ) => {
            if ( ! structToCheck.keyExists( arguments.key ) ) {
                arguments.acc.append( arguments.key );
            }
            return arguments.acc;
        }, [] );

        if ( missingKeys.isEmpty() ) {
            print.greenLine( "Check successful." );
        } else {
            setExitCode( 1 );
            print.boldRedLine( "Missing keys detected from #fileNameToCheck#" );
            missingKeys.each( ( key ) => print.whiteLine( key ) );
        }
    }

}
