# File Upload and Signed URL

This example demonstrates how to organize files in HubSpot using the Files API. It creates a dedicated folder for campaign assets, searches for existing files, and generates a signed URL for temporary file sharing. The signed URL expires after a configurable duration, making it safe to distribute for time-limited access.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- Push the connector to the local repository:
  ```bash
  cd ballerina
  bal pack && bal push --repository=local
  ```
- Create a `Config.toml` in this directory:
  ```toml
  privateAppToken = "<your-hubspot-private-app-token>"
  ```

## Run the example

```bash
bal run
```
