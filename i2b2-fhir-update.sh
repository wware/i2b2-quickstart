#!/bin/bash
#e.g. sh i2b2-fhir-update.sh /exvol/i2b2-fhir-cell /exvol/i2b2-fhir dstu2-sep15-all 1
#Will update git repository from web and delete old branch from fhir-cell install dir
#also accomodates branch name and offset for server port in standalone
export CELL_DIR=$1
export GITREPO_DIR=$2
export BRANCH=$3
export PORT_OFFSET=$4

rm -rf "$CELL_DIR/i2b2-fhir-branch/"

echo "GIT REPO DIR:$GITREPO_DIR"
git --git-dir="$GITREPO_DIR/.git" pull
echo "chechking out branch:$BRANCH" 
git --git-dir="$GITREPO_DIR/.git" checkout $BRANCH

cp -r "$GITREPO_DIR" "$CELL_DIR/i2b2-fhir-branch"
export SA="wildfly-9.0.1.Final/standalone/configuration/standalone.xml" 
cat "$CELL_DIR/$SA"|sed s/offset:0/offset:1/>cat "$CELL_DIR/$SA"
sh i2b2-fhir-install.sh
