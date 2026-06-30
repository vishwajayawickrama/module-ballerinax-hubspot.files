# Ballerina HubSpot Files connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-hubspot.files/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.files/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-hubspot.files.svg)](https://github.com/ballerina-platform/module-ballerinax-hubspot.files/commits/master)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/hubspot.files.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%hubspot.files)

## Overview

The [HubSpot Files API](https://developers.hubspot.com/docs/api/files/files) provides a way to upload, manage, and organize files and folders within your HubSpot account's file manager. This Ballerina connector for HubSpot Files wraps the HubSpot Files REST API v3, enabling developers to programmatically upload and replace files, create and manage folder hierarchies, search for files and folders, generate signed URLs for temporary file access, and import files from external URLs asynchronously. The connector supports HubSpot's private app token and API key authentication methods, making it straightforward to integrate HubSpot file management into any Ballerina application.

## Setup guide

To use the HubSpot Files connector, you need a HubSpot account and either a Private App token or an API key.

### Step 1: Create a HubSpot Private App

1. Log in to your [HubSpot account](https://app.hubspot.com/).
2. Navigate to **Settings** → **Integrations** → **Private Apps**.
3. Click **Create a private app**.
4. Give the app a name and select the required scopes under **Files** (e.g., `files`, `files.ui_hidden.read`).
5. Click **Create app** and copy the generated **Access Token**.

### Step 2: Configure the connector

Create a `Config.toml` file in your Ballerina project with your credentials:

```toml
privateAppToken = "<your-hubspot-private-app-token>"
```

Then initialize the connector in your Ballerina code:

```ballerina
import ballerinax/hubspot.files;

configurable string privateAppToken = ?;

files:Client hubspotClient = check new ({
    auth: {
        token: privateAppToken
    }
});
```

## Quickstart

The following example shows how to search for files in your HubSpot account and retrieve a signed URL for temporary access.

### Step 1: Create a `Config.toml`

```toml
privateAppToken = "<your-hubspot-private-app-token>"
```

### Step 2: Write your Ballerina program

```ballerina
import ballerina/io;
import ballerinax/hubspot.files;

configurable string privateAppToken = ?;

public function main() returns error? {
    files:Client hubspotClient = check new ({
        auth: {token: privateAppToken}
    });

    // Search for recently uploaded files
    files:CollectionResponseFile results = check hubspotClient->/files/v3/files/search();
    io:println("Total files found: ", results.results.length());

    if results.results.length() > 0 {
        files:File firstFile = results.results[0];
        io:println("First file: ", firstFile.name ?: "unnamed", " (ID: ", firstFile.id, ")");

        // Generate a signed URL for temporary access (1 hour)
        files:SignedUrl signedUrl = check hubspotClient->/files/v3/files/[firstFile.id]/signed\-url(
            queries = {expirationSeconds: 3600}
        );
        io:println("Signed URL: ", signedUrl.url);
    }
}
```

## Examples

The `HubSpot Files` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-hubspot.files/tree/main/examples/), covering the following use cases:

- [file-upload-signed-url](examples/file-upload-signed-url) — Create a folder, search files, and generate signed URLs for temporary sharing

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`hubspot.files` package](https://central.ballerina.io/ballerinax/hubspot.files/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
