# Tests

The test suite covers all 19 resource operations exposed by the HubSpot Files API connector, including: retrieving files by ID and path, searching files and folders, creating folders, updating file and folder properties (synchronous and asynchronous), generating signed URLs, deleting files and folders, GDPR-compliant file deletion, importing files from external URLs, and checking async task statuses.

## Running Tests

```bash
bal test
```

The test suite uses a mock server (`modules/mock.server/`) that intercepts HTTP calls so no real credentials are required.
