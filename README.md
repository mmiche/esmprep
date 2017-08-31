# esmprep
R package: Helps preparing raw ESM data for statistical analyses

Obtaining data from people in an ESM study is relatively easy. However, depending on different aspects, raw ESM data can be full of bad surprises, e.g. multiple indentical lines of data, incomplete data, etc.
Furthermore, raw ESM data usually doesn't come with columns that are needed in multilevel analyses, e.g. the identification code of the participant in front of every ESM questionnaire he/she answered.

The 'esmprep' package makes sense only if all relevant functions, including the last one (esFinal), are run. The word 'relevant' means that depending on the type of ESM research project, some of the functions should be skipped (see vignette pdf). Also, the functions should be run in an hierarchical order (see R documentation of 'esmprep'), which evolved out of my personal experience in working with raw ESM data.

Most important features of the 'esmprep' package are:
1. Ease of use, i.e. people in charge of dealing with raw ESM data and with little R and/or little programming experience should benefit the most.
2. Integration of pretty much all ESM projects, i.e. the user specifies the properties of the ESM project and the code then adapts to the specification. For example, are the daily ESM questionnaires prompted (yes/no) and if yes, how many daily prompts are there?
3. 'esmprep' can be helpful not only during or after an ESM project, but also in its pilot phase (see function esPlausible). Every unintended result of the ESM survey app, which can be registered before the official ESM projects starts, might be prevented by adapting the survey app accordingly. Eventually this might increase data quality and decrease trouble.
