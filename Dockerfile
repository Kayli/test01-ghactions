FROM node:20 as build

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json .
RUN npm install

COPY . .
# why angular/cli is not installed during npm install command?
RUN npm install -g @angular/cli
RUN ng build


# use the latest version of the official nginx image as the base image
FROM nginx:latest as prod
EXPOSE 80

# copy the custom nginx configuration file to the container in the 
# default location
COPY nginx.conf /etc/nginx/nginx.conf

# copy the built Angular app files to the default nginx html directory
COPY --from=build /usr/src/app/dist/myapp/browser /usr/share/nginx/html

