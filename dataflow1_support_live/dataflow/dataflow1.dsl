source(output(
		country as string,
		country_code as string,
		continent as string,
		population as integer,
		indicator as string,
		daily_count as integer,
		date as date,
		rate_14_day as double,
		source as string
	),
	allowSchemaDrift: true,
	validateSchema: false,
	ignoreNoFilesFound: false) ~> source1
source1 filter(continent == 'Europe' && not(isNull(country_code))) ~> FilterEuropeOnly
FilterEuropeOnly select(mapColumn(
		country,
		country_code,
		continent,
		population,
		indicator,
		daily_count,
		date,
		rate_14_day,
		source,
		each(match(name == 'date'),
			'reported_' + 'date' = $$)
	),
	skipDuplicateMapInputs: false,
	skipDuplicateMapOutputs: false) ~> SelectOnlyRequiredFIierds
SelectOnlyRequiredFIierds sink(allowSchemaDrift: true,
	validateSchema: false,
	umask: 0022,
	preCommands: [],
	postCommands: [],
	skipDuplicateMapInputs: true,
	skipDuplicateMapOutputs: true) ~> CasesAndDeaths