# ucl_data_engineering_2022
Repository for the Data Engineering 2022 UCL course

# Creating a local postgres instance with docker
To have your own personal postgres instance on your local machine accessible from your terminal, we have created some docker scripts that
you can use. From your terminal, change your current working directory to docker_local_db folder from inside this git repository and run
the following commands.
    docker build -t ucl_db . 
    docker run -p 5433:5432 --name ucl_postgres_container ucl_db

    Run this in a separate terminal tab or instance (or if you wish check docker documentation and see how you can run container in detached mode).
    psql -h localhost -p 5433 -U postgres -d my_ucl_db 

Remember, this will not hold the information from the database because it doesn't have any volumes mapped. If you wish to retain the data, check the
docker documentation on how to map volumes to your container.


