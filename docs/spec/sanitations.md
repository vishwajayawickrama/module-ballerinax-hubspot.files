_Author_: vishwajayawickrama \
_Created_: 2026-06-29 \
_Updated_: 2026-06-29 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from HubSpot Files API.
The OpenAPI specification is obtained from the HubSpot API documentation (https://developers.hubspot.com/docs/reference/api).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.

<!-- auto-generated -->
1. **Added summary and description to `GET /files/v3/files/{fileId}/download`**: The original spec had empty `summary` and `description` fields for this operation. Added `"Download file by ID"` and `"Download a file by its ID."` respectively. Also added a description for the `fileId` path parameter.
   - Original: `"summary": ""`, `"description": ""`
   - Updated: `"summary": "Download file by ID"`, `"description": "Download a file by its ID."`
   - Reason: Operations with missing descriptions reduce usability of the generated client documentation.

<!-- auto-generated -->
2. **Renamed schema `V3FilesBody` to `FileUploadRequest`**: The original auto-generated name `V3FilesBody` was derived mechanically from the URL path and was not descriptive. Renamed to `FileUploadRequest` to clearly reflect its purpose as the multipart form data for uploading a file.
   - Original: `"V3FilesBody"`
   - Updated: `"FileUploadRequest"`
   - Reason: Generic schema names reduce code readability. The new name clearly identifies the schema as the upload request body.

<!-- auto-generated -->
3. **Renamed schema `FilesfileIdBody` to `FileReplaceRequest`**: The original auto-generated name `FilesfileIdBody` was derived mechanically from the URL path and was not descriptive. Renamed to `FileReplaceRequest` to clearly reflect its purpose as the request body for replacing a file.
   - Original: `"FilesfileIdBody"`
   - Updated: `"FileReplaceRequest"`
   - Reason: Generic schema names reduce code readability. The new name clearly identifies the schema as the file replacement request body.

<!-- auto-generated -->
4. **Added descriptions to schemas with empty description fields**: The following schemas had empty or missing `description` fields. Descriptions were added to improve documentation quality:
   - `FileUploadRequest`: "Multipart form data for uploading a new file to the HubSpot file manager."
   - `FileReplaceRequest`: "Multipart form data for replacing an existing file's content in the file manager."
   - `FolderActionResponse`: "Response object for asynchronous folder actions, containing task status and result details."
   - `FileActionResponse`: "Response object for asynchronous file actions, containing task status and result details."
   - `Paging`: "Paging information for navigating through paginated API responses."
   - `Folder`: "Represents a folder in the HubSpot file manager."
   - `CollectionResponseFolder`: "Paginated collection of folders."
   - `FileStat`: "Represents the result of a file stat lookup, containing either a file or a folder."
   - `ImportFromUrlInput`: "Input for asynchronously importing a file from an external URL into the HubSpot file manager."
   - `FolderUpdateInputWithId`: "Input for asynchronously updating folder properties, including the folder ID to identify the target."
   - `ErrorDetail`: "Detailed information about a specific error that occurred in an API request."
   - Reason: Empty schema descriptions reduce the quality of generated documentation.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json --mode client --license-file LICENSE -o ballerina
```

Note: The license year is hardcoded to 2024, change if necessary.
