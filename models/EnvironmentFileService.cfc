/**
 * Service for working with dotenv files
 */
component singleton="true" {

    property name="propertyFile" inject="provider:PropertyFile@propertyFile";
    property name='consoleLogger' inject='logbox:logger:console';
    property name='systemSettings' inject='systemSettings';
    property name="javaSystem" inject="java:java.lang.System";
    property name="moduleSettings" inject="commandbox:moduleSettings:commandbox-dotenv";

    public function getEnvStruct( envFilePath ) {
        if ( ! fileExists( envFilePath ) ) {
            return {};
        }

        var envFile = fileRead( envFilePath );
        if ( isJSON( envFile ) ) {
            return deserializeJSON( envFile );
        }

		// Shim for old version of WireBox/CommandBox
		if( structKeyExists( propertyFile, '$get' ) ) {
			// WireBox >= 6
			var propFile = propertyFile.$get();
		} else {
			// WireBox <= 5.x
			var propFile = propertyFile.get();			
		}
        return propFile
            .load( envFilePath )
            .getAsStruct();
    }

	/**
	* @envStruct Struct of key/value pairs to load
	* @inParent Loads vars into the parent context so they persist outside of this current command
	*/
    public function loadEnvToCLI( required struct envStruct, boolean inParent=false ) {

        for (var key in envStruct) {

        	// Shim for older versions of CommandBox
        	if( !structKeyExists( systemSettings, 'setSystemSetting' ) ) {
				javaSystem.setProperty( key, envStruct[ key ] );
        	} else {
				systemSettings.setSystemSetting( key, envStruct[ key ], inParent );
        	}

            if( moduleSettings.printOnLoad && moduleSettings.verbose ) {
                consoleLogger.info( "commandbox-dotenv: #key#=#envStruct[ key ]#" );
            }

        }

    }

    public array function diff( required struct source, required struct target ) {
        return arguments.source.reduce( ( acc, key ) => {
            if ( ! target.keyExists( arguments.key ) ) {
                arguments.acc.append( arguments.key );
            }
            return arguments.acc;
        }, [] );
    }

}
