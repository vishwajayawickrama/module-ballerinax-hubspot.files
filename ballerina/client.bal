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
import ballerina/mime;

# Upload and manage files.
public isolated client class Client {
    final http:Client clientEp;
    final readonly & ApiKeysConfig? apiKeyConfig;
    # Gets invoked to initialize the `connector`.
    #
    # + config - The configurations to be used when initializing the `connector` 
    # + serviceUrl - URL of the target service 
    # + return - An error if connector initialization failed 
    public isolated function init(ConnectionConfig config, string serviceUrl = "https://api.hubapi.com") returns error? {
        http:ClientConfiguration httpClientConfig = {httpVersion: config.httpVersion, timeout: config.timeout, forwarded: config.forwarded, poolConfig: config.poolConfig, compression: config.compression, circuitBreaker: config.circuitBreaker, retryConfig: config.retryConfig, validation: config.validation};
        do {
            if config.http1Settings is ClientHttp1Settings {
                ClientHttp1Settings settings = check config.http1Settings.ensureType(ClientHttp1Settings);
                httpClientConfig.http1Settings = {...settings};
            }
            if config.http2Settings is http:ClientHttp2Settings {
                httpClientConfig.http2Settings = check config.http2Settings.ensureType(http:ClientHttp2Settings);
            }
            if config.cache is http:CacheConfig {
                httpClientConfig.cache = check config.cache.ensureType(http:CacheConfig);
            }
            if config.responseLimits is http:ResponseLimitConfigs {
                httpClientConfig.responseLimits = check config.responseLimits.ensureType(http:ResponseLimitConfigs);
            }
            if config.secureSocket is http:ClientSecureSocket {
                httpClientConfig.secureSocket = check config.secureSocket.ensureType(http:ClientSecureSocket);
            }
            if config.proxy is http:ProxyConfig {
                httpClientConfig.proxy = check config.proxy.ensureType(http:ProxyConfig);
            }
        }
        if config.auth is ApiKeysConfig {
            self.apiKeyConfig = (<ApiKeysConfig>config.auth).cloneReadOnly();
        } else {
            httpClientConfig.auth = <http:BearerTokenConfig|OAuth2RefreshTokenGrantConfig>config.auth;
            self.apiKeyConfig = ();
        }
        http:Client httpEp = check new (serviceUrl, httpClientConfig);
        self.clientEp = httpEp;
        return;
    }

    # Delete file by ID
    #
    # + fileId - FileId to delete
    # + headers - Headers to be sent with the request 
    # + return - No content 
    resource isolated function delete files/v3/files/[string fileId](map<string|string[]> headers = {}) returns http:Response|error {
        string resourcePath = string `/files/v3/files/${getEncodedUri(fileId)}`;
        return self.clientEp->delete(resourcePath, headers = headers);
    }

    resource isolated function delete files/v3/files/[string fileId]/gdpr\-delete(map<string|string[]> headers = {}) returns http:Response|error {
        string resourcePath = string `/files/v3/files/${getEncodedUri(fileId)}/gdpr-delete`;
        return self.clientEp->delete(resourcePath, headers = headers);
    }

    # Delete folder by ID or path
    #
    # + folderId - ID or path of the folder to delete
    # + headers - Headers to be sent with the request
    # + return - No content
    resource isolated function delete files/v3/folders/[string folderId](map<string|string[]> headers = {}) returns http:Response|error {
        string resourcePath = string `/files/v3/folders/${getEncodedUri(folderId)}`;
        return self.clientEp->delete(resourcePath, headers = headers);
    }

    # Retrieve file by ID
    #
    # + fileId - ID of the desired file.
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get files/v3/files/[string fileId](map<string|string[]> headers = {}, *GetFilesV3FilesFileIdGetByIdQueries queries) returns File|error {
        string resourcePath = string `/files/v3/files/${getEncodedUri(fileId)}`;
        map<Encoding> queryParamEncoding = {"properties": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queries, queryParamEncoding);
        return self.clientEp->get(resourcePath, headers);
    }

    # Download file by ID
    #
    # + fileId - ID of the file to download.
    # + headers - Headers to be sent with the request 
    # + return - An error occurred. 
    resource isolated function get files/v3/files/[string fileId]/download(map<string|string[]> headers = {}) returns http:Response|error {
        string resourcePath = string `/files/v3/files/${getEncodedUri(fileId)}/download`;
        return self.clientEp->get(resourcePath, headers);
    }

    resource isolated function get files/v3/files/[string fileId]/signed\-url(map<string|string[]> headers = {}, *GetFilesV3FilesFileIdSignedUrlGetSignedUrlQueries queries) returns SignedUrl|error {
        string resourcePath = string `/files/v3/files/${getEncodedUri(fileId)}/signed-url`;
        resourcePath = resourcePath + check getPathForQueryParam(queries);
        return self.clientEp->get(resourcePath, headers);
    }

    # Check import status
    #
    # + taskId - Import by URL task ID
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function get files/v3/files/import\-from\-url/async/tasks/[string taskId]/status(map<string|string[]> headers = {}) returns FileActionResponse|error {
        string resourcePath = string `/files/v3/files/import-from-url/async/tasks/${getEncodedUri(taskId)}/status`;
        return self.clientEp->get(resourcePath, headers);
    }

    # Search files
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get files/v3/files/search(map<string|string[]> headers = {}, *GetFilesV3FilesSearchDoSearchQueries queries) returns CollectionResponseFile|error {
        string resourcePath = string `/files/v3/files/search`;
        map<Encoding> queryParamEncoding = {"ids": {style: FORM, explode: true}, "parentFolderIds": {style: FORM, explode: true}, "properties": {style: FORM, explode: true}, "sort": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queries, queryParamEncoding);
        return self.clientEp->get(resourcePath, headers);
    }

    # Retrieve file by path
    #
    # + path -
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get files/v3/files/stat/[string path](map<string|string[]> headers = {}, *GetFilesV3FilesStatPathGetMetadataQueries queries) returns FileStat|error {
        string resourcePath = string `/files/v3/files/stat/${getEncodedUri(path)}`;
        map<Encoding> queryParamEncoding = {"properties": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queries, queryParamEncoding);
        return self.clientEp->get(resourcePath, headers);
    }

    # Retrieve folder by ID or path
    #
    # + folderId - ID or path of the desired folder
    # + headers - Headers to be sent with the request
    # + queries - Queries to be sent with the request
    # + return - successful operation
    resource isolated function get files/v3/folders/[string folderId](map<string|string[]> headers = {}, *GetFilesV3FoldersFolderIdGetByIdQueries queries) returns Folder|error {
        string resourcePath = string `/files/v3/folders/${getEncodedUri(folderId)}`;
        map<Encoding> queryParamEncoding = {"properties": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queries, queryParamEncoding);
        return self.clientEp->get(resourcePath, headers);
    }

    # Search folders
    #
    # + headers - Headers to be sent with the request 
    # + queries - Queries to be sent with the request 
    # + return - successful operation 
    resource isolated function get files/v3/folders/search(map<string|string[]> headers = {}, *GetFilesV3FoldersSearchDoSearchQueries queries) returns CollectionResponseFolder|error {
        string resourcePath = string `/files/v3/folders/search`;
        map<Encoding> queryParamEncoding = {"ids": {style: FORM, explode: true}, "parentFolderIds": {style: FORM, explode: true}, "properties": {style: FORM, explode: true}, "sort": {style: FORM, explode: true}};
        resourcePath = resourcePath + check getPathForQueryParam(queries, queryParamEncoding);
        return self.clientEp->get(resourcePath, headers);
    }

    # Check folder update status
    #
    # + taskId - TaskId of folder update
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function get files/v3/folders/update/async/tasks/[string taskId]/status(map<string|string[]> headers = {}) returns FolderActionResponse|error {
        string resourcePath = string `/files/v3/folders/update/async/tasks/${getEncodedUri(taskId)}/status`;
        return self.clientEp->get(resourcePath, headers);
    }

    # Update file properties
    #
    # + fileId - ID of file to update
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function patch files/v3/files/[string fileId](FileUpdateInput payload, map<string|string[]> headers = {}) returns File|error {
        string resourcePath = string `/files/v3/files/${getEncodedUri(fileId)}`;
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->patch(resourcePath, request, headers);
    }

    # Update folder properties by folder ID
    #
    # + folderId - ID of folder to update
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function patch files/v3/folders/[string folderId](FolderUpdateInput payload, map<string|string[]> headers = {}) returns Folder|error {
        string resourcePath = string `/files/v3/folders/${getEncodedUri(folderId)}`;
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->patch(resourcePath, request, headers);
    }

    # Upload file
    #
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function post files/v3/files(FileUploadRequest payload, map<string|string[]> headers = {}) returns File|error {
        string resourcePath = string `/files/v3/files`;
        http:Request request = new;
        mime:Entity[] bodyParts = check createBodyParts(payload);
        request.setBodyParts(bodyParts);
        return self.clientEp->post(resourcePath, request, headers);
    }

    # Import file from URL
    #
    # + headers - Headers to be sent with the request 
    # + return - accepted 
    resource isolated function post files/v3/files/import\-from\-url/async(ImportFromUrlInput payload, map<string|string[]> headers = {}) returns ImportFromUrlTaskLocator|error {
        string resourcePath = string `/files/v3/files/import-from-url/async`;
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, headers);
    }

    # Create folder
    #
    # + headers - Headers to be sent with the request 
    # + payload - Folder creation options 
    # + return - successful operation 
    resource isolated function post files/v3/folders(FolderInput payload, map<string|string[]> headers = {}) returns Folder|error {
        string resourcePath = string `/files/v3/folders`;
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, headers);
    }

    # Update folder properties
    #
    # + headers - Headers to be sent with the request 
    # + return - accepted 
    resource isolated function post files/v3/folders/update/async(FolderUpdateInputWithId payload, map<string|string[]> headers = {}) returns FolderUpdateTaskLocator|error {
        string resourcePath = string `/files/v3/folders/update/async`;
        http:Request request = new;
        json jsonBody = payload.toJson();
        request.setPayload(jsonBody, "application/json");
        return self.clientEp->post(resourcePath, request, headers);
    }

    # Replace file
    #
    # + fileId - ID of the desired file.
    # + headers - Headers to be sent with the request 
    # + return - successful operation 
    resource isolated function put files/v3/files/[string fileId](FileReplaceRequest payload, map<string|string[]> headers = {}) returns File|error {
        string resourcePath = string `/files/v3/files/${getEncodedUri(fileId)}`;
        http:Request request = new;
        mime:Entity[] bodyParts = check createBodyParts(payload);
        request.setBodyParts(bodyParts);
        return self.clientEp->put(resourcePath, request, headers);
    }
}
