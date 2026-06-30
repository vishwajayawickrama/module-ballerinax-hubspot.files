# Examples

The `ballerinax/hubspot.files` connector provides practical examples illustrating usage in various scenarios.

| Example | Description |
|---------|-------------|
| [`file-upload-signed-url`](./file-upload-signed-url) | Create a folder, search files, and generate signed URLs for temporary sharing |

## Prerequisites

1. Build and push the connector to your local Ballerina repository:
   ```bash
   cd ballerina
   bal pack && bal push --repository=local
   ```

2. For each example, create a `Config.toml` in the example directory:
   ```toml
   privateAppToken = "<your-hubspot-private-app-token>"
   ```

## Running an example

```bash
cd examples/file-upload-signed-url
bal run
```

## Building the examples with the local module

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
