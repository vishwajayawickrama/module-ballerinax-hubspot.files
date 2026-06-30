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

- [file-upload-signed-url](https://github.com/ballerina-platform/module-ballerinax-hubspot.files/tree/main/examples/file-upload-signed-url) — Create a folder, search files, and generate signed URLs for temporary sharing
