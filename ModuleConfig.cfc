component {

	function configure() {
		settings = {
			'fileName' = '.env',
			'printOnLoad' = false,
			'verbose' = false
		};

		interceptors = [
			{ class = "#moduleMapping#.interceptors.LoadEnvForCommands" },
			{ class = "#moduleMapping#.interceptors.LoadEnvForServers" },
			{ class = "#moduleMapping#.interceptors.LoadEnvPreServers" },
		];
	}

}
