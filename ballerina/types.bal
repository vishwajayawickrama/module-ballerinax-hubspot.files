// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com)
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;

# Represents a standard error response in the HubSpot API, providing detailed information about an error that occurred during an API request.
public type StandardError record {
    # A more specific error category within each main category.
    record {} subCategory?;
    # Additional context-specific information related to the error.
    record {|string[]...;|} context;
    # URLs linking to documentation or resources associated with the error.
    record {|string...;|} links;
    # A unique ID for the error instance.
    string id?;
    # The main category of the error.
    string category;
    # A human-readable string describing the error and possible remediation steps.
    string message;
    # The detailed error objects.
    ErrorDetail[] errors;
    # The HTTP status code associated with the error.
    string status;
};

# Multipart form data for uploading a new file to the HubSpot file manager.
public type FileUploadRequest record {
    # Either 'folderPath' or 'folderId' is required. This field represents the destination folder path for the uploaded file. If a path doesn't exist, the system will try to create one.
    string folderPath?;
    # Desired name for the uploaded file.
    string fileName?;
    # File to be uploaded.
    record {byte[] fileContent; string fileName;} file?;
    # JSON string representing FileUploadOptions.
    string options?;
    # Either 'folderId' or 'folderPath' is required. folderId is the ID of the folder the file will be uploaded to.
    string folderId?;
    # Character set of the uploaded file.
    string charsetHunch?;
};

# Represents a folder in the HubSpot file manager.
public type Folder record {
    # Marks whether the folder is deleted or not.
    boolean archived;
    # Timestamp of folder deletion.
    string archivedAt?;
    # Timestamp of folder creation.
    string createdAt;
    # Path of the folder in the file manager.
    string path?;
    # ID of the parent folder.
    string parentFolderId?;
    # Name of the folder.
    string name?;
    # ID of the folder.
    string id;
    # Timestamp of the latest update to the folder.
    string updatedAt;
};

# Represents the Queries record for the operation: get-/files/v3/folders/{folderPath}_getByPath
public type GetFilesV3FoldersFolderPathGetByPathQueries record {
    # Properties to set on returned folder.
    string[] properties?;
};

# Detailed information about a specific error that occurred in an API request.
public type ErrorDetail record {
    # A specific category that contains more specific detail about the error
    string subCategory?;
    # The status code associated with the error detail
    string code?;
    # The name of the field or parameter in which the error was found.
    string 'in?;
    # Context about the error condition
    record {|string[]...;|} context?;
    # A human readable message describing the error along with remediation steps where appropriate
    string message;
};

# Response object for asynchronous file actions, containing task status and result details.
public type FileActionResponse record {
    File result?;
    # Time of completion of task.
    string completedAt;
    # Number of errors resulting from the task.
    int:Signed32 numErrors?;
    # Timestamp of when the task was requested.
    string requestedAt?;
    # Timestamp of when the task was started.
    string startedAt;
    # Link to check the status of the requested task.
    record {|string...;|} links?;
    # Descriptive error messages.
    StandardError[] errors?;
    # ID of the requested task.
    string taskId;
    # Current status of the task.
    "CANCELED"|"COMPLETE"|"PENDING"|"PROCESSING" status;
};

# Paginated collection of folders.
public type CollectionResponseFolder record {
    Paging paging?;
    Folder[] results;
};

# Represents the result of a file stat lookup, containing either a file or a folder.
public type FileStat record {
    File file?;
    Folder folder?;
};

# Object for updating files.
public type FileUpdateInput record {
    # NONE: Do not run any duplicate validation. REJECT: Reject the upload if a duplicate is found. RETURN_EXISTING: If a duplicate file is found, do not upload a new file and return the found duplicate instead.
    "HIDDEN_INDEXABLE"|"HIDDEN_NOT_INDEXABLE"|"HIDDEN_PRIVATE"|"HIDDEN_SENSITIVE"|"PRIVATE"|"PUBLIC_INDEXABLE"|"PUBLIC_NOT_INDEXABLE"|"SENSITIVE" access?;
    # FolderId where the file should be moved to. folderId and folderPath parameters cannot be set at the same time.
    string parentFolderId?;
    # New name for the file.
    string name?;
    # Folder path where the file should be moved to. folderId and folderPath parameters cannot be set at the same time.
    string parentFolderPath?;
    boolean clearExpires?;
    # Mark whether the file should be used in new content or not.
    boolean isUsableInContent?;
    string expiresAt?;
};

# Represents the Queries record for the operation: get-/files/v3/files/{fileId}/signed-url_getSignedUrl
public type GetFilesV3FilesFileIdSignedUrlGetSignedUrlQueries record {
    # For image files. This will resize the image to the desired size before sharing. Does not affect the original file, just the file served by this signed URL.
    "icon"|"medium"|"preview"|"thumb" size?;
    # If size is provided, this will upscale the image to fit the size dimensions.
    boolean upscale?;
    # How long in seconds the link will provide access to the file.
    int expirationSeconds?;
};

# Object for creating a folder.
public type FolderInput record {
    # FolderId of the parent of the created folder. If not specified, the folder will be created at the root level. parentFolderId and parentFolderPath cannot be set at the same time.
    string parentFolderId?;
    # Path of the parent of the created folder. If not specified the folder will be created at the root level. parentFolderPath and parentFolderId cannot be set at the same time.
    string parentPath?;
    # Desired name for the folder.
    string name;
};

# Represents the Queries record for the operation: get-/files/v3/files/stat/{path}_getMetadata
public type GetFilesV3FilesStatPathGetMetadataQueries record {
    # 
    string[] properties?;
};

# Represents the Queries record for the operation: get-/files/v3/folders/search_doSearch
public type GetFilesV3FoldersSearchDoSearchQueries record {
    # Search folders by greater than or equal to time of creation. Can be used with createdAtLte to create a range.
    string createdAtGte?;
    # Search folders by greater than or equal to time of latest update. Can be used with updatedAtLte to create a range.
    string updatedAtGte?;
    # Search folders updated before this timestamp. Time must be epoch time in milliseconds.
    string before?;
    # 
    int[] parentFolderIds?;
    # Search folders by less than or equal to time of latest update. Can be used with updatedAtGte to create a range.
    string updatedAtLte?;
    # Search folders by greater than or equal to ID. Can be used with idLte to create a range.
    int idGte?;
    # Sort results by given property. For example -name sorts by name field descending, name sorts by name field ascending.
    string[] sort?;
    # Search folders by exact time of creation. Time must be epoch time in milliseconds.
    string createdAt?;
    # Search folders by path.
    string path?;
    # Search folders by less than or equal to ID. Can be used with idGte to create a range.
    int idLte?;
    # Number of items to return. Default limit is 10, maximum limit is 100.
    int:Signed32 'limit?;
    # Search for folders containing the specified name.
    string name?;
    # Search folders by multiple IDs. Comma-separated list of folder IDs.
    int[] ids?;
    # Offset search results by this value. The default offset is 0 and the maximum offset of items for a given search is 10,000.  Narrow your search down if you are reaching this limit.
    string after?;
    # Search folders by less than or equal to time of creation. Can be used with createdAtGte to create a range.
    string createdAtLte?;
    # Properties that should be included in the returned folders.
    string[] properties?;
    # Search folders by exact time of latest updated. Time must be epoch time in milliseconds.
    string updatedAt?;
};

# OAuth2 Refresh Token Grant Configs
public type OAuth2RefreshTokenGrantConfig record {|
    *http:OAuth2RefreshTokenGrantConfig;
    # Refresh URL
    string refreshUrl = "https://api.hubapi.com/oauth/v1/token";
|};

# Represents the Queries record for the operation: get-/files/v3/folders/{folderId}_getById
public type GetFilesV3FoldersFolderIdGetByIdQueries record {
    # Properties to set on returned folder.
    string[] properties?;
};

# Information on the task that has been started, and where to check it's status.
public type FolderUpdateTaskLocator record {
    # Links for where to check information related to the task. The `status` link gives the URL for where to check the status of the task.
    record {|string...;|} links;
    # ID of the task
    string id;
};

# Provides a set of configurations for controlling the behaviours when communicating with a remote HTTP endpoint.
@display {label: "Connection Config"}
public type ConnectionConfig record {|
    # Provides Auth configurations needed when communicating with a remote HTTP endpoint.
    http:BearerTokenConfig|OAuth2RefreshTokenGrantConfig|ApiKeysConfig auth;
    # The HTTP version understood by the client
    http:HttpVersion httpVersion = http:HTTP_2_0;
    # Configurations related to HTTP/1.x protocol
    ClientHttp1Settings http1Settings?;
    # Configurations related to HTTP/2 protocol
    http:ClientHttp2Settings http2Settings?;
    # The maximum time to wait (in seconds) for a response before closing the connection
    decimal timeout = 60;
    # The choice of setting `forwarded`/`x-forwarded` header
    string forwarded = "disable";
    # Configurations associated with request pooling
    http:PoolConfiguration poolConfig?;
    # HTTP caching related configurations
    http:CacheConfig cache?;
    # Specifies the way of handling compression (`accept-encoding`) header
    http:Compression compression = http:COMPRESSION_AUTO;
    # Configurations associated with the behaviour of the Circuit Breaker
    http:CircuitBreakerConfig circuitBreaker?;
    # Configurations associated with retrying
    http:RetryConfig retryConfig?;
    # Configurations associated with inbound response size limits
    http:ResponseLimitConfigs responseLimits?;
    # SSL/TLS-related options
    http:ClientSecureSocket secureSocket?;
    # Proxy server related options
    http:ProxyConfig proxy?;
    # Enables the inbound payload validation functionality which provided by the constraint package. Enabled by default
    boolean validation = true;
    # Enables relaxed data binding on the client side. When enabled, `nil` values are treated as optional, 
    # and absent fields are handled as `nilable` types. Enabled by default.
    boolean laxDataBinding = true;
|};

# Represents the Queries record for the operation: get-/files/v3/files/search_doSearch
public type GetFilesV3FilesSearchDoSearchQueries record {
    # Search files by given extension.
    string extension?;
    # Search files by greater than or equal to time of latest update. Can be used with updatedAtLte to create a range.
    string updatedAtGte?;
    # Search files updated before this timestamp. Time must be epoch time in milliseconds.
    string before?;
    # 
    int[] parentFolderIds?;
    # Search files by less than or equal to time of latest update. Can be used with updatedAtGte to create a range.
    string updatedAtLte?;
    # Search files by less than or equal to expires time. Can be used with expiresAtGte to create a range.
    string expiresAtLte?;
    # Search files by greater than or equal to ID. Can be used with idLte to create a range.
    int idGte?;
    # Search files by file type.
    string 'type?;
    # If true shows files that have been marked to be used in new content. It false shows files that should not be used in new content.
    boolean isUsableInContent?;
    # Search files by greater than or equal to expires time. Can be used with expiresAtLte to create a range.
    string expiresAtGte?;
    # Search files by exact time of creation. Time must be epoch time in milliseconds.
    string createdAt?;
    # Search files by path.
    string path?;
    # Number of items to return. Default limit is 10, maximum limit is 100.
    int:Signed32 'limit?;
    # Offset search results by this value. The default offset is 0 and the maximum offset of items for a given search is 10,000.  Narrow your search down if you are reaching this limit.
    string after?;
    # Search files by less than or equal to time of creation. Can be used with createdAtGte to create a range.
    string createdAtLte?;
    # Search files by height of image or video.
    int:Signed32 height?;
    # Search files by exact time of latest updated. Time must be epoch time in milliseconds.
    string updatedAt?;
    # Search files by greater than or equal to time of creation. Can be used with createdAtLte to create a range.
    string createdAtGte?;
    # Search files by less than or equal to file size. Can be used with sizeGte to create a range.
    int sizeLte?;
    # Search files by greater than or equal to width of image or video. Can be used with widthLte to create a range.
    int:Signed32 widthGte?;
    # Search files by less than or equal to width of image or video. Can be used with widthGte to create a range.
    int:Signed32 widthLte?;
    # Search files by greater than or equal to file size. Can be used with sizeLte to create a range.
    int sizeGte?;
    # Search files by access. If 'true' will show only public files; if 'false' will show only private files
    boolean allowsAnonymousAccess?;
    # Search files by specific md5 hash.
    string fileMd5?;
    # Sort files by a given field.
    string[] sort?;
    # Search files by specified encoding.
    string encoding?;
    # Search files by exact expires time. Time must be epoch time in milliseconds.
    string expiresAt?;
    # Search for given URL
    string url?;
    # Search files by less than or equal to height of image or video. Can be used with heightGte to create a range.
    int:Signed32 heightLte?;
    # Search files by less than or equal to ID. Can be used with idGte to create a range.
    int idLte?;
    # Search files by exact file size in bytes.
    int size?;
    # Search files by greater than or equal to height of image or video. Can be used with heightLte to create a range.
    int:Signed32 heightGte?;
    # Search for files containing the given name.
    string name?;
    # Search files by width of image or video.
    int:Signed32 width?;
    # 
    int[] ids?;
    # Desired file properties in the return object.
    string[] properties?;
};

# Object for updating folders.
public type FolderUpdateInput record {
    # New parent folderId. If changed, the folder and all it's children will be moved into the specified folder. parentFolderId and parentFolderPath cannot be specified at the same time.
    int parentFolderId?;
    # New name. If specified the folder's name and fullPath will change. All children of the folder will be updated accordingly.
    string name?;
};

# Paging information for navigating through paginated API responses.
public type Paging record {
    NextPage next?;
    PreviousPage prev?;
};

# Response object for asynchronous folder actions, containing task status and result details.
public type FolderActionResponse record {
    Folder result?;
    # When the requested changes have been completed.
    string completedAt;
    # Number of errors resulting from the requested changes.
    int:Signed32 numErrors?;
    # Timestamp representing when the task was requested.
    string requestedAt?;
    # Timestamp representing when the task was started at.
    string startedAt;
    # Link to check the status of the task.
    record {|string...;|} links?;
    # Detailed errors resulting from the task.
    StandardError[] errors?;
    # ID of the task.
    string taskId;
    # Current status of the task.
    "CANCELED"|"COMPLETE"|"PENDING"|"PROCESSING" status;
};

# Proxy server configurations to be used with the HTTP client endpoint.
public type ProxyConfig record {|
    # Host name of the proxy server
    string host = "";
    # Proxy server port
    int port = 0;
    # Proxy server username
    string userName = "";
    # Proxy server password
    @display {label: "", kind: "password"}
    string password = "";
|};

# Collections of files
public type CollectionResponseFile record {
    Paging paging?;
    File[] results;
};

# Input for asynchronously importing a file from an external URL into the HubSpot file manager.
public type ImportFromUrlInput record {
    # One of folderPath or folderId is required. Destination folder path for the uploaded file. If the folder path does not exist, there will be an attempt to create the folder path.
    string folderPath?;
    # PUBLIC_INDEXABLE: File is publicly accessible by anyone who has the URL. Search engines can index the file. PUBLIC_NOT_INDEXABLE: File is publicly accessible by anyone who has the URL. Search engines *can't* index the file. PRIVATE: File is NOT publicly accessible. Requires a signed URL to see content. Search engines *can't* index the file.
    "HIDDEN_INDEXABLE"|"HIDDEN_NOT_INDEXABLE"|"HIDDEN_PRIVATE"|"HIDDEN_SENSITIVE"|"PRIVATE"|"PUBLIC_INDEXABLE"|"PUBLIC_NOT_INDEXABLE"|"SENSITIVE" access;
    # ENTIRE_PORTAL: Look for a duplicate file in the entire account. EXACT_FOLDER: Look for a duplicate file in the provided folder.
    "ENTIRE_PORTAL"|"EXACT_FOLDER" duplicateValidationScope?;
    # Name to give the resulting file in the file manager.
    string name?;
    # NONE: Do not run any duplicate validation. REJECT: Reject the upload if a duplicate is found. RETURN_EXISTING: If a duplicate file is found, do not upload a new file and return the found duplicate instead.
    "NONE"|"REJECT"|"RETURN_EXISTING" duplicateValidationStrategy?;
    # If true, will overwrite existing file if one with the same name and extension exists in the given folder. The overwritten file will be deleted and the uploaded file will take its place with a new ID. If unset or set as false, the new file's name will be updated to prevent colliding with existing file if one exists with the same path, name, and extension
    boolean overwrite?;
    # Time to live. If specified the file will be deleted after the given time frame. If left unset, the file will exist indefinitely
    string ttl?;
    # Specifies the date and time when the file will expire.
    string expiresAt?;
    # One of folderId or folderPath is required. Destination folderId for the uploaded file.
    string folderId?;
    # URL to download the new file from.
    string url;
};

# Signed Url object with optional ancillary metadata of requested file
public type SignedUrl record {
    # Extension of the requested file.
    string extension;
    # Size in bytes of the requested file.
    int size;
    # Name of the requested file.
    string name;
    # For image and video files. The width of the file.
    int:Signed32 width?;
    # Type of the file. Can be IMG, DOCUMENT, AUDIO, MOVIE, or OTHER.
    string 'type;
    # Timestamp of when the URL will no longer grant access to the file.
    string expiresAt;
    # Signed URL with access to the specified file. Anyone with this URL will be able to access the file until it expires.
    string url;
    # For image and video files. The height of the file.
    int:Signed32 height?;
};

# Multipart form data for replacing an existing file's content in the file manager.
public type FileReplaceRequest record {
    # File data that will replace existing file in the file manager.
    record {byte[] fileContent; string fileName;} file?;
    # JSON string representing FileReplaceOptions. Includes options to set the access and expiresAt properties, which will automatically update when the file is replaced.
    string options?;
    # Character set of given file data.
    string charsetHunch?;
};

# Provides settings related to HTTP/1.x protocol.
public type ClientHttp1Settings record {|
    # Specifies whether to reuse a connection for multiple requests
    http:KeepAlive keepAlive = http:KEEPALIVE_AUTO;
    # The chunking behaviour of the request
    http:Chunking chunking = http:CHUNKING_AUTO;
    # Proxy server related options
    ProxyConfig proxy?;
|};

# specifies the paging information needed to retrieve the previous set of results in a paginated API response
public type PreviousPage record {
    # A paging cursor token for retrieving previous pages.
    string before;
    # A URL that can be used to retrieve the previous pages' results.
    string link?;
};

# Represents the Queries record for the operation: get-/files/v3/files/{fileId}_getById
public type GetFilesV3FilesFileIdGetByIdQueries record {
    # 
    string[] properties?;
};

# Input for asynchronously updating folder properties, including the folder ID to identify the target.
public type FolderUpdateInputWithId record {
    # New parent folderId. If changed, the folder and all it's children will be moved into the specified folder. parentFolderId and parentFolderPath cannot be specified at the same time.
    int parentFolderId?;
    # New name. If specified the folder's name and fullPath will change. All children of the folder will be updated accordingly.
    string name?;
    # The unique identifier of the folder to be updated.
    string id;
};

# Information on the task that has been started, and where to check it's status.
public type ImportFromUrlTaskLocator record {
    # Links for where to check information related to the task. The `status` link gives the URL for where to check the status of the task.
    record {|string...;|} links;
    # ID of the task
    string id;
};

# File
public type File record {
    # Extension of the file. ex: .jpg, .png, .gif, .pdf, etc.
    string extension?;
    # File access. Can be PUBLIC_INDEXABLE, PUBLIC_NOT_INDEXABLE, PRIVATE.
    "HIDDEN_INDEXABLE"|"HIDDEN_NOT_INDEXABLE"|"HIDDEN_PRIVATE"|"HIDDEN_SENSITIVE"|"PRIVATE"|"PUBLIC_INDEXABLE"|"PUBLIC_NOT_INDEXABLE"|"SENSITIVE" access;
    # ID of the folder the file is in.
    string parentFolderId?;
    "CONTENT"|"CONVERSATIONS"|"FORMS"|"UI_EXTENSIONS"|"UNKNOWN" sourceGroup?;
    # The MD5 hash of the file.
    string fileMd5?;
    # Encoding of the file.
    string encoding?;
    # Type of the file. Can be IMG, DOCUMENT, AUDIO, MOVIE, or OTHER.
    string 'type?;
    # Previously "archied". Indicates if the file should be used when creating new content like web pages.
    boolean isUsableInContent?;
    int expiresAt?;
    # URL of the given file. This URL can change depending on the domain settings of the account. Will use the select file hosting domain.
    string url?;
    # If the file is deleted.
    boolean archived;
    # Deletion time of the file object.
    string archivedAt?;
    # Creation time of the file object.
    string createdAt;
    # Path of the file in the file manager.
    string path?;
    # Size of the file in bytes.
    int size?;
    # Name of the file.
    string name?;
    # For image and video files, the width of the content.
    int:Signed32 width?;
    # File ID.
    string id;
    # Default hosting URL of the file. This will use one of HubSpot's provided URLs to serve the file.
    string defaultHostingUrl?;
    # For image and video files, the height of the content.
    int:Signed32 height?;
    # Timestamp of the latest update to the file.
    string updatedAt;
};

# Specifies the paging information needed to retrieve the next set of results in a paginated API response
public type NextPage record {
    # A URL that can be used to retrieve the next page results.
    string link?;
    # A paging cursor token for retrieving subsequent pages.
    string after;
};

# Provides API key configurations needed when communicating with a remote HTTP endpoint.
public type ApiKeysConfig record {|
    string hapikey;
    string private\-app;
    string private\-app\-legacy;
|};
