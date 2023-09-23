# java

**EXPERIMENTAL - this has been tested with bunch of different jars, but it's possible some plugins may have incompatibilities.**

This Docker image aims to eliminate having to swap between java versions by automatically detecting the jar's recommended (or fallback to target) version. If it's unable to find the jar that should be executed, it'll default to Java 11.

Currently, the following java versions are included:

* Java 8
* Java 11
* Java 16
* Java 17
* Java 21

Each time the image detects a new startup jar, the user will be prompted to choose the version the jar should be ran with:
![example startup](https://i.imgur.com/Uim0Ese.png)

If the user doesn't select their version inside 30 seconds, it'll default to the automatically detected version. After the initial run, the prompt won't ask any questions from the user. If at any point the choice should be changed, the user can delete the `disable_prompt_for_java_version` file in the root of the server to retrigger the prompt and choose the new desired java version.

## How to use this with WISP/Pterodactyl?

This should work with any existing egg, as long as you update the Docker image for the server, or the egg.

You can switch an individual game server to this image by navigating to admin area > Servers > your server > Startup and changing the image field in the Docker Container Configuration section to `quay.io/wisp/images:java`.

If you want to default all new servers to use this image (or if you're on WISP, it'll also update all existing servers to use that image), all that you need to do is navigate to admin area > Nests > your nest > your egg and change the Docker Image field to `quay.io/wisp/images:java`.

You may also need to rebuild the server container (in admin area of the server, manage tab) to apply the changes for both of these changes.
