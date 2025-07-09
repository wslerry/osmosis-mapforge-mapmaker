#!/bin/bash

(set -o ignr) 2>/dev/null && set -o igncr;

figlet -t "OSM To Mapforge"

JAVACMD_OPTIONS=${JAVACMD_OPTIONS:=-Xmx2g -Xms2g}
CPU_THREADS=${CPU_THREADS:=4}
INPUT_DIR="/data/input"
OUTPUT_DIR="/data/output"
BBOX=${BBOX:--7.1986095,104.571669609,8.3333731,140.6130556}
OSM_FILE="${OSM_FILE:-borneo-latest.osm.pbf}"
MAPFORGE_MAP_FILE="${MAPFORGE_MAP_FILE:-output.map}"
MAPFORGE_POI_FILE="${MAPFORGE_POI_FILE:-output.poi}"

echo "-------------------------------------------------------------------------------"
echo "                               CREATE MAPFILE                                  "
echo "-------------------------------------------------------------------------------"
echo ""

function merge_ocean() {
    echo "--- Merge OSM PBF with Ocean/Water layer..."
    osmosis --read-pbf file=${INPUT_DIR}/${OSM_FILE} --sort --write-pbf file=${INPUT_DIR}/borneo-latest-sorted.osm.pbf
    osmosis --rb file=${INPUT_DIR}/borneo-latest-sorted.osm.pbf --rx file=${INPUT_DIR}/borneo_water.osm --s --m --wb file=${OUTPUT_DIR}/merge.osm.pbf
}

function create_mapforge_map() {
    echo "--- Convert OSM PBF into Mapforge map format"
    osmosis --rb file=${INPUT_DIR}/${OSM_FILE} --mw file=${OUTPUT_DIR}/${MAPFORGE_MAP_FILE} bbox=${BBOX} threads=${CPU_THREADS} type=hd
}

function create_mapforge_poi() {
    echo "--- Convert OSM PBF into Mapforge POI"
    osmosis --rb file=${INPUT_DIR}/${OSM_FILE} --poi-writer file=${OUTPUT_DIR}/${MAPFORGE_POI_FILE}
}

function check_exist() {
    if [ ! -f ${INPUT_DIR}/${OSM_FILE} ]; then
        echo "No data found to process, system exit..."
        exit 1
    fi
}

# Check the first argument to determine which action to take
if [ $# -eq 0 ]; then
    check_exist
    create_mapforge_map
    create_mapforge_poi
else
    case "$1" in
        "map")
            check_exist
            create_mapforge_map
            ;;
        "poi")
            check_exist
            create_mapforge_poi
            ;;
        "merge")
            merge_ocean
            ;;
        *)
            echo "Usage: $0 {map|poi|merge}" >&2
            exit 1
            ;;
    esac
fi

exit 0