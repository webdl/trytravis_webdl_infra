#!/bin/bash

echo "******************************"
echo "Run tests"
echo "******************************"

echo "******************************"
echo "Run Packer validate"
echo "******************************"
packer validate -var-file=packer/variables.json.example packer/*.json