# OSMOSIS - MAPFORGE MAPMAKER

Generate offline map for android using osmosis

## Notes

- We expect you already have your OSM data ready.
- Make sure to save your `.pbf` or `.osm` file inside `./data/input`. 
- Change `environment` variables in `docker-compose.yml` to suites your usage or machine capabilities.
    ```yml
    services:
        .
        .
        .
    
        environment:
            - OSM_FILE=borneo-latest.osm.pbf
            - MAPFORGE_MAP_FILE=borneo.map
            - MAPFORGE_POI_FILE=borneo.poi
            - BBOX=-7.1986095,104.571669609,8.3333731,140.6130556  # ymin,xmin,ymax,xmax
            - JAVACMD_OPTIONS=-Xmx8g -Xms8g  # eg: 1.5 GB pbf size -> 1.5*2*2=6. Xmx at least `-Xmx6g`
            - CPU_THREADS=6
        .
        .
        .
    
    ```

## Usage

Change `docker-compose.template` into `docker-compose.yml` before running `docker compose` command

1. Build
    - `docker compose build`

2. Run osmosis
    - `docker compose up`
    - or `docker compose up osmosis`

3. Remove container
    - `docker compose down`

4. Or run using `docker run`

    ```bash
    docker run -it -v %cd%/data/input:/data/input -v %cd%/data/output:/data/output -e JAVACMD_OPTIONS="-Xmx8g -Xms8g" -e CPU_THREADS=8 --rm lerryws/osmosis:latest ./entrypoint.sh map
    
    # or
    docker run -it -v %cd%/data/input:/data/input -v %cd%/data/output:/data/output -e JAVACMD_OPTIONS="-Xmx8g -Xms8g" -e CPU_THREADS=8 --rm lerryws/osmosis:latest ./entrypoint.sh poi
    
    # or
    docker run -it -v %cd%/data/input:/data/input -v %cd%/data/output:/data/output -e JAVACMD_OPTIONS="-Xmx8g -Xms8g" -e CPU_THREADS=8 --rm lerryws/osmosis:latest ./entrypoint.sh merge
    ```

    