# boozemart.db
This repo has the source code of the Boozemart database.

## build.sh
This command will create a Docker image to run the database.

```
sudo sh build.sh
```
## run.sh
Starts or stops the database container.
```
sh run.sh [--start] [--stop]

Arguments:
-?|-h|--help    Shows how to use the command and it's arguments.
--start         Start Boozemart DB.
--stop          Stop Boozemart DB.
```
