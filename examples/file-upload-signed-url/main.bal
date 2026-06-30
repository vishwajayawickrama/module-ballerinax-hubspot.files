// Organize files in HubSpot: create a folder, search existing files, and generate signed URLs for sharing.
// This example demonstrates folder creation, file search, and signed URL generation workflows.

import ballerina/io;
import ballerinax/hubspot.files;

// Configuration — create a Config.toml with these values before running:
// privateAppToken = "<your-hubspot-private-app-token>"
configurable string privateAppToken = ?;

public function main() returns error? {
    files:Client hubspotClient = check new ({
        auth: {
            token: privateAppToken
        }
    });

    // Step 1: Create a folder for organizing campaign assets
    io:println("Step 1: Creating a campaign assets folder...");
    files:FolderInput folderInput = {
        name: "campaign-assets-2024",
        parentFolderId: "0"
    };
    files:Folder newFolder = check hubspotClient->/files/v3/folders.post(folderInput);
    io:println("Created folder: ", newFolder.name ?: "unnamed", " (ID: ", newFolder.id, ")");

    // Step 2: Search for files in the new folder
    io:println("\nStep 2: Searching for files in the folder...");
    int folderId = check int:fromString(newFolder.id);
    files:CollectionResponseFile searchResults = check hubspotClient->/files/v3/files/search(
        queries = {
            parentFolderIds: [folderId]
        }
    );
    io:println("Files found: ", searchResults.results.length());

    if searchResults.results.length() == 0 {
        io:println("No files in the folder yet. Searching all accessible files instead...");
        files:CollectionResponseFile allFiles = check hubspotClient->/files/v3/files/search();
        io:println("Total accessible files: ", allFiles.results.length());

        if allFiles.results.length() > 0 {
            files:File firstFile = allFiles.results[0];
            io:println("\nStep 3: Generating a signed URL for file: ", firstFile.name ?: "unnamed");

            // Step 3: Generate a signed URL for temporary sharing (expires in 1 hour)
            files:SignedUrl signedUrl = check hubspotClient->/files/v3/files/[firstFile.id]/signed\-url(
                queries = {
                    expirationSeconds: 3600
                }
            );
            io:println("Signed URL: ", signedUrl.url);
            io:println("Expires at: ", signedUrl.expiresAt);
        }
    } else {
        files:File firstFile = searchResults.results[0];
        io:println("\nStep 3: Generating a signed URL for file: ", firstFile.name ?: "unnamed");

        // Step 3: Generate a signed URL for temporary sharing (expires in 1 hour)
        files:SignedUrl signedUrl = check hubspotClient->/files/v3/files/[firstFile.id]/signed\-url(
            queries = {
                expirationSeconds: 3600
            }
        );
        io:println("Signed URL: ", signedUrl.url);
        io:println("Expires at: ", signedUrl.expiresAt);
    }

    // Step 4: Retrieve the created folder details
    io:println("\nStep 4: Retrieving folder details...");
    files:Folder folderDetails = check hubspotClient->/files/v3/folders/[newFolder.id]();
    io:println("Folder name: ", folderDetails.name ?: "unnamed");
    io:println("Folder created at: ", folderDetails.createdAt);
    io:println("Folder updated at: ", folderDetails.updatedAt);

    io:println("\nWorkflow complete!");
}
