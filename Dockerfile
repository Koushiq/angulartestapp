# Stage 0, "build-stage", based on Node.js, to build and compile the frontend
FROM node:14.21.2 as build-stage
# Set the working directory in the container
WORKDIR /app

# Copy the package.json and package-lock.json files to the container
COPY package*.json ./

# Check npm version
RUN npm -version

# Change npm version
RUN npm install -g npm@6.14.17

# Install Angular CLI globally
RUN npm install -g @angular/cli@14.2.12

# Install application dependencies
RUN npm install

# Copy the application code to the container
COPY . .

# Build the Angular app
RUN ng build --configuration production

# Stage 1, based on Nginx, to have only the compiled app, ready for production with Nginx
FROM nginx
#Copy ci-dashboard-dist
COPY --from=build-stage /app/dist/out/ /usr/share/nginx/html
#Copy default nginx configuration
COPY ./nginx-custom.conf /etc/nginx/conf.d/default.conf