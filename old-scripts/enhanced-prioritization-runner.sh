source ./config.sh

compileNewSource

index=0
count=${#experiments[@]}

while [ "$index" -lt "$count" ]; do
  echo -e "Starting experiment: ${experiments[$index]}"
  cd ${newDirectories[$index]}

  #fixerInstrumentFiles ${fixerCP[$index]}
  #instrumentFiles ${experimentsCP[$index]}
  for k in "${testTypes[@]}"; do
    #echo 'Generating sootTestOutput'
    #java -cp ${sootCP[$index]} edu.washington.cs.dt.main.ImpactMain -inputTests ${experiments[$index]}-$k-order
    #mv sootTestOutput sootTestOutput-$k
    java -cp ${newExperimentsCPNoDir[$index]} edu.washington.cs.dt.impact.Main.OneConfigurationRunner -technique prioritization -coverage statement -order original -origOrder ${experiments[$index]}-$k-order -testInputDir ${initialDir}/${directories[$index]}/sootTestOutput-$k -filesToDelete ${experiments[$index]}-env-files -project "${experimentsName[$index]}" -testType $k -outputDir ${initialDir}/${priorDir} -timesToRun ${medianTimes} -getCoverage

    for i in "${coverages[@]}"; do
      for j in "${priorOrders[@]}"; do
        echo 'Running prioritization without resolveDependences and with dependentTestFile'
        java -cp ${newExperimentsCPNoDir[$index]} edu.washington.cs.dt.impact.Main.OneConfigurationRunner -technique prioritization -coverage $i -order $j -origOrder ${experiments[$index]}-$k-order -testInputDir ${initialDir}/${directories[$index]}/sootTestOutput-$k -filesToDelete ${experiments[$index]}-env-files -getCoverage -project "${experimentsName[$index]}" -testType $k -outputDir ${initialDir}/${priorDir} -dependentTestFile ${initialDir}/prioritization-dt-list/"prioritization-${experimentsName[$index]}-$k-$i-$j.txt" -timesToRun ${medianTimes}

        echo 'Running prioritization without resolveDependences and without dependentTestFile'
        java -cp ${newExperimentsCPNoDir[$index]} edu.washington.cs.dt.impact.Main.OneConfigurationRunner -technique prioritization -coverage $i -order $j -origOrder ${experiments[$index]}-$k-order -testInputDir ${initialDir}/${directories[$index]}/sootTestOutput-$k -filesToDelete ${experiments[$index]}-env-files -getCoverage -project "${experimentsName[$index]}" -testType $k -outputDir ${initialDir}/${priorDir} -timesToRun ${medianTimes}
      done
    done
    clearTemp ${experiments[$index]} $k
  done
  clearInstrumentation
  cd ..
  let "index++"
done
