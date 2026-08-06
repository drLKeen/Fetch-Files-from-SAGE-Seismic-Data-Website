
Homepage
Primary navigation
Project

    F
    Fetch Files from SAGE Seismic Data Website

        Merge requests
        0
        Repository
        Branches
        Commits
        Tags
        Repository graph
        Compare revisions
        Snippets

    avatarWW Edu Technical
    Demos
    Fetch Files from SAGE Seismic Data Website
    Repository

Files

    LIC‎ENSE‎
    READ‎ME.md‎
    SECUR‎ITY.md‎
    image‎1.png‎
    image‎2.png‎
    sageFet‎chObj.m‎
    sagefetcjo‎bjExample.m‎ 

    Fetch-Files-SAGE
    README.md

README.md
Kostas Leptokaropoulos's avatar
Edit README.md - adding images
Kostas Leptokaropoulos authored 3 weeks ago
b7329ada
README.md
2.75 KiB
Fetch Files from SAGE Seismic Data Website Open in MATLAB Online

This repository simplifies access to those services from MATLAB®, enabling users to retrieve seismic waveform data in formats such as MiniSEED and SAC, import them directly into MATLAB, and integrate them into existing analysis workflows without manual URL construction or file handling.

A workflow for automatically accessing data from the SAGE (Seismological Facility for the Advancement of Geoscience, formerly IRIS) seismic data services via the IRISWS interface. The FDSNWS interface provided by SAGE no longer offers a variety of file types and appears to be updated less frequently. All files available through FDSNWS are also available through IRISWS.

This workflow allows you to:

    Specify IRISWS (timeseries) dataselect parameters in a single table.
    Programmatically build a standards-compliant URL.
    Retrieve and parse seismic traces (MiniSEED or SAC) directly into MATLAB®.

Examples on how to plot and process the data provided.

The code centers around the sageFetchObj.m object, which contains functions to call for retrieving data based on variable inputs.
example image 1 example image 2
Prerequisites

    MATLAB® (R2019b or newer)

    At least one of the following third-party MATLAB File Exchange utilities by François Beauducel must be installed on your MATLAB path::
        rdmseed (for MiniSEED)
        rdsac (for SAC)

    rdmseed/mkmseed: https://www.mathworks.com/matlabcentral/fileexchange/28803-rdmseed-and-mkmseed-read-and-write-miniseed-files

    rdsac/mksac: https://www.mathworks.com/matlabcentral/fileexchange/46356-rdsac-and-mksac-read-and-write-sac-seismic-data-file

Note: These third-party utilities are not included with this repository and must be installed separately.
General Troubleshooting

No data returned / 404

    Verify network, station, channel, and time window.
    Try broadening the time range or removing optional filters (e.g., quality).
    Confirm the service endpoint (IRISWS timeseries vs FDSN dataselect) matches your ws setting.

Decoding errors

    Ensure rdmseed is installed for MiniSEED and rdsac for SAC.
    Confirm that the selected file_format aligns with the parser you have.

Timestamp issues

    Use datetime(..., 'ConvertFrom','datenum') as shown to visualize real time.
    Check for timezone assumptions in headers if times look shifted.

Authentication

    If using useAuth = true, make sure you have valid credentials and that sageFetch supports injecting them into requests.

