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
import ballerina/os;
import ballerina/test;
import ballerinax/hubspot.files.mock.server as _;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.hubapi.com" : "http://localhost:9090";
final string token = isLiveServer ? os:getEnv("HUBSPOT_TOKEN") : "test_token";

final Client hubspotClient = check new (
    config = {
        auth: {token}
    },
    serviceUrl = serviceUrl
);

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetFileById() returns error? {
    File response = check hubspotClient->/files/v3/files/["11111"];
    test:assertTrue(response.id != "", "File ID should not be empty");
    test:assertTrue(response.access != "", "File access should not be empty");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testSearchFiles() returns error? {
    CollectionResponseFile response = check hubspotClient->/files/v3/files/search();
    test:assertTrue(response.results.length() > 0, "Search should return at least one file");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetFileByPath() returns error? {
    FileStat response = check hubspotClient->/files/v3/files/stat/["uploads/sample-image.jpg"];
    test:assertTrue(response.file != () || response.folder != (), "FileStat should have a file or folder");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetSignedUrl() returns error? {
    SignedUrl response = check hubspotClient->/files/v3/files/["11111"]/signed\-url();
    test:assertTrue(response.url != "", "Signed URL should not be empty");
    test:assertTrue(response.expiresAt != "", "Expiry should not be empty");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCheckImportStatus() returns error? {
    FileActionResponse response = check hubspotClient->/files/v3/files/import\-from\-url/async/tasks/["task-abc123"]/status();
    test:assertTrue(response.taskId != "", "Task ID should not be empty");
    test:assertTrue(response.status != "", "Status should not be empty");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testImportFileFromUrl() returns error? {
    ImportFromUrlInput payload = {
        url: "https://example.com/sample-image.jpg",
        access: "PUBLIC_INDEXABLE",
        folderPath: "/imports",
        name: "imported-sample.jpg"
    };
    ImportFromUrlTaskLocator response = check hubspotClient->/files/v3/files/import\-from\-url/async.post(payload);
    test:assertTrue(response.id != "", "Import task ID should not be empty");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testUpdateFileProperties() returns error? {
    FileUpdateInput payload = {
        name: "updated-hero-banner.jpg",
        access: "PUBLIC_INDEXABLE",
        isUsableInContent: true
    };
    File response = check hubspotClient->/files/v3/files/["11111"].patch(payload);
    test:assertTrue(response.id != "", "Updated file ID should not be empty");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testDeleteFile() returns error? {
    http:Response response = check hubspotClient->/files/v3/files/["11111"].delete();
    test:assertTrue(response.statusCode == 204, "Delete should return 204 No Content");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGdprDeleteFile() returns error? {
    http:Response response = check hubspotClient->/files/v3/files/["11111"]/gdpr\-delete.delete();
    test:assertTrue(response.statusCode == 204, "GDPR delete should return 204 No Content");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testGetFolderById() returns error? {
    Folder response = check hubspotClient->/files/v3/folders/["12345"];
    test:assertTrue(response.id != "", "Folder ID should not be empty");
    test:assertTrue(response.name != (), "Folder name should not be null");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testSearchFolders() returns error? {
    CollectionResponseFolder response = check hubspotClient->/files/v3/folders/search();
    test:assertTrue(response.results.length() > 0, "Search should return at least one folder");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCreateFolder() returns error? {
    FolderInput payload = {
        name: "test-folder",
        parentFolderId: "0"
    };
    Folder response = check hubspotClient->/files/v3/folders.post(payload);
    test:assertTrue(response.id != "", "Created folder ID should not be empty");
    test:assertTrue(response.name != (), "Created folder name should not be null");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testUpdateFolderProperties() returns error? {
    FolderUpdateInput payload = {
        name: "updated-folder-name"
    };
    Folder response = check hubspotClient->/files/v3/folders/["12345"].patch(payload);
    test:assertTrue(response.id != "", "Updated folder ID should not be empty");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testUpdateFolderPropertiesAsync() returns error? {
    FolderUpdateInputWithId payload = {
        id: "12345",
        name: "async-updated-folder"
    };
    FolderUpdateTaskLocator response = check hubspotClient->/files/v3/folders/update/async.post(payload);
    test:assertTrue(response.id != "", "Folder update task ID should not be empty");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testCheckFolderUpdateStatus() returns error? {
    FolderActionResponse response = check hubspotClient->/files/v3/folders/update/async/tasks/["task-def456"]/status();
    test:assertTrue(response.taskId != "", "Task ID should not be empty");
    test:assertTrue(response.status != "", "Status should not be empty");
}

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
function testDeleteFolder() returns error? {
    http:Response response = check hubspotClient->/files/v3/folders/["12345"].delete();
    test:assertTrue(response.statusCode == 204, "Delete folder should return 204 No Content");
}
