# Containerize the go application that we have created
# This is the Dockerfile that we will use to build the image
# and run the container

# This is the base image fromwhere we are building the Dockerfile
FROM golang:1.22.5 as base

# This is the workdirectory where our entire dockerfile will get executed.
# From Now what ever the commands we are writing are going to be executed inside /app folder
WORKDIR /app

#The dependencies of the application are copied here
COPY go.mod .

# command to download the dependencies if updated by developer in future
RUN go mod download

#Copying the source code in the docker file
COPY . .

#Building the application.
#After executing the command an artifact called main or binary called man will be created in the dockerimage.
RUN go build -o main .

#Final Stage - Creating a distroless image( to reduce the size of the image)
# We will use a distroless image to run the application
FROM gcr.io/distroless/base

#Copying the build i.e., "main" which is in /app folder of stage-1 to the default folder
COPY --from=base /app/main .

# Copy the static files from the previous build
COPY --from=base /app/static /static

#The port where we are exposing our application
EXPOSE 8080

# Command to run the application which is inside the dockerfile
CMD ["./main"]

