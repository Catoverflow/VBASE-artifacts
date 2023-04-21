#!/bin/bash
azcopy copy --recursive "https://vbasebaseline.blob.core.windows.net/vbench/vbench" /artifacts/
mv /artifacts/vbench /artifacts/raw_data

