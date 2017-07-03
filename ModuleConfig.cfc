component {

	function configure() {
		settings = {
			fileName = '.env'
		};
	}

	function onServerStart(interceptData) {
		var webRoot = interceptData.serverInfo.webRoot;
		
		var envFilePath = '#webRoot#/#settings.fileName#';

		if (fileExists(envFilePath)) {
			var envStruct = {};

			var envFile = fileRead(envFilePath);
			if (isJSON(envFile)) {
				envStruct = deserializeJSON(envFile);
			}
			else { // assume it is a .properties file
				envStruct = wirebox.getInstance( "PropertyFile@propertyFile" )
					.load( envFilePath )
					.getAsStruct();
			}

			// Append to the JVM args
			for (var key in envStruct) {
				interceptData.serverInfo.jvmArgs &= ' -D#key#=#envStruct[key]#';
			}
		}
	}

}