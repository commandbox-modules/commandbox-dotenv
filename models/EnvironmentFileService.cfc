/**
 * Service for working with dotenv files
 */ 
component singleton="true" {

    property name="propertyFile" inject="provider:PropertyFile@propertyFile";
    property name='consoleLogger' inject='logbox:logger:console';
    property name='systemSettings' inject='systemSettings';
    property name="javaSystem" inject="java:java.lang.System";

    public function getEnvStruct( envFilePath ) {
        if ( ! fileExists( envFilePath ) ) {
            return {};
        }

        var envFile = fileRead( envFilePath );
        if ( isJSON( envFile ) ) {
            return deserializeJSON( envFile );
        }

        return propertyFile.get()
            .load( envFilePath )
            .getAsStruct();
    }
    
    public function loadEnvToCLI( required struct envStruct, printOnLoad=false ) {
    	
        for (var key in envStruct) {
        	
        	// Shim for older versions of CommandBox
        	if( !structKeyExists( systemSettings, 'setSystemSetting' ) ) {
				javaSystem.setProperty( key, envStruct[ key ] );
        	} else {
				systemSettings.setSystemSetting( key, envStruct[ key ] );       		        		
        	}
            
            if( printOnLoad ) {
                consoleLogger.info( "commandbox-dotenv: #key#=#envStruct[ key ]#" );
            }
            
        }
        
    }

}