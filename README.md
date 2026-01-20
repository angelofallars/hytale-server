# PandevTale

The server configuration files for PandevTale, the [Hytale](https://hytale.com/) server for the [pandesal.dev](https://pandesal.dev/) community.

## Structure

- `mods.txt` - The list of mods installed in the server, from CurseForge.
               The mod URLs are sourced by downloading a mod from CurseForge and then copying the URL where the file was downloaded
               (like `https://mediafilez.forgecdn.net/files/7491/939/EyeSpy-2026.1.20-5708.jar`), then only keeping the last three subpaths.
- `config/` - Configuration files for mods like LuckPerms and Server Optimizer.
- `Dockerfile` / `docker-compose.yml` - Configuration files for the Docker instance that runs the server.

## Deployment

Any changes to the `mods.txt` file, mod configs in `config/`, and `docker-compose.yml` in the main branch will trigger **Continuous Deployment** pipelines in GitHub Actions to
immediately deploy the changes to the live Hytale server and restart the server instance, ensuring updates are swiftly delivered to players.
