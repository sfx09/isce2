# Task

This task automates the pipeline for running the ISCE2 Stack-Sentinel Processor.

## Prerequisites

- You need a system with `git` installed. The scripts were tested on a Ubuntu VM.
- Setup [Earthdata](https://urs.earthdata.nasa.gov) credentials (Required for downloading SLC and DEM data):
    - Create an Earthdata account.
    - Sign the *Alaska Satellite Facility Data Access* EULA.
    - Authorize *LP DACC* type applications for your account.
- Setup [Copernicus](https://dataspace.copernicus.eu) credentials (Required for downloading orbit data).
- Store credentials in `$HOME/.netrc` and restrict permissions using:
    ```bash
    chmod go-rwx .netrc
    ```

## Commands

The `do` wrapper script provides several commands to manage the task lifecycle. Below are the available options:

- **`init`**  
  Install required system dependencies. This command will install all necessary packages specified in the `pkglist` file.

- **`build`**  
  Compile the ISCE library using CMake and set up the runtime environment.

- **`run`**  
  Execute the project. This command will download the required data files, generate the task runners and executing them sequentially.

- **`clean`**  
  Remove artifacts and temporary files.

## Usage

- First, create a local copy of the ISCE2 project using git:
    ```bash
    git clone https://github.com/sfx09/isce2
    ```
- Navigate to the task directory:
    ```bash
    cd isce2/task
    ```
- Install system dependencies if required:
    ```bash
    ./do init
    ```
- Build the ISCE library: 
    ```bash
    ./do build
    ```
- Execute the task pipeline: 
    ```bash
    ./do run
    ```

## Run Pipeline

1. The task starts by fetching the list of SLCs to be processed from SharePoint.
   
2. A Python script is executed to locate the SLCs and generate configuration files:
   - A bounding box is generated based on the minimum and maximum longitude/latitude of all SLCs.
   - A list of dates is generated for which we need to download orbit data.

3. All relevant files are downloaded from various data sources. This step is parallelized:
   - ASF-Search is used to download SLC data from EarthData.
   - DEM data is downloaded based on the generated bounding box.
   - AUX file is downloaded via `wget`.
   - Orbit data is downloaded for the specified dates.

4. The `stackSentinel.py` script is run to generate the run files.

5. All run files are executed sequentially to obtain the results.

## Docker Instructions

A Dockerfile is included with this task.

1. To build the Docker image, navigate to the project directory and run:
    ```bash
    docker build -t isce -f task/Dockerfile . 
    ```
2. Once the image is built, you can run the pipeline with the following command:
    ```bash
    docker run -v ~/.netrc:/root/.netrc -v artifacts:/app/task/artifacts isce task/do run
    ```

## Assumptions/Corrections
- The bounding box for the DEM is defined using the coordinates S (minimum latitude), N (maximum latitude), W (minimum longitude), and E (maximum longitude). The script calculates these values from the SLC coordinates and intersects them with the bounding box for AOI.geojson to determine the final bounding box.
- The orbit data required by `stackSentinel.py` was not properly aligned with the data fetched by `dloadOrbits.py`. To resolve this, the script now automatically retrieves the necessary orbit data during the builder process.
- There was an issue with downloading the `AOI.geojson` file from OneDrive, so it was pre-downloaded and stored in the repository.
