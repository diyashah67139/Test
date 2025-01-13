# Docker image with PYTHON3 and DEPENDENCES for pyodbc with MS ODBC 17 DRIVER, Debian GNU/Linux 10 (buster)
# BY TADEO RUBIO
# Using the official Python image, Tag 3.8.3-buster
FROM python:3.13.0-buster
# Set the working directory inside the container to /app
WORKDIR /app

# Install essential packages and clean up to reduce image size
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential \
    curl \
    apt-utils \
    gnupg2 &&\
    rm -rf /var/lib/apt/lists/* && \
    pip install --upgrade pip

# Re-update apt packages after cleaning up in the previous step
RUN apt-get update

# Add the Microsoft repository GPG keys to the list of trusted keys
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

# Add the Microsoft package repository to the system
RUN curl https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list 

# Dummy command to ensure previous RUN commands succeed before proceeding
RUN exit

# Update apt-get with new sources from Microsoft
RUN apt-get update

# Install the Microsoft ODBC SQL Driver 18
RUN env ACCEPT_EULA=Y apt-get install -y msodbcsql18 

# Copy the requirements file into the container at /app
COPY requirements.txt .

# Copy the ODBC configuration file into the container at the root directory
COPY /odbc.ini / 

# Register the SQL Server data source name specified in odbc.ini
RUN odbcinst -i -s -f /odbc.ini -l

# Display the contents of the ODBC configuration file to verify correct setup
RUN cat /etc/odbc.ini

# Install Python dependencies defined in requirements.txt
RUN pip install -r requirements.txt
# RUN apt-get update && \
#     apt-get install -y --no-install-recommends build-essential \
#     curl \
#     apt-utils \
#     gnupg2 &&\
#     rm -rf /var/lib/apt/lists/* && \
#     pip install --upgrade pip

# # UPDATE APT-GET
# RUN apt-get update

# # PYODBC DEPENDENCES
# RUN apt-get install -y tdsodbc unixodbc-dev
# RUN apt install unixodbc-bin -y
# RUN apt-get clean -y
# ADD odbcinst.ini /etc/odbcinst.ini

# # UPGRADE pip3
# RUN pip3 install --upgrade pip

# # DEPENDECES FOR DOWNLOAD ODBC DRIVER
# RUN apt-get install apt-transport-https 
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
# RUN curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
# RUN apt-get update
# RUN env ACCEPT_EULA=Y apt-get install -y MSODBCSQL17
# # INSTALL ODBC DRIVER
# RUN ACCEPT_EULA=Y apt-get install msodbcsql17 --assume-yes

# # CONFIGURE ENV FOR /bin/bash TO USE MSODBCSQL17
# RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile 
# RUN echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc 









# Use the official Python image for Python 3.13.0 and Debian Buster
# FROM python:3.13.0-buster

# # Update and install dependencies
# RUN apt-get update && apt-get install -y \
#     tdsodbc \
#     unixodbc-dev \
#     unixodbc-bin \
#     apt-transport-https \
#     curl \
#     && apt-get clean

# # Add Microsoft package repository for ODBC Driver 17
# RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
#     curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
#     apt-get update && \
#     ACCEPT_EULA=Y apt-get install -y msodbcsql17 && \
#     apt-get clean

# # Add ODBC configuration file
# ADD odbcinst.ini /etc/odbcinst.ini

# # Upgrade pip to the latest version
# RUN pip3 install --no-cache-dir --upgrade pip

# # Configure environment for ODBC tools
# ENV PATH="/opt/mssql-tools/bin:$PATH"

# # Set a default working directory
# WORKDIR /app

# # Copy project files (if any)
# COPY . /app

# # Install project dependencies (if requirements.txt is provided)
# # RUN pip3 install --no-cache-dir -r requirements.txt

# # Set the default command (optional)
# CMD ["bash"]
