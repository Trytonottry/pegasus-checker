FROM python:3.11-slim


# Install system dependencies
RUN apt-get update && apt-get install -y \
adb \
libimobiledevice6 libimobiledevice-utils \
usbmuxd \
git curl gnupg unzip \
&& rm -rf /var/lib/apt/lists/*


# Install MVT
RUN pip install --no-cache-dir mvt


# Set working directory
WORKDIR /app
COPY . /app


# Default command
CMD ["python3", "cli.py", "scan"]