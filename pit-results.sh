#!/usr/bin/env bash

# Usage: bash pit-results.sh SETUP_SCRIPT

source "$DT_SCRIPTS/constants.sh"

set -e

if [[ ! -z "$1" ]]; then
    # Generally the setup scripts are written so that they assume you are in a particular directory, so
    # make sure we match that.
    CURRENT=$(pwd)

    SCRIPT_DIR=$(dirname "$1")
    SCRIPT_NAME=$(basename "$1")

    echo "[INFO] Running setup script $SCRIPT_NAME in $SCRIPT_DIR"

    cd $SCRIPT_DIR
    source "$SCRIPT_NAME"

    cd $CURRENT
fi

echo "[INFO] Running pit-results for subject ${SUBJ_NAME}"

RESULTS_DIR="$DT_SCRIPTS/${SUBJ_NAME}-results"
echo "[INFO] Checking for results directory at $RESULTS_DIR"
# Make the results directory if it doesn't exist (and copy the setup script if applicable)
if [[ ! -d "$RESULTS_DIR" ]]; then
    echo "[INFO] Creating results directory"
    mkdir "$RESULTS_DIR"

    if [[ ! -z "$1" ]]; then
        echo "[INFO] Copying setup script"
        cp "$1" "$RESULTS_DIR"
    fi
fi

cp "$DT_SCRIPTS/build.xml" "$NEW_DT_SUBJ_SRC"
cd "$NEW_DT_SUBJ_SRC"
# TODO: !!!Uncomment this!!!
# ant mutationCoverage
# ant mutationCoverageAuto

ENHANCED_DIR="$RESULTS_DIR/enhanced"
OUTPUT_DIR="$RESULTS_DIR/pit-results"

java -cp $DT_TOOLS: edu.washington.cs.dt.tools.PitResultAnalyzer --basePath "$NEW_DT_SUBJ_SRC" --resultFiles "$ENHANCED_DIR/$prioDir" --outputDir "$OUTPUT_DIR/$prioDir"
java -cp $DT_TOOLS: edu.washington.cs.dt.tools.PitResultAnalyzer --basePath "$NEW_DT_SUBJ_SRC" --resultFiles "$ENHANCED_DIR/$seleDir" --outputDir "$OUTPUT_DIR/$seleDir"
java -cp $DT_TOOLS: edu.washington.cs.dt.tools.PitResultAnalyzer --basePath "$NEW_DT_SUBJ_SRC" --resultFiles "$ENHANCED_DIR/$paraDir" --outputDir "$OUTPUT_DIR/$paraDir"

