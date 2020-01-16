component {

	function configure() {
		settings = {
            "fileName" = ".env",
            "exampleFileName" = ".env.example",
			"globalEnvFile" = "~/.box.env",
			"printOnLoad" = false,
			"verbose" = false
		};

		interceptors = [
			{ class = "#moduleMapping#.interceptors.LoadEnvForCommands" },
			{ class = "#moduleMapping#.interceptors.LoadEnvForServers" },
			{ class = "#moduleMapping#.interceptors.LoadEnvPreServers" },
			{ class = "#moduleMapping#.interceptors.LoadEnvForShell" },
		];
	}

}
